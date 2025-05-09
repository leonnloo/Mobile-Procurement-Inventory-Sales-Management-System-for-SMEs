from fastapi import FastAPI
from routes.user import user_router
from routes.auth import auth_router
from routes.posts import post_router
from routes.get import get_router
from routes.put import put_router
from routes.notes import note_router
from routes.delete import delete_router 
from routes.verification import verify_router 
from routes.chatbot.chatbot import chatbot_router
from routes.sales_management import sales_management_router
from fastapi.middleware.cors import CORSMiddleware
app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    # allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(user_router)
app.include_router(auth_router)
app.include_router(post_router)
app.include_router(get_router)
app.include_router(put_router)
app.include_router(note_router)
app.include_router(delete_router)
app.include_router(verify_router)
app.include_router(chatbot_router)
app.include_router(sales_management_router)
