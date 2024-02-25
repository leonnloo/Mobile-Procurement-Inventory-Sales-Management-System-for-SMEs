from fastapi import FastAPI, Body, Request
from routes.user import router

app = FastAPI()

app.include_router(router)
