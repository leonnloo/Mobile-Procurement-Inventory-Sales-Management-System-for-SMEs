from fastapi import APIRouter, Depends, HTTPException, status
from models.users_model import User
from config.database import users_db
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm

auth_router = APIRouter()
oauth_scheme = OAuth2PasswordBearer(tokenUrl="token")

@auth_router.post("/token")
def login(form_data: OAuth2PasswordRequestForm = Depends()):
    username = form_data.username 
    password = form_data.password

    # Retrieve user from the database based on the provided username using their name or email
    user = users_db.find_one({"$or": [{"employee_name": username}, {"email": username}]})

    # Check if the user exists and if the password matches
    if user and user.get("password") == password:
        return {"access_token": username, "token_type": "bearer"}

    # If the user doesn't exist or the password is incorrect, raise an HTTPException
    raise HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        
        detail="Invalid credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )

@auth_router.get("/token/{username}")
def get_token(username: str = Depends(oauth_scheme)):
    print(username)
    return {"access_token": username, "token_type": "bearer"}

