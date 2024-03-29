from routes.chatbot.entities_extract import extract_entities
from config.database import *
from word2number import w2n
from routes.func import *
from dateutil import parser
from datetime import datetime

def format_date(date_str):
    try:
        # Parse the date
        parsed_date = parser.parse(date_str, dayfirst=True, fuzzy=True)
        # Format the date
        return parsed_date.strftime("%Y-%m-%d")
    except (ValueError, TypeError):
        print(f"Could not parse '{date_str}'.")
        return None

def words_to_number(words):
    if isinstance(words, (int, float)):
        return words
    try:
        return float(words) if '.' in words else int(words)
    except ValueError:
        try:
            return w2n.word_to_num(words)
        except ValueError:
            print(f"Could not convert '{words}' to a number.")
            return None

# Example usage:
# words_list = ["twenty-five", "one hundred", "three hundred and forty-two", "two thousand twenty"]

# for words in words_list:
#     print(f"'{words}' -> {words_to_number(words)}")


def construct_query(intent_tag, entities):
    query = {}
    if intent_tag == "customer_info":
        if "customID" in entities:
            query["customer_id"] = entities["customID"]
        elif "business_name" in entities:
            query["business_name"] = entities["business_name"]
        elif "contact_person" in entities:
            query["business_name"] = entities["contact_person"]
            query["contact_person"] = entities["contact_person"]
        elif "email" in entities:
            query["email"] = entities["email"]
        elif "phone_number" in entities:
            query["phone_number"] = entities["phone_number"]
        elif "address" in entities:
            query["billing_address"] = entities["address"]
            query["shipping_address"] = entities["address"]

    elif intent_tag == "supplier_info":
        if "customID" in entities:
            query["supplier_id"] = entities["customID"]
        elif "business_name" in entities:
            query["business_name"] = entities["business_name"]
        elif "contact_person" in entities:
            query["business_name"] = entities["contact_person"]
            query["contact_person"] = entities["contact_person"]
        elif "email" in entities:
            query["email"] = entities["email"]
        elif "phone_number" in entities:
            query["phone_number"] = entities["phone_number"]
        elif "address" in entities:
            query["address"] = entities["address"]

    elif intent_tag == "procurement_info":
        if "customID" in entities:
            query["purchase_id"] = entities["customID"]
            query["item_id"] = entities["customID"]
        elif "business_name" in entities:
            query["supplier_name"] = entities["business_name"]
        elif "contact_person" in entities:
            query["supplier_name"] = entities["contact_person"]
        elif "item_name" in entities:
            query["item_name"] = entities["item_name"]
        elif "status" in entities:
            query["status"] = entities["status"]
        elif "date" in entities:
            query["order_date"] = format_date(entities["date"])
            query["delivery_date"] = format_date(entities["date"])
        elif "quantity" in entities:
            query["quantity"] = words_to_number(entities["quantity"])
        elif "price" in entities:
            query["unit_price"] = words_to_number(entities["price"])
            query["total_price"] = words_to_number(entities["price"])

    elif intent_tag == "inventory_info":
        if "customID" in entities:
            query["item_id"] = entities["customID"]
        elif "item_name" in entities:
            query["item_name"] = entities["item_name"]
        elif "status" in entities:
            query["status"] = entities["status"]
        elif "quantity" in entities:
            query["quantity"] = words_to_number(entities["quantity"])
        elif "price" in entities:
            query["unit_price"] = words_to_number(entities["price"])
            query["total_price"] = words_to_number(entities["price"])

    elif intent_tag == "product_info":
        if "customID" in entities:
            query["product_id"] = entities["customID"]
        elif "item_name" in entities:
            print('hey product here')
            query["product_name"] = entities["item_name"]
        elif "status" in entities:
            query["status"] = entities["status"]
        elif "quantity" in entities:
            query["quantity"] = words_to_number(entities["quantity"])
        elif "price" in entities:
            query["unit_price"] = words_to_number(entities["price"])
            query["selling_price"] = words_to_number(entities["price"])

    elif intent_tag == "sale_order_info":
        if "customID" in entities:
            query["order_id"] = entities["customID"]
            query["employee_id"] = entities["customID"]
            query["customer_id"] = entities["customID"]
            query["product_id"] = entities["customID"]
        elif "item_name" in entities:
            query["product_name"] = entities["item_name"]
        elif "status" in entities:
            query["order_status"] = entities["status"]
            query["completion_status"] = entities["status"]
        elif "quantity" in entities:
            query["quantity"] = words_to_number(entities["quantity"])
        elif "price" in entities:
            query["unit_price"] = words_to_number(entities["price"])
            query["total_price"] = words_to_number(entities["price"])
        elif "business_name" in entities:
            query["customer_name"] = entities["business_name"]
        elif "name" in entities:
            query["customer_name"] = entities["name"]
            query["employee_name"] = entities["name"]
        elif "date" in entities:
            query["order_date"] = format_date(entities["date"])

    elif intent_tag == "refund_info":
        if "customID" in entities:
            query["refund_id"] = entities["customID"]
            query["order_id"] = entities["customID"]
            query["customer_id"] = entities["customID"]
            query["product_id"] = entities["customID"]
        elif "item_name" in entities:
            query["product_name"] = entities["item_name"]
        elif "quantity" in entities:
            query["refund_quantity"] = words_to_number(entities["quantity"])
        elif "price" in entities:
            query["order_price"] = words_to_number(entities["price"])
            query["refund_amount"] = words_to_number(entities["price"])
        elif "business_name" in entities:
            query["customer_name"] = entities["business_name"]
        elif "name" in entities:
            query["customer_name"] = entities["name"]
        elif "date" in entities:
            query["refund_date"] = format_date(entities["date"])

    elif intent_tag == "company_monthly_sales_info":
        if "date" in entities:
            date = format_date(entities["date"])
            year, month, day = extract_year_month_day(date)
            query["year"] = year
            query["month"] = month
        elif "price" in entities:
            query["actual_sales"] = words_to_number(entities["price"])
            query["target_sales"] = words_to_number(entities["price"])
    
    if query == {}:
        return None
    return query

def query_mongodb(intent_tag, user_input):
    entities = extract_entities(user_input)
    query_conditions = construct_query(intent_tag, entities)

    # Prepare the query for MongoDB
    if query_conditions:
        mongodb_query = []
        for field, value in query_conditions.items():
            if isinstance(value, str):
                # Use regex for strings with 'i' option for case-insensitive search
                mongodb_query.append({field: {"$regex": value, "$options": "i"}})
            else:
                # Directly query non-string values (e.g., integers, booleans)
                mongodb_query.append({field: value})
        # If there are multiple conditions, use $or. Otherwise, directly use the single condition.
        if len(mongodb_query) > 1:
            final_query = {"$or": mongodb_query} 
        else:
            final_query = mongodb_query[0] if mongodb_query else {} 

        # Now use final_query to search the database
        if intent_tag == "customer_info":
            result = customers_db.find_one(final_query)
        elif intent_tag == "supplier_info":
            result = suppliers_db.find_one(final_query)
        elif intent_tag == "procurement_info":
            result = procurement_db.find_one(final_query)
        elif intent_tag == "inventory_info":
            result = inventory_db.find_one(final_query)
        elif intent_tag == "product_info":
            result = product_db.find_one(final_query)
        elif intent_tag == "sale_order_info":
            result = sales_order_db.find_one(final_query)
        elif intent_tag == "refund_info":
            result = refunds_db.find_one(final_query)
        elif intent_tag == "company_monthly_sales_info":
            result = monthly_sales_db.find_one(final_query)

        return result

    return None