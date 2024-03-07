from fastapi import APIRouter, Depends, HTTPException, status
from config.database import *
from models import *
from schema.schemas import *
from fastapi.security import OAuth2PasswordBearer

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
    result = sales_order_db.delete_one({'order_id': id})
    
    if result.deleted_count > 0:
        return {"message": f"Sale order with id {id} deleted successfully"}
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Sale order with id {id} not found",
        )

# ---------------------------------------- Procurement ----------------------------------------
@delete_router.delete("/delete_procurement/{id}")
def delete_procurement(id: str, token: str = Depends(oauth_scheme)):
    result = procurement_db.delete_one({'procurement_id': id})

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
    result = inventory_db.delete_one({'inventory_id': id})

    if result.deleted_count > 0:
        return {"message": f"Inventory item with id {id} deleted successfully"}
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Inventory item with id {id} not found",
        )


# ---------------------------------------- Sale Management ----------------------------------------
@delete_router.delete("/delete_company_monthly_sales/{id}")
def delete_company_monthly_sales(id: str, token: str = Depends(oauth_scheme)):
    result = sales_management_db.delete_one({'monthly_sales_id': id})

    if result.deleted_count > 0:
        return {"message": f"Company monthly sales with id {id} deleted successfully"}
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Company monthly sales with id {id} not found",
        )

