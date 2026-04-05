from pydantic import BaseModel


class Setting(BaseModel):
    id: int
    namespace: str
    value: dict
