import random
import string    
import json
from fastapi import APIRouter, HTTPException, status
import os
from fastapi import BackgroundTasks
from fastapi_mail import FastMail, MessageSchema, ConnectionConfig, MessageType
from dotenv import load_dotenv
verify_router = APIRouter()
load_dotenv('.env')
verification_codes = {}

class Envs:
    MAIL_USERNAME = os.getenv('MAIL_USERNAME')
    MAIL_PASSWORD = os.getenv('MAIL_PASSWORD')
    MAIL_FROM = os.getenv('MAIL_FROM')
    MAIL_PORT = int(os.getenv('MAIL_PORT')) 
    MAIL_SERVER = os.getenv('MAIL_SERVER')
    MAIL_FROM_NAME = os.getenv('MAIN_FROM_NAME')

conf = ConnectionConfig(
    MAIL_USERNAME=Envs.MAIL_USERNAME,
    MAIL_PASSWORD=Envs.MAIL_PASSWORD,
    MAIL_FROM=Envs.MAIL_FROM,
    MAIL_PORT=Envs.MAIL_PORT,   
    MAIL_SERVER=Envs.MAIL_SERVER,
    MAIL_FROM_NAME=Envs.MAIL_FROM_NAME,
    MAIL_STARTTLS=True,
    MAIL_SSL_TLS=False,
    USE_CREDENTIALS=True, 
    TEMPLATE_FOLDER=os.path.abspath('routes/templates')
) 



def send_verification_email_background(background_tasks: BackgroundTasks, subject: str, email_to: str, body: str):
    body_str = f'Your verification code is: {body}'

    message = MessageSchema(
        subject=subject,
        recipients=[email_to],
        body=body_str,  # Pass the string representation
        subtype=MessageType.html,
    )
    fm = FastMail(conf)
    background_tasks.add_task(
       fm.send_message, message, template_name='email.html')
    


@verify_router.get('/send_verification_email/{email}')
def send_verification_email(background_tasks: BackgroundTasks, email: str):
    try:
        # Generate a random 6-digit code
        code = ''.join(random.choices(string.digits, k=6))

        # Store the code in the database (replace with database logic)
        verification_codes[email] = code

        # Send verification code via email asynchronously

        send_verification_email_background(background_tasks, 'Verification Code',   
        email, code)
        return 'Success'
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to send verification code: {str(e)}")



@verify_router.post("/verify_user/{email}/{code}")
async def verify_user(email: str, code: str):
    stored_code = verification_codes.get(email)

    if not stored_code:
        raise HTTPException(status_code=400, detail="Invalid verification code")

    if code != stored_code:
        raise HTTPException(status_code=400, detail="Incorrect verification code")
    
    return {"message": "User verified successfully"}




# @verify_router.get('/send-email/asynchronous')
# async def send_email_asynchronous():
#     await send_email_async('Hello World','looyang01@gmail.com',
#     {'title': 'Hello World', 'name': 'John Doe'})
#     return 'Success'
    
# async def send_email_async(subject: str, email_to: str, body: dict):
#     body_str = json.dumps(body)

#     message = MessageSchema(
#         subject=subject,
#         recipients=[email_to],
#         body=body_str,  # Pass the string representation
#         subtype='html',
#     )
    
#     fm = FastMail(conf)
#     await fm.send_message(message, template_name='email.html')