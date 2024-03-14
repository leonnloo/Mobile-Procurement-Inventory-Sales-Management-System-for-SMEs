from routes.chatbot.entities_extract import extract_entities
from config.database import *



def construct_query(intent_tag, entities):
    if intent_tag == "customer_info":
        query = {}
        if "customer_id" in entities:
            query["customer_id"] = entities["customer_id"]
        elif "name" in entities:
            query["business_name"] = entities["name"]
            # query["contact_person"] = entities["name"]
        elif "email" in entities:
            query["email"] = entities["email"]
        # Add handling for other attributes like phone number, etc.
        return query
    # Handle other intents similarly
    return None



def query_mongodb(intent_tag, user_input):
    entities = extract_entities(user_input)
    for entity in entities:
        print(entity)
    query = construct_query(intent_tag, entities)
    print(query)
    if query:
        print(query)
        if intent_tag == "customer_info":
            result = customers_db.find_one(query)

        print(result)
        return result
    return None