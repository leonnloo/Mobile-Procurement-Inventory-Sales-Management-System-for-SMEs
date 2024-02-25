from pymongo import MongoClient
client = MongoClient("mongodb+srv://leonloo:leonloo@cluster0.avq2d4j.mongodb.net/?retryWrites=true&w=majority")

db = client.grp_db

users_db = db["users_data"]