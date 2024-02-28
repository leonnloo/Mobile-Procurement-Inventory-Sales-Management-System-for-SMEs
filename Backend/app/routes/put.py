from fastapi import APIRouter, Depends, HTTPException, status
from config.database import *
from models.customer_model import CustomerInfo
from models.sales_order_model import SaleOrder
from models.supplier_model import SupplierInfo, NotesInfo
from models.procurement_model import Procurement 
from models.product_model import ProductItem 
from models.inventory_model import InventoryItem  
from models.sales_management_model import CompanyMonthlySales
from models import *
from schema.schemas import *
from fastapi.security import OAuth2PasswordBearer

put_router = APIRouter()
oauth_scheme = OAuth2PasswordBearer(tokenUrl="token")


# ----------------------------------------- Customer Update ----------------------------------------------
@put_router.put("/update_customer/{customer_id}")
def update_customer(customer: CustomerInfo):
    old_customer = customers_db.find_one({"customer_id": customer.customer_id})
    if old_customer:
        updated_customer = CustomerInfo(
            customer_id = customer.customer_id,
            business_name = customer.business_name,
            contact_person = customer.contact_person,
            email = customer.email,
            phone_number = customer.phone_number,
            billing_address = customer.billing_address,
            shipping_address = customer.shipping_address,
            past_order = old_customer["past_order"],
            refunds = old_customer["refunds"],
            notes = old_customer["notes"],
        )
        customers_db.update_one({"customer_id": customer.customer_id}, {"$set": dict(updated_customer)})
        return customer_dict_serial(customers_db.find_one({"customer_id": customer.customer_id}))
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Customer not found",
            headers={"WWW-Authenticate": "Bearer"},
        )
# ----------------------------------------- Supplier Update ----------------------------------------------
@put_router.put("/update_supplier/{supplier_id}")
def update_supplier(supplier: SupplierInfo):
    old_supplier = suppliers_db.find_one({"supplier_id": supplier.supplier_id})
    if old_supplier:
        updated_supplier = SupplierInfo(
            supplier_id = supplier.supplier_id,
            business_name = supplier.business_name,
            contact_person = supplier.contact_person,
            email = supplier.email,
            phone_number = supplier.phone_number,
            address = supplier.address,
            past_order = old_supplier["past_order"],
            notes = old_supplier["notes"],
        )
        suppliers_db.update_one({"supplier_id": supplier.supplier_id}, {"$set": dict(updated_supplier)})
        return supplier_dict_serial(suppliers_db.find_one({"supplier_id": supplier.supplier_id}))
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Supplier not found",
            headers={"WWW-Authenticate": "Bearer"},
        )




# ----------------------------------------- Sales Order Update ----------------------------------------------
@put_router.put("/update_sale_order/{order_no}")
def update_sale_order(order: SaleOrder):
    old_order = sales_order_db.find_one({"order_no": order.order_no})
    if old_order:
        sales_order_db.update_one({"order_no": order.order_no}, {"$set": dict(order)})
        return sale_order_dict_serial(sales_order_db.find_one({"order_no": order.order_no}))
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Sale order not found",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
# ----------------------------------------- Procurement Update ----------------------------------------------
@put_router.put("/update_procurement/{procurement_no}")
def update_procurement(purchase: Procurement):
    old_purchase = procurement_db.find_one({"purchase_no": purchase.purchase_no})
    if old_purchase:
        procurement_db.update_one({"purchase_no": purchase.purchase_no}, {"$set": dict(purchase)})
        return procurement_dict_serial(procurement_db.find_one({"purchase_no": purchase.purchase_no}))
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Purchase not found",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
# ----------------------------------------- Product Update ----------------------------------------------
@put_router.put("/update_product/{product_id}")
def update_product(product: ProductItem):
    old_product = product_db.find_one({"product_id": product.product_id})
    if old_product:
        product_db.update_one({"product_id": product.product_id}, {"$set": dict(product)})
        return product_dict_serial(product_db.find_one({"product_id": product.product_id}))
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Product not found",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
# ----------------------------------------- Inventory Update ----------------------------------------------
@put_router.put("/update_inventory/{item_id}")
def update_inventory(item: InventoryItem):
    old_item = inventory_db.find_one({"item_id": item.item_id})
    if old_item:
        inventory_db.update_one({"item_id": item.item_id}, {"$set": dict(item)})
        return inventory_dict_serial(inventory_db.find_one({"item_id": item.item_id}))
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Inventory item not found",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
# ----------------------------------------- Sales Management Update ----------------------------------------------
@put_router.put("/update_company_monthly_sales/{year}")
def update_company_monthly_sales(sales_by_month: CompanyMonthlySales):
    old_sales = sales_management_db.find_one({"year": sales_by_month.year})
    if old_sales:
        sales_management_db.update_one({"$and": [{"year": sales_by_month.year}, {"month": sales_by_month.sales}]}, {"$set": dict(sales_by_month)})
        return company_monthly_sales_dict_serial(sales_management_db.find_one({"year": sales_by_month.year}))
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Company Monthly Sales not found",
            headers={"WWW-Authenticate": "Bearer"},
        )

