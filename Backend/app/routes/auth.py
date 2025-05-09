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
    return {"access_token": username, "token_type": "bearer"}

# from fastapi import Depends, HTTPException, status, APIRouter
# from fastapi.security import OAuth2PasswordRequestForm
# from jose import jwt
# from datetime import datetime, timedelta



# pip install pyjwt[crypto]

# Your secret key to encode the JWT - keep this safe!
# SECRET_KEY = "your_secret_key"
# ALGORITHM = "HS256"
# ACCESS_TOKEN_EXPIRE_MINUTES = 30  # or however long you want the token to last

# auth_router = APIRouter()

# @auth_router.post("/token")
# def login(form_data: OAuth2PasswordRequestForm = Depends()):
#     username = form_data.username
#     password = form_data.password

#     # Replace with your database user retrieval logic
#     user = users_db.find_one({"$or": [{"employee_name": username}, {"email": username}]})

#     # Check if user exists and password is correct
#     if user and user.get("password") == password:
#         # Generate the token payload
#         access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
#         expire = datetime.utcnow() + access_token_expires
#         to_encode = {"exp": expire, "sub": str(user["_id"])}
        
#         # Create the token
#         access_token = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

#         return {"access_token": access_token, "token_type": "bearer"}

#     raise HTTPException(
#         status_code=status.HTTP_401_UNAUTHORIZED,
#         detail="Invalid credentials
