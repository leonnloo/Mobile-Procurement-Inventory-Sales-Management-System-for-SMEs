from fastapi import APIRouter
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
        response = "Customer Information Summary:\n"
        response += f"- Customer ID: {mongo_result['customer_id']}\n"
        response += f"- Business Name: {mongo_result['business_name']}\n"
        response += f"- Contact Person: {mongo_result['contact_person']}\n"
        response += f"- Email {mongo_result['email']}, Phone {mongo_result['phone_number']}\n"
        response += f"- Phone {mongo_result['phone_number']}\n"
        response += f"- Billing Address {mongo_result['billing_address']}\n"
        response += f"- Shipping Address {mongo_result['shipping_address']}\n"
        notes_info = "None provided" if mongo_result.get('notes') is None else mongo_result['notes']
        response += f"- Notes: {notes_info}"
        
    elif intent == 'supplier_info':
        response = "Supplier Information Summary:\n"
        response += f"- Supplier ID: {mongo_result['supplier_id']}\n"
        response += f"- Business Name: {mongo_result['business_name']}\n"
        response += f"- Contact Person: {mongo_result['contact_person']}\n"
        response += f"- Email: {mongo_result['email']}\n"
        response += f"- Phone Number: {mongo_result['phone_number']}\n"
        response += f"- Address: {mongo_result['address']}\n"
        notes_info = "None provided" if mongo_result.get('notes') is None else mongo_result['notes']
        response += f"- Notes: {notes_info}"

    elif intent == 'procurement_info':
        response = "Procurement Information Summary:\n"
        purchase_id_info = "N/A" if mongo_result.get('purchase_id') is None else mongo_result['purchase_id']
        response += f"- Purchase ID: {purchase_id_info}\n"
        response += f"- Item Type: {mongo_result['item_type']}\n"
        response += f"- Item Name: {mongo_result['item_name']}\n"
        response += f"- Item ID: {mongo_result['item_id']}\n"
        response += f"- Supplier Name: {mongo_result['supplier_name']}\n"
        response += f"- Order Date: {mongo_result['order_date']}\n"
        response += f"- Delivery Date: {mongo_result['delivery_date']}\n"
        response += f"- Unit Price: ${mongo_result['unit_price']:.2f}\n"
        response += f"- Total Price: ${mongo_result['total_price']:.2f}\n"
        response += f"- Quantity: {mongo_result['quantity']}\n"
        response += f"- Status: {mongo_result['status']}"

    elif intent == 'inventory_info':
        response = "Inventory Item Information Summary:\n"
        response += f"- Item ID: {mongo_result['item_id']}\n"
        response += f"- Item Name: {mongo_result['item_name']}\n"
        response += f"- Category: {mongo_result['category']}\n"
        response += f"- Quantity: {mongo_result['quantity']}\n"
        response += f"- Unit Price: ${mongo_result['unit_price']:,.2f}\n"  # Formats the price as a decimal with two places
        response += f"- Total Price: ${mongo_result['total_price']:,.2f}\n"  # Formats the price as a decimal with two places
        response += f"- Critical Level: {mongo_result['critical_level']}\n"
        response += f"- Status: {mongo_result['status']}"


    elif intent == 'product_info':
        response = "Product Information Summary:\n"
        response += f"- Product ID: {mongo_result['product_id']}\n"
        response += f"- Product Name: {mongo_result['product_name']}\n"
        response += f"- Unit Price: ${mongo_result['unit_price']}\n"
        response += f"- Selling Price: ${mongo_result['selling_price']}\n"
        response += f"- Quantity Available: {mongo_result['quantity']}\n"
        response += f"- Markup: {mongo_result['markup']}\n"
        response += f"- Margin: {mongo_result['margin']}\n"
        response += f"- Critical Level: {mongo_result['critical_level']}\n"
        response += f"- Status: {mongo_result['status']}"
        # if mongo_result.get('monthly_sales'):
        #     sales_summary = "\n".join(
        #         [f"    - Year: {sale['year']}, Month: {sale['month']}, Quantity Sold: {sales['quantity_sold']}, Sales: {sale['total_price']}"
        #          for sale in mongo_result['monthly_sales']])
        #     response += f"- Monthly Sales:\n{sales_summary}\n"
        # else:
        #     response += "- Monthly Sales: Not Available\n"

    elif intent == 'company_monthly_sales_info':
        response = "Company Monthly Sales Information:\n"
        response += f"- Year: {mongo_result['year']}\n"
        response += f"- Month: {mongo_result['month']}\n"
        response += f"- Actual Sales: ${mongo_result['actual_sales']}\n"
        response += f"- Target Sales: ${mongo_result['target_sales']}"

    elif intent == 'refund_info':
        response = "Refund Information Summary:\n"
        response += f"- Refund ID: {mongo_result['refund_id']}\n"
        response += f"- Order ID: {mongo_result['order_id']}\n"
        response += f"- Order Status: {mongo_result['order_status']}\n"
        response += f"- Refund Date: {mongo_result['refund_date']}\n"
        response += f"- Customer ID: {mongo_result['customer_id']}\n"
        response += f"- Customer Name: {mongo_result['customer_name']}\n"
        response += f"- Product ID: {mongo_result['product_id']}\n"
        response += f"- Product Name: {mongo_result['product_name']}\n"
        response += f"- Refund Quantity: {mongo_result['refund_quantity']}\n"
        response += f"- Order Price: ${mongo_result['order_price']:.2f}\n"
        response += f"- Refund Amount: ${mongo_result['refund_amount']:.2f}\n"
        response += f"- Reason: {mongo_result['reason']}"

    elif intent == 'sale_order_info':
        response = "Sale Order Information Summary:\n"
        response += f"- Order ID: {mongo_result['order_id']}\n"
        response += f"- Order Date: {mongo_result['order_date']}\n"
        response += f"- Customer ID: {mongo_result['customer_id']}\n"
        response += f"- Customer Name: {mongo_result['customer_name']}\n"
        response += f"- Product ID: {mongo_result['product_id']}\n"
        response += f"- Product Name: {mongo_result['product_name']}\n"
        response += f"- Quantity: {mongo_result['quantity']}\n"
        response += f"- Unit Price: ${mongo_result['unit_price']:.2f}\n"
        response += f"- Total Price: ${mongo_result['total_price']:.2f}\n"
        response += f"- Completion Status: {mongo_result['completion_status']}\n"
        response += f"- Order Status: {mongo_result['order_status']}\n"
        response += f"- Employee: {mongo_result['employee']}\n"
        response += f"- Employee ID: {mongo_result['employee_id']}"
    
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
    print(prob.item())
    if prob.item() > 0.75:
        print(tag)
        if (tag == "customer_info" or
            tag == "supplier_info" or
            tag == "procurement_info"or
            tag == "inventory_info" or
            tag == "product_info" or
            tag == "sale_order_info" or
            tag == "refund_info" or
            tag == "company_monthly_sales_info"):
            mongo_result = query_mongodb(tag, user_input.sentence)
            if mongo_result:
                response = format_mongo_response(tag, mongo_result)  # Define this function
                return {"response": response}
            else: 
                if tag == "customer_info":
                    return {"response": "Customer not found"}
                elif tag == "supplier_info":
                    return {"response": "Supplier not found"}
                elif tag == "procurement_info":
                    return {"response": "Purchase not found"}
                elif tag == "inventory_info":
                    return {"response": "Inventory item not found"}
                elif tag == "product_info":
                    return {"response": "Product not found"}
                elif tag == "sale_order_info":
                    return {"response": "Sale order not found"}
                elif tag == "refund_info":
                    return {"response": "Refund not found"}
                elif tag == "company_monthly_sales_info":
                    return {"response": "Company monthly sales not found"}
        else:
            for intent in intents['intents']:
                if tag == intent["tag"]:
                    response = random.choice(intent['responses'])
                    return {"response": response}
    return {"response": 
            "Sorry, but please try again by specifying what you want to query for (Supplier, Customer, Purchase, Order, Item, etc)"
            }










