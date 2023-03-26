
# FastAPI + Postgres
This is a template for a FastAPI + Postgres app. It uses Ankra Platform to docker build, helm package, and deploy to a kubernetes cluster.

### pre-requisites

  * docker
  * environment var: DATABASE_URL = postgresql://user:pass@localhost/myapp

# Building the my-app image
### Development image
    docker build --target development -t my-app:dev .

### Production image
    docker build --target production -t my-app:prod .

# Running the my-app image
### Development image
    docker run -p 8000:8000 my-app:dev

