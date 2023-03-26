import os

from sqlalchemy import (Column, Integer, String, Table, create_engine, MetaData)
from dotenv import load_dotenv
from databases import Database
from datetime import datetime as dt
from pytz import timezone as tz

load_dotenv()
# Database url if none is passed the default one is used
USERNAME = os.getenv(
    "DB_USERNAME", "postgres")
PASSWORD = os.getenv(
    "DB_PASSWORD", "")
DATABASE_URI = os.getenv(
    "DATABASE_URI", "localhost")
DB_NAME = os.getenv(
    "DATABASE_NAME", "myapp")
DATABASE_URL = f"postgresql://{ USERNAME }:{ PASSWORD }@{DATABASE_URI}/{DB_NAME}"

# SQLAlchemy
engine = create_engine(DATABASE_URL)
metadata = MetaData()
notes = Table(
    "notes",
    metadata,
    Column("id", Integer, primary_key=True),
    Column("title", String(50)),
    Column("description", String(50)),
    Column("completed",String(8), default="False"),
    Column("created_date", String(50), default=dt.now(tz("Europe/Stockholm")).strftime("%Y-%m-%d %H:%M"))
)
# Databases query builder

database = Database(DATABASE_URL)
