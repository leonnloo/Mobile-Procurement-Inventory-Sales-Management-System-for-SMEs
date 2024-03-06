from fastapi import APIRouter, Depends, HTTPException, status
from models.customer_model import *
from models.sales_order_model import *
from models.supplier_model import *
from models.procurement_model import *
from models.product_model import *
from models.inventory_model import *
from config.database import *
from fastapi.security import OAuth2PasswordBearer

form_router = APIRouter()
oauth_scheme = OAuth2PasswordBearer(tokenUrl="token")


def processNextID(query: str) -> str:
    # Extract integers from the string
    extracted_numbers = ''.join(char for char in query if char.isdigit())

    # Convert the extracted numbers to an integer
    result = int(extracted_numbers) if extracted_numbers else None
    if result:
        result += 1
        # Extract the first two characters from the original query
        first_two_characters = query[:2]
        # Append them to the result
        result_with_prefix = f"{first_two_characters}{result}"
        return result_with_prefix
    else:
        return None

# ----------------------------------------- Customer Form ----------------------------------------------
@form_router.post("/customer_form")
def create_customer(customer: NewCustomer):
    existing_customer = customers_db.find_one({"business_name": customer.business_name})
    if existing_customer:
        raise HTTPException(
        status_code = status.HTTP_403_FORBIDDEN,
        detail = "Customer business registered",
    )

    # Find the document with the largest customer_id
    latest_id_document = customers_db.find_one(sort=[("customer_id", -1)])

    # Determine the next customer_id
    if latest_id_document:
        query_id = latest_id_document.get("customer_id", "-1")
        next_customer_id = processNextID(query_id)
    else:
        next_customer_id = "CO1"


    updated_customer = CustomerInfo(
        customer_id = next_customer_id,
        business_name = customer.business_name,
        contact_person = customer.contact_person,
        email = customer.email,
        phone_number = customer.phone_number,
        billing_address = customer.billing_address,
        shipping_address = customer.shipping_address,
        past_order = None,
        notes = None,
    )

    customers_db.insert_one(dict(updated_customer))
    return {"Message": "Customer successfully registered"}

# ----------------------------------------- Supplier Form ----------------------------------------------
@form_router.post("/supplier_form")
def register(supplier: SupplierInfo):
    existing_supplier = suppliers_db.find_one({"business_name": supplier.business_name})
    if existing_supplier:
        raise HTTPException(
        status_code = status.HTTP_403_FORBIDDEN,
        detail = "Customer business registered",
    )

    # Find the document with the largest supplier_id
    latest_id_document = suppliers_db.find_one(sort=[("supplier_id", -1)])

    # Determine the next supplier_id
    if latest_id_document:
        query_id = latest_id_document.get("supplier_id", "-1")
        next_supplier_id = processNextID(query_id)
    else:
        next_supplier_id = "SP1"

    updated_supplier = SupplierInfo(
        supplier_id = next_supplier_id,
        business_name = supplier.business_name,
        contact_person = supplier.contact_person,
        email = supplier.email,
        phone_number = supplier.phone_number,
        address = supplier.address,
        past_order = None,
        notes = None,
    )

    suppliers_db.insert_one(dict(updated_supplier))
    return {"Message": "Supplier successfully registered"}

# ! Update monthly sales when inputting a new order
# ----------------------------------------- Sales Form ----------------------------------------- 
@form_router.post("/sales_order_form")
def register(order: SaleOrder):
    latest_id_document = sales_order_db.find_one(sort=[("order_no", -1)])

    if latest_id_document:
        query_id = latest_id_document.get("order_no", "-1")
        next_order_no = processNextID(query_id)
    else:
        next_order_no = "SO1"

    updated_order = SaleOrder(
        order_no = next_order_no,
        date = order.date,
        customer_id = order.customer_id,
        product_id = order.product_id,
        product_name = order.product_name,
        quantity = order.quantity,
        total_price = order.total_price,
        status = order.status,
    )

    sales_order_db.insert_one(dict(updated_order))
    return {"Message": "Sales order successfully registered"}

# ----------------------------------------- Procurement Form ----------------------------------------------
@form_router.post("/procurement_form")
def register(procurement: Procurement):
    latest_id_document = procurement_db.find_one(sort=[("purchase_no", -1)])

    if latest_id_document:
        query_id = latest_id_document.get("purchase_no", "-1")
        next_purchase_no = processNextID(query_id)
    else:
        next_purchase_no = "PR1"

    updated_procurement = Procurement(
        purchase_no = next_purchase_no,
        supplier = procurement.supplier,
        item_name = procurement.item_name,
        order_date = procurement.order_date,
        delivery_date = procurement.delivery_date,
        cost = procurement.cost,
        quantity = procurement.quantity,
        status = procurement.status,
    )

    procurement_db.insert_one(dict(updated_procurement))
    return {"Message": "Procurement successfully registered"}

# ----------------------------------------- Product Form ----------------------------------------------
@form_router.post("/product_form")
def register(product: ProductItem):
    if product_db.find_one({"product_name": product.product_name}):
        raise HTTPException(
            status_code = status.HTTP_403_FORBIDDEN,
            detail = "Product name already registered",
        )

    latest_id_document = product_db.find_one(sort=[("product_id", -1)])

    if latest_id_document:
        query_id = latest_id_document.get("product_id", "-1")
        next_product_no = processNextID(query_id)
    else:           
        next_product_no = "PD1"

    updated_product = ProductItem(
        product_id = next_product_no,
        product_name = product.product_name,
        unit_price = product.unit_price,
        selling_price = product.selling_price,
        quantity = product.quantity,
        markup = product.markup,
        margin = product.margin,
        status = product.status,
    )

    product_db.insert_one(dict(updated_product))
    return {"Message": "Product successfully registered"}

# ! item
# ----------------------------------------- Inventory Form ----------------------------------------------
@form_router.post("/inventory_form")
def register(inventory: InventoryItem):
    if inventory_db.find_one({"item_name": inventory.item_name}):
        raise HTTPException(
            status_code = status.HTTP_403_FORBIDDEN,
            detail = "Inventory name already registered",
        )

    latest_id_document = inventory_db.find_one(sort=[("item_id", -1)])

    if latest_id_document:
        query_id = latest_id_document.get("item_id", "-1")
        next_inventory_no = processNextID(query_id)
    else:
        next_inventory_no = "IV1"

    updated_inventory = InventoryItem(
        item_id = next_inventory_no,
        item_name = inventory.item_name,
        category = inventory.category,
        quantity = inventory.quantity,
        unit_price = inventory.unit_price,
        total_price = inventory.total_price,
        supplier = inventory.supplier,
        status = inventory.status,
    )

    inventory_db.insert_one(dict(updated_inventory))
    return {"Message": "Inventory successfully registered"}