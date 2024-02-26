from pymongo import MongoClient
client = MongoClient("mongodb+srv://leonloo:leonloo@cluster0.avq2d4j.mongodb.net/?retryWrites=true&w=majority")

db = client.grp_db

users_db = db["users_db"]
customers_db = db["customers_db"]
supplier_db = db["supplier_db"]
sales_order_db = db["sales_order_db"]
sales_management_db = db["sales_management_db"]
procurement_db = db["procurement_db"]
product_db = db["product_db"]
inventory_db = db["inventory_db"]