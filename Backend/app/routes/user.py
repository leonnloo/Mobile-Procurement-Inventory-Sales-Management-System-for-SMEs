from fastapi import APIRouter, Depends, HTTPException, status
from models.users_model import *
from routes.func import *
from config.database import users_db
from schema.schemas import user_dict_serial, user_serial
from fastapi.security import OAuth2PasswordBearer
from pymongo import DESCENDING

user_router = APIRouter()
oauth_scheme = OAuth2PasswordBearer(tokenUrl="token")

@user_router.get("/get_user/{id}")
def get_user(id: str):
    user = user_dict_serial(users_db.find_one({'employee_id': id}))
    return user

@user_router.get("/get_users")
def get_users():
    users = user_serial(users_db.find())
    return users

@user_router.get("/get_users_name")
def get_users_name(token: str = Depends(oauth_scheme)):
    users = users_db.find()
    user_names = [user['employee_name'] for user in users]
    return user_names

@user_router.get("/get_user_id/{userName}")
def get_user_id(userName: str):
    user = users_db.find_one({"$or": [{"employee_name": userName}, {"email": userName}]}, {"employee_id": 1})
    return user['employee_id']

@user_router.post("/create_user")
def create_user(user: NewUser):
    existing_username = users_db.find_one({"employee_name": user.employee_name})
    if existing_username:
        raise HTTPException(
        status_code = status.HTTP_403_FORBIDDEN,
        detail = "Employee Name Registered",
    )
    existing_email = users_db.find_one({"email": user.email})
    if existing_email:
        raise HTTPException(
        status_code = status.HTTP_403_FORBIDDEN,
        detail = "Email Registered",
    )
    existing_phone = users_db.find_one({"phone_number": user.phone_number})
    if existing_phone:
        raise HTTPException(
        status_code = status.HTTP_403_FORBIDDEN,
        detail = "Phone Number Registered",
    )
    
    # Find the document with the largest employee_id
    latest_id_document = users_db.find_one(sort=[("_id", DESCENDING)])

    # Determine the next employee_id
    if latest_id_document:
        query_id = latest_id_document.get("employee_id", "-1")
        next_employee_id = processNextID(query_id)
    else:
        next_employee_id = "EP1"

    updated_user = User(
        employee_name = user.employee_name,
        employee_id = next_employee_id,
        email = user.email,
        phone_number = user.phone_number,
        password = user.password,
        role = 'No Role',
        sales_record = None,
    )

    users_db.insert_one(dict(updated_user))
    return {"Message": "Successfully registered"}

# ! add logic so that only admin can change employee's role
@user_router.put("/update_user/{id}")
def update_user(id: str, user: EditUser, token: str = Depends(oauth_scheme)):
    old_user = users_db.find_one({"employee_id": id})
    if old_user:
        old_user['employee_name'] = user.employee_name
        old_user['email'] = user.email
        old_user['phone_number'] = user.phone_number
        old_user['role'] = user.role
        old_user['password'] = user.password
        users_db.update_one({"employee_id": id}, {"$set": old_user})
        return user_dict_serial(users_db.find_one({"employee_id": id}))
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found",
            headers={"WWW-Authenticate": "Bearer"},
        )

@user_router.put("/update_user_password/{email}/{password}")
def update_user_password(email: str, password: str):
    users_db.find_one_and_update({"email": email}, {"$set": {"password": password}}) 


@user_router.delete("/delete_user/{id}")
def delete_user(id: str, token: str = Depends(oauth_scheme)):
    users_db.find_one_and_delete({"employee_id": id}) 

@user_router.get("/verify_email/{email}")
def verify_email(email: str):
    user = users_db.find_one({"email": email}) 
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found",
            headers={"WWW-Authenticate": "Bearer"},
        )

