from fastapi import FastAPI, Body, Request
from routes.user import user_router
from routes.auth import auth_router
from routes.forms import form_router

app = FastAPI()

app.include_router(user_router)
app.include_router(auth_router)
app.include_router(form_router)
