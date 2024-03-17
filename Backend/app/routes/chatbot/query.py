from routes.chatbot.entities_extract import extract_entities
from config.database import *



def construct_query(intent_tag, entities):
    if intent_tag == "customer_info":
        query = {}
        if "customer_id" in entities:
            query["customer_id"] = entities["customer_id"]
        elif "business_name" in entities:
            query["business_name"] = entities["business_name"]
        elif "name" in entities:
            query["business_name"] = entities["name"]
            # query["contact_person"] = entities["name"]
        elif "email" in entities:
            query["email"] = entities["email"]
        elif "phone_number" in entities:
            query["phone_number"] = entities["phone_number"]
        # Add handling for other attributes like phone number, etc.
        return query
    # Handle other intents similarly
    return None



def query_mongodb(intent_tag, user_input):
    entities = extract_entities(user_input)
    for entity in entities: 
        print(entity) 
    query = construct_query(intent_tag, entities)
    if query:
        if intent_tag == "customer_info":
            if query.__len__() > 1:
                result = customers_db.find_one({"$or": [query[0], query[1]]})
            else:
                result = customers_db.find_one(query)
        elif intent_tag == "supplier_info":
            if query.__len__() > 1:
                result = suppliers_db.find_one({"$or": [query[0], query[1]]})
            else:
                result = suppliers_db.find_one(query)
        elif intent_tag == "procurement_info":
            result = procurement_db.find_one(query)
        elif intent_tag == "inventory_info":
            result = inventory_db.find_one(query)
        elif intent_tag == "product_info":
            result = product_db.find_one(query)
        elif intent_tag == "sale_order_info":
            result = sales_order_db.find_one(query)
        elif intent_tag == "employee_monthly_sales_info":
            result = sales_management_db.find_one(query)
        elif intent_tag == "company_monthly_sales_info":
            result = customers_db.find_one(query);


        return result
    return None