from fastapi import APIRouter, Depends, HTTPException, status
from models.users_model import User
from config.database import users_db
from schema.schemas import user_serial
from bson import ObjectId
from fastapi.security import OAuth2PasswordBearer

user_router = APIRouter()
oauth_scheme = OAuth2PasswordBearer(tokenUrl="token")

@user_router.get("/get_user")
async def get_users():
    users = user_serial(users_db.find())
    # user1 = users_db.find()
    # print(users)
    # print(users_db.find())
    return users


@user_router.post("/register_user")
def register(user: User):
# async def register(user: User, token: str = Depends(oauth_scheme)):
    existing_user = users_db.find_one({"email": user.email})
    if existing_user:
        raise HTTPException(
        status_code = status.HTTP_403_FORBIDDEN,
        detail = "Email registered",
    )
    
    # Find the document with the largest employee_id
    largest_id_document = users_db.find_one(sort=[("employee_id", -1)])

    # Determine the next employee_id
    if largest_id_document:
        next_employee_id = largest_id_document.get("employee_id", 0) + 1
    else:
        next_employee_id = 1


    updated_user = User(
        employee_name = user.employee_name,
        employee_id = next_employee_id,
        email = user.email,
        password = user.password,
        role = None,
        sales_record = None,
    )

    users_db.insert_one(dict(updated_user))
    return {"Message": "Successfully registered"}


@user_router.put("/{id}")
async def put_user(id: str, user: User):
    await users_db.find_one_and_update({"_id": ObjectId(id)}, {"$set": dict(user)})

@user_router.delete("/{id}")
async def delete_user(id: str):
    await users_db.find_one_and_delete({"_id": ObjectId(id)}) 