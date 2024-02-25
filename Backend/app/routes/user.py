from fastapi import APIRouter
from models.users_model import User
from config.database import users_db
from schema.schemas import list_serial
from bson import ObjectId

router = APIRouter()

@router.get("/")
async def get_users():
    users = list_serial(users_db.find())
    return users


@router.post("/")
async def post_user(user: User):
    users_db.insert_one(dict(user))


@router.put("/{id}")
async def put_user(id: str, user: User):
    users_db.find_one_and_update({"_id": ObjectId(id)}, {"$set": dict(user)})

@router.delete("/{id}")
async def delete_user(id: str):
    users_db.find_one_and_delete({"_id": ObjectId(id)})