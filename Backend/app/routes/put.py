from fastapi import APIRouter, Depends, HTTPException, status
from config.database import *
from models.customer_model import *
from models.sales_order_model import *
from models.supplier_model import *
from models.procurement_model import * 
from models.product_model import * 
from models.inventory_model import *  
from models.sales_management_model import CompanyMonthlySales
from models import *
from schema.schemas import *
from fastapi.security import OAuth2PasswordBearer

put_router = APIRouter()
oauth_scheme = OAuth2PasswordBearer(tokenUrl="token")


# ----------------------------------------- Customer Update ----------------------------------------------
@put_router.put("/update_customer/{customerID}")
def update_customer(customer: NewCustomer, customerID: str, token: str = Depends(oauth_scheme)):
    old_customer = customers_db.find_one({"customer_id": customerID})
    if old_customer:
        updated_customer = CustomerInfo(
            customer_id = old_customer["customer_id"],
            business_name = customer.business_name,
            contact_person = customer.contact_person,
            email = customer.email,
            phone_number = customer.phone_number,
            billing_address = customer.billing_address,
            shipping_address = customer.shipping_address,
            past_order = old_customer["past_order"],
            notes = old_customer["notes"],
        )
        customers_db.update_one({"customer_id": customerID}, {"$set": dict(updated_customer)})
        return customer_dict_serial(customers_db.find_one({"customer_id": customerID}))
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Customer not found",
            headers={"WWW-Authenticate": "Bearer"},
        )
# ----------------------------------------- Supplier Update ----------------------------------------------
@put_router.put("/update_supplier/{supplierID}")
def update_supplier(supplier: NewSupplier, supplierID: str, token: str = Depends(oauth_scheme)):
    old_supplier = suppliers_db.find_one({"supplier_id": supplierID})
    if old_supplier:
        updated_supplier = SupplierInfo(
            supplier_id = old_supplier["supplier_id"],
            business_name = supplier.business_name,
            contact_person = supplier.contact_person,
            email = supplier.email,
            phone_number = supplier.phone_number,
            address = supplier.address,
            past_order = old_supplier["past_order"],
            notes = old_supplier["notes"],
        )
        suppliers_db.update_one({"supplier_id": supplierID}, {"$set": dict(updated_supplier)})
        return supplier_dict_serial(suppliers_db.find_one({"supplier_id": supplierID}))
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Supplier not found",
            headers={"WWW-Authenticate": "Bearer"},
        )




# ----------------------------------------- Sales Order Update ----------------------------------------------
@put_router.put("/update_sale_order/{order_no}")
def update_sale_order(order: SaleOrder, token: str = Depends(oauth_scheme)):
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
def update_procurement(purchase: NewProcurement, procurement_no: str, token: str = Depends(oauth_scheme)):
    old_purchase = procurement_db.find_one({"purchase_no": procurement_no})
    if old_purchase:
        procurement_db.update_one({"purchase_no": procurement_no}, {"$set": dict(purchase)})
        return procurement_dict_serial(procurement_db.find_one({"purchase_no": procurement_no}))
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Purchase not found",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
# ----------------------------------------- Product Update ----------------------------------------------
@put_router.put("/update_product/{productID}")
def update_product(product: NewProduct, productID: str, token: str = Depends(oauth_scheme)):
    old_product = product_db.find_one({"product_id": productID})
    if old_product:
        updated_product = ProductItem(
            product_id = old_product["product_id"],
            product_name = product.product_name,
            unit_price = product.unit_price,
            selling_price = product.selling_price,
            markup = product.markup,
            margin = product.margin,
            quantity = old_product["quantity"],
            status = old_product["status"],
        )
        product_db.update_one({"product_id": productID}, {"$set": dict(updated_product)})
        return product_dict_serial(product_db.find_one({"product_id": productID}))
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Product not found",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
# ----------------------------------------- Inventory Update ----------------------------------------------
    # ! critical level update
@put_router.put("/update_inventory/{item_id}")
def update_inventory(item: EditInventoryItem, item_id: str, token: str = Depends(oauth_scheme)):
    old_item = inventory_db.find_one({"item_id": item_id})
    if old_item:
        if item.quantity < 0:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Quantity cannot be negative",
                headers={"WWW-Authenticate": "Bearer"},
            )
        
        if item.quantity > 0:
            new_status = "In Stock"
        elif item.quantity == 0:
            new_status = "Out of Stock";

        updated_item = InventoryItem(
            item_id = item_id,
            item_name = item.item_name,
            category = item.category,
            quantity = item.quantity,
            unit_price = item.unit_price,
            total_price = item.unit_price * item.quantity,
            status = new_status,
        )

        inventory_db.update_one({"item_id": item_id}, {"$set": dict(updated_item)})
        return inventory_dict_serial(inventory_db.find_one({"item_id": item_id}))
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Inventory item not found",
            headers={"WWW-Authenticate": "Bearer"},
        )

@put_router.put("/stock_in_out_inventory")
def stock_in_out_inventory(item: StockInOutInventoryItem, token: str = Depends(oauth_scheme)):
    old_item = inventory_db.find_one({"item_name": item.item_name})
    if old_item:
        new_quantity = old_item["quantity"] + item.quantity
        if new_quantity < 0:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Quantity cannot be negative",
                headers={"WWW-Authenticate": "Bearer"},
            )

        if new_quantity > 0:
            new_status = "In Stock"
        elif new_quantity == 0:
            new_status = "Out of Stock";  
        
        updated_item = InventoryItem(
            item_id = old_item["item_id"],
            item_name = item.item_name,
            category = old_item["category"],
            quantity = new_quantity,
            unit_price = old_item["unit_price"],
            total_price = old_item["unit_price"] * new_quantity,
            status = new_status,
        )

        inventory_db.update_one({"item_name": item.item_name}, {"$set": dict(updated_item)})
        return inventory_dict_serial(inventory_db.find_one({"item_name": item.item_name}))
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Inventory item not found",
            headers={"WWW-Authenticate": "Bearer"},
        )
    

    
    
# ----------------------------------------- Sales Management Update ----------------------------------------------
@put_router.put("/update_company_monthly_sales/{year}")
def update_company_monthly_sales(sales_by_month: CompanyMonthlySales, token: str = Depends(oauth_scheme)):
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

