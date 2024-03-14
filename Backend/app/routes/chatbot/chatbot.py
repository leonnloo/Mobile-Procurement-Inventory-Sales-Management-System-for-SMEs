from fastapi import FastAPI, HTTPException, APIRouter
from pydantic import BaseModel
import random
import json
import torch

from routes.chatbot.query import query_mongodb
from .model import NeuralNet
from .nltk_utils import bag_of_words, tokenize
import os

chatbot_router = APIRouter()
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

with open('routes/chatbot/intents.json', 'r') as json_data:
    intents = json.load(json_data)
 
FILE = "data.pth"
data = torch.load(FILE)

input_size = data["input_size"]
hidden_size = data["hidden_size"]
output_size = data["output_size"]
all_words = data['all_words']
tags = data['tags']
model_state = data["model_state"]

model = NeuralNet(input_size, hidden_size, output_size).to(device)
model.load_state_dict(model_state)
model.eval()
class UserInput(BaseModel):
    sentence: str


def format_mongo_response(intent, mongo_result):
    if intent == 'customer_info':
        response = f"Customer ID {mongo_result['customer_id']} is associated with the business named {mongo_result['business_name']}. "
        response += f"The contact person is {mongo_result['contact_person']}. "
        response += f"You can reach them via email at {mongo_result['email']} or phone at {mongo_result['phone_number']}. "
        response += f"The billing and shipping address is {mongo_result['billing_address']}. "
        if mongo_result['past_order'] is None:
            response += "Currently, there are no past orders listed for this customer. "
        else:
            response += f"The past order is {mongo_result['past_order']}. "
        response += f"Notes: {mongo_result['notes']}."
        return response

        


@chatbot_router.post("/chat")
def chat(user_input: UserInput):
    sentence = user_input.sentence 
    sentence = tokenize(sentence)
    X = bag_of_words(sentence, all_words)
    X = X.reshape(1, X.shape[0])
    X = torch.from_numpy(X).to(device)

    output = model(X)
    _, predicted = torch.max(output, dim=1)

    tag = tags[predicted.item()]

    probs = torch.softmax(output, dim=1)
    prob = probs[0][predicted.item()]
    print(prob)
    if prob.item() > 0.75:
        print(tag)
        if tag == "customer_info":
            mongo_result = query_mongodb(tag, user_input.sentence)
            if mongo_result:
                response = format_mongo_response(tag, mongo_result)  # Define this function
                return {"response": response}
            else: 
                return {"response": "Customer not found"}
        else:
            for intent in intents['intents']:
                if tag == intent["tag"]:
                    response = random.choice(intent['responses'])
                    return {"response": response}
    return {"response": "I do not understand..."}










