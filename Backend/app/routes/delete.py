from fastapi import APIRouter, Depends, HTTPException, status
from config.database import *
from models import *
from schema.schemas import *
from fastapi.security import OAuth2PasswordBearer
from datetime import datetime
from routes.func import *

delete_router = APIRouter()
oauth_scheme = OAuth2PasswordBearer(tokenUrl="token")

# ---------------------------------------- Customer ----------------------------------------
@delete_router.delete("/delete_customer/{id}")
def delete_customer(id: str, token: str = Depends(oauth_scheme)):
    customer = customers_db.delete_one({'customer_id': id})
    if customer.deleted_count > 0:
        return {"message": f"Customer with id {id} deleted successfully"}
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Customer with id {id} not found",
        )
    
# ---------------------------------------- Supplier ----------------------------------------
@delete_router.delete("/delete_supplier/{id}")
def delete_suppliers(id: str, token: str = Depends(oauth_scheme)):
    delete_result = suppliers_db.delete_one({'supplier_id': id})

    if delete_result.deleted_count > 0:
        return {"message": f"Supplier with id {id} deleted successfully"}
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Supplier with id {id} not found",
        )

# ---------------------------------------- Sales Order ----------------------------------------
@delete_router.delete("/delete_sale_order/{id}")
def delete_sale_order(id: str, token: str = Depends(oauth_scheme)):
    deleted_order = sales_order_db.find_one({'order_id': id})
    product = product_db.find_one({"product_id": deleted_order['product_id']})
    
    # Only update monthly and employee sales if order is completed
    if deleted_order['order_status'] == 'Completed':
        year, month, day = extract_year_month_day(deleted_order['order_date'])
        # update monthly sales
        monthly_sale = monthly_sales_db.find_one({"year": year, "month": month})
        if monthly_sale:
            monthly_sale['actual_sales'] -= deleted_order['total_price']
            monthly_sales_db.update_one({"year": year, "month": month}, {"$set": monthly_sale})

        # update employee sales
        employee = users_db.find_one({"employee_id": deleted_order['employee_id']})
        if employee:
            for record in employee['sales_record']:
                if record['year'] == year and record['month'] == month:
                    record['sales'] -= deleted_order['total_price']
            users_db.update_one({"employee_id": deleted_order['employee_id']}, {"$set": employee})

        # update product monthly sales
        if product:
            for record in product['monthly_sales']:
                if record['year'] == year and record['month'] == month:
                    record['total_price'] -= deleted_order['total_price']
                    record['quantity_sold'] -= deleted_order['quantity']
                    break

    # update product
    if product:
        product['quantity'] += deleted_order['quantity']
        if product['quantity'] > 0 and product['quantity'] >= product['critical_level']:
            new_status = 'In Stock'
        elif product['quantity'] > 0 and product['quantity'] < product['critical_level']:
            new_status = 'Low Stock'
        else:
            new_status = 'Out of Stock'
        product['status'] = new_status
        product_db.update_one({'product_id': deleted_order['product_id']}, {'$set': product})

    result = sales_order_db.delete_one({'order_id': id})
    if result.deleted_count > 0:
        return {"message": f"Sale order with id {id} deleted successfully"}
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Sale order with id {id} not found",
        )

# ---------------------------------------- Procurement ----------------------------------------
# ! UPDATE BOUGHT PURCHASE ITEMS
@delete_router.delete("/delete_procurement/{id}")
def delete_procurement(id: str, token: str = Depends(oauth_scheme)):
    result = procurement_db.delete_one({'purchase_no': id})

    if result.deleted_count > 0:
        return {"message": f"Procurement with id {id} deleted successfully"}
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Procurement with id {id} not found",
        )

# ---------------------------------------- Product ----------------------------------------
@delete_router.delete("/delete_product/{id}")
def delete_product(id: str, token: str = Depends(oauth_scheme)):
    result = product_db.delete_one({'product_id': id})

    if result.deleted_count > 0:
        return {"message": f"Product with id {id} deleted successfully"}
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Product with id {id} not found",
        )


# ---------------------------------------- Inventory ----------------------------------------
@delete_router.delete("/delete_inventory/{id}")
def delete_inventory(id: str, token: str = Depends(oauth_scheme)):
    result = inventory_db.delete_one({'item_id': id})

    if result.deleted_count > 0:
        return {"message": f"Inventory item with id {id} deleted successfully"}
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Inventory item with id {id} not found",
        )

