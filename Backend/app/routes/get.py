from fastapi import APIRouter, Depends, HTTPException, status
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

# TODO: try removing all docs in db to see what'll return to flutter, and handle the logic from there on or here
# it'll return empty list
# ---------------------------------------- Customer ----------------------------------------
@get_router.get("/get_customers")
def get_customers(token: str = Depends(oauth_scheme)):
    customers = customer_serial(customers_db.find())
    return customers

@get_router.get("/get_customer/{id}")
def get_customer(id: str, token: str = Depends(oauth_scheme)):
    customer = customer_dict_serial(customers_db.find_one({'customer_id': id}))
    return customer

# ---------------------------------------- Supplier ----------------------------------------
@get_router.get("/get_suppliers")
def get_suppliers(token: str = Depends(oauth_scheme)):
    suppliers = supplier_serial(suppliers_db.find())
    return suppliers

@get_router.get("/get_supplier/{id}")
def get_suppliers(id:str, token: str = Depends(oauth_scheme)):
    suppliers = supplier_serial(suppliers_db.find_one({'supplier_id': id}))
    return suppliers

# ---------------------------------------- Sales Order ----------------------------------------
@get_router.get("/get_sale_order")
def get_sale_order(token: str = Depends(oauth_scheme)):
    sale_orders = sale_order_serial(sales_order_db.find())
    return sale_orders

# ---------------------------------------- Procurement ----------------------------------------
@get_router.get("/get_procurement")
def get_procurement(token: str = Depends(oauth_scheme)):
    procurements = procurement_serial(procurement_db.find())
    return procurements

# ---------------------------------------- Product ----------------------------------------
@get_router.get("/get_product")
def get_product(token: str = Depends(oauth_scheme)):
    product = product_serial(product_db.find())
    return product

# ---------------------------------------- Inventory ----------------------------------------
@get_router.get("/get_inventory")
def get_inventory(token: str = Depends(oauth_scheme)):
    inventory = inventory_serial(inventory_db.find())
    return inventory

# ---------------------------------------- Sale Management ----------------------------------------
@get_router.get("/get_company_monthly_sales")
def get_company_monthly_sales(token: str = Depends(oauth_scheme)):
    sales = company_monthly_sales_serial(sales_management_db.find())
    return sales

