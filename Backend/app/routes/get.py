from fastapi import APIRouter, Depends, HTTPException, status
from config.database import *
from models.customer_model import *
from models.sales_order_model import *
from models.supplier_model import *
from models.procurement_model import * 
from models.product_model import * 
from models.inventory_model import *  
from models import *
from schema.schemas import *
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

@get_router.get("/get_customers_name")
def get_customers_name(token: str = Depends(oauth_scheme)):
    customers = customer_name_serial(customers_db.distinct('business_name'))
    return customers

@get_router.get("/get_customer_id/{customer_name}")
def get_customers_name(customer_name: str, token: str = Depends(oauth_scheme)):
    customer = customers_db.find_one({'business_name': customer_name}, {'customer_id': 1})
    return customer['customer_id']

# ---------------------------------------- Supplier ----------------------------------------
@get_router.get("/get_suppliers")
def get_suppliers(token: str = Depends(oauth_scheme)):
    suppliers = supplier_serial(suppliers_db.find())
    return suppliers

@get_router.get("/get_supplier/{id}")
def get_suppliers(id:str, token: str = Depends(oauth_scheme)):
    suppliers = supplier_dict_serial(suppliers_db.find_one({'business_name': id}))
    return suppliers

@get_router.get("/get_suppliers_name")
def get_suppliers_name(token: str = Depends(oauth_scheme)):
    suppliers = supplier_name_serial(suppliers_db.distinct('business_name'))
    return suppliers

# ---------------------------------------- Sales Order ----------------------------------------
@get_router.get("/get_sale_orders")
def get_sale_orders(token: str = Depends(oauth_scheme)):
    sale_orders = sale_order_serial(sales_order_db.find())
    return sale_orders 

# ---------------------------------------- Procurement ----------------------------------------
@get_router.get("/get_procurement")
def get_procurement(token: str = Depends(oauth_scheme)):
    procurements = procurement_serial(procurement_db.find())
    return procurements
@get_router.get("/get_past_procurement/{category}")
def get_past_procurement(category: str, token: str = Depends(oauth_scheme)):
    procurements = procurement_serial(procurement_db.find({'status': category}))
    return procurements
@get_router.get("/get_present_procurement/{category}")
def get_present_procurement(category: str, token: str = Depends(oauth_scheme)):
    procurements = procurement_serial(procurement_db.find({'status': category}))
    return procurements

# ---------------------------------------- Product ----------------------------------------
@get_router.get("/get_products")
def get_product(token: str = Depends(oauth_scheme)):
    products = product_serial(product_db.find())
    return products

@get_router.get("/get_products_name")
def get_product_name(token: str = Depends(oauth_scheme)):
    product = product_name_serial(product_db.distinct('product_name'))
    # product = product_db.find({}, {'product_name': 1})
    # product_names = [item['product_name'] for item in product]
    # return product_names
    return product

@get_router.get("/get_product_id/{productName}")
def get_product_name(productName: str, token: str = Depends(oauth_scheme)):
    productid = product_db.find_one({'product_name': productName}, {'product_id': 1})
    return productid['product_id']

@get_router.get("/get_product_unit_price/{item}")
def get_product_unit_price(item: str, token: str = Depends(oauth_scheme)):
    product = product_db.find_one({'product_name': item}, {'unit_price': 1})
    return product['unit_price']

@get_router.get("/get_product_selling_price/{item}")
def get_product_selling_price(item: str, token: str = Depends(oauth_scheme)):
    product = product_db.find_one({'product_name': item}, {'selling_price': 1})
    return product['selling_price']

# ---------------------------------------- Inventory ----------------------------------------
@get_router.get("/get_inventories")
def get_inventory(token: str = Depends(oauth_scheme)):
    inventory = inventory_serial(inventory_db.find())
    return inventory

@get_router.get("/get_inventory_category/{category}")
def get_inventory_category(category: str, token: str = Depends(oauth_scheme)):
    inventory = inventory_serial(inventory_db.find({'status': category}))
    return inventory

@get_router.get("/get_inventory_name")
def get_inventory_name(token: str = Depends(oauth_scheme)):
    inventory = inventory_name_serial(inventory_db.distinct('item_name'))
    return inventory

@get_router.get("/inventory_unit_price/{item}")
def inventory_unit_price(item: str, token: str = Depends(oauth_scheme)):
    inventory = inventory_db.find_one({'item_name': item}, {'unit_price': 1})
    return inventory['unit_price']

# ---------------------------------------- Sale Management ----------------------------------------
@get_router.get("/get_company_monthly_sales")
def get_company_monthly_sales(token: str = Depends(oauth_scheme)):
    sales = company_monthly_sales_serial(sales_management_db.find())
    return sales

