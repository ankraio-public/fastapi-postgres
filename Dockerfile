## Base ########################################################################
FROM python:3.10 as base

# Create a non-root user
RUN adduser --disabled-password --gecos '' appuser
WORKDIR /app
COPY src/ .
RUN chown -R appuser:appuser /app && \
    chmod -R 755 /app && \
    pip install --no-cache-dir -r requirements.txt && \
    apt-get update && apt-get -y upgrade && apt-get -y --no-install-recommends install ca-certificates && apt-get clean && rm -rf /var/lib/apt/lists/*

USER appuser

## Development #################################################################
FROM base as development
WORKDIR /app
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--reload", "--host", "0.0.0.0", "--port", "8000"]

## Production ##################################################################
FROM base as production
WORKDIR /app
RUN python -m compileall .
RUN rm -rf __pycache__
CMD ["gunicorn", "-w", "4", "-k", "uvicorn.workers.UvicornWorker", "app.main:app", "-b", "0.0.0.0:8000"]

## Deploy ######################################################################
FROM python:3-alpine3.18 as deploy
WORKDIR /app
COPY --from=production /app /app
RUN apk --no-cache add ca-certificates
EXPOSE 8000
CMD ["gunicorn", "-w", "4", "-k", "uvicorn.workers.UvicornWorker", "app.main:app", "-b", "0.0.0.0:8000"]
