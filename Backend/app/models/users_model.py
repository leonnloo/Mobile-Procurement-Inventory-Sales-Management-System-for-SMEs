from pydantic import BaseModel

class User(BaseModel):
    user_name: str
    email: str
    password: str
    role: str