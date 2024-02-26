from fastapi import APIRouter
from models.users_model import User
from config.database import users_db
from schema.schemas import list_serial
from bson import ObjectId

user_router = APIRouter()

@user_router.get("/")
async def get_users():
    users = list_serial(users_db.find())
    print(users)
    print(users_db.find())
    return users


@user_router.post("/")
async def post_user(user: User):
    users_db.insert_one(dict(user))


@user_router.put("/{id}")
async def put_user(id: str, user: User):
    users_db.find_one_and_update({"_id": ObjectId(id)}, {"$set": dict(user)})

@user_router.delete("/{id}")
async def delete_user(id: str):
    users_db.find_one_and_delete({"_id": ObjectId(id)}) 