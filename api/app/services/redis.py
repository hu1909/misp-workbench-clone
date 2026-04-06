import importlib

redis_lib = importlib.import_module("redis")
from typing import Optional

from app.rediscli import get_redis


def get_redis_client(db: Optional[int] = None) -> redis_lib.Redis:
    return get_redis()
