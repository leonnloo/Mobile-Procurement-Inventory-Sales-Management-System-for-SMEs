from pymongo import MongoClient
client = MongoClient("mongodb+srv://leonloo:leonloo@cluster0.avq2d4j.mongodb.net/?retryWrites=true&w=majority", tlsInsecure=True)

db = client.grp_db

users_db = db["users_db"]
customers_db = db["customers_db"]
suppliers_db = db["suppliers_db"]
sales_order_db = db["sales_order_db"]
procurement_db = db["procurement_db"]
product_db = db["product_db"]
inventory_db = db["inventory_db"]
monthly_sales_db = db["monthly_sales_db"]
refunds_db = db["refunds_db"]