from fastapi import APIRouter, Depends, HTTPException, status
from models.users_model import User
from config.database import *
from models.customer_model import CustomerInfo
from models.sales_order_model import SaleOrder
from models.supplier_model import SupplierInfo
from models.procurement_model import Procurement 
from models.product_model import ProductItem 
from models.inventory_model import InventoryItem  
from models import *
from schema.schemas import *
from bson import ObjectId
from fastapi.security import OAuth2PasswordBearer

get_router = APIRouter()
oauth_scheme = OAuth2PasswordBearer(tokenUrl="token")


# ---------------------------------------- Customer ----------------------------------------
@get_router.get("/get_customers")
def get_customers():
    customers = customer_serial(customers_db.find())
    return customers

# ---------------------------------------- Supplier ----------------------------------------
@get_router.get("/get_supplier")
def get_supplier():
    suppliers = supplier_serial(suppliers_db.find())
    return suppliers

# ---------------------------------------- Sales Order ----------------------------------------
@get_router.get("/get_sale_order")
def get_sale_order():
    sale_orders = sale_order_serial(sales_order_db.find())
    return sale_orders

# ---------------------------------------- Procurement ----------------------------------------
@get_router.get("/get_procurement")
def get_procurement():
    procurements = procurement_serial(procurement_db.find())
    return procurements

# ---------------------------------------- Product ----------------------------------------
@get_router.get("/get_product")
def get_product():
    product = product_serial(product_db.find())
    return product

# ---------------------------------------- Inventory ----------------------------------------
@get_router.get("/get_inventory")
def get_inventory():
    inventory = inventory_serial(inventory_db.find())
    return inventory


