from fastapi import APIRouter, Depends, HTTPException, status
from models.users_model import User
from config.database import users_db
from schema.schemas import user_dict_serial, user_serial
from bson import ObjectId
from fastapi.security import OAuth2PasswordBearer

user_router = APIRouter()
oauth_scheme = OAuth2PasswordBearer(tokenUrl="token")

@user_router.get("/get_users")
async def get_users():
    users = user_serial(users_db.find())
    return users

@user_router.get("/get_user/{id}")
async def get_user(id: str):
    user = user_serial(users_db.find_one({"employee_id": id}))
    return user

@user_router.post("/create_user")
def create_user(user: User):
# async def register(user: User, token: str = Depends(oauth_scheme)):
    existing_email_user = users_db.find_one({"email": user.email})
    if existing_email_user:
        raise HTTPException(
        status_code = status.HTTP_403_FORBIDDEN,
        detail = "Email registered",
    )
    existing_phone_user = users_db.find_one({"phone_number": user.phone_number})
    if existing_phone_user:
        raise HTTPException(
        status_code = status.HTTP_403_FORBIDDEN,
        detail = "Phone number registered",
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
        phone_number = user.phone_number,
        password = user.password,
        role = None,
        sales_record = None,
    )

    users_db.insert_one(dict(updated_user))
    return {"Message": "Successfully registered"}

# ! add logic so that only admin can change employee's role
@user_router.put("/{id}")
def put_user(id: str, user: User):
    old_user = users_db.find_one({"employee_id": id})
    if old_user:
        updated_supplier = User(
            employee_id = old_user["employee_id"],
            employee_name = user.employee_name,
            email = user.email,
            password = user.password,
            phone_number = user.phone_number,
            role = user.role,
            sales_record = old_user["sales_record"],
        )
        users_db.update_one({"employee_id": user.employee_id}, {"$set": dict(updated_supplier)})
        return user_dict_serial(users_db.find_one({"employee_id": user.employee_id}))
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found",
            headers={"WWW-Authenticate": "Bearer"},
        )

@user_router.delete("/{id}")
async def delete_user(id: str):
    await users_db.find_one_and_delete({"_id": ObjectId(id)}) 