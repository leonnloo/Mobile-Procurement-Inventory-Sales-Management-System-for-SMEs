# ---------------------------------------- User ----------------------------------------
def user_dict_serial(user) -> dict:
    return {
        # "Object id": str(user["_id"]),
        "employee_name": user["employee_name"],
        "employee_id": user["employee_id"],
        "email": user["email"],
        "phone_number": user["phone_number"],
        "password": user["password"],
        "role": user["role"],
        "sales_record": user["sales_record"]
    }

def user_serial(users) -> list:
    return [user_dict_serial(user) for user in users]
 
# ---------------------------------------- Supplier ----------------------------------------
def supplier_dict_serial(supplier) -> dict:
    return {
        "supplier_id": str(supplier["supplier_id"]),
        "business_name": supplier["business_name"],
        "contact_person": supplier["contact_person"],
        "email": supplier["email"],
        "phone_number": supplier["phone_number"],
        "address": supplier["address"],
        "past_order": supplier["past_order"],
        "notes": supplier["notes"]
    }

def supplier_serial(suppliers) -> list:
    return [supplier_dict_serial(supplier) for supplier in suppliers]

# ---------------------------------------- Customer ----------------------------------------
def customer_dict_serial(customer) -> dict:
    return {
        "customer_id": str(customer["customer_id"]),
        "business_name": customer["business_name"],
        "contact_person": customer["contact_person"],
        "email": customer["email"],
        "phone_number": customer["phone_number"],
        "billing_address": customer["billing_address"],
        "shipping_address": customer["shipping_address"],
        "past_order": customer["past_order"],
        "refunds": customer["refunds"],
        "notes": customer["notes"]
    }

def customer_serial(customers) -> list:
    return [customer_dict_serial(customer) for customer in customers]

# ---------------------------------------- Product ----------------------------------------
def product_dict_serial(product) -> dict:
    return {
        "product_id": str(product["product_id"]),
        "product_name": product["product_name"],
        "unit_price": product["unit_price"],
        "selling_price": product["selling_price"],
        "quantity": product["quantity"],
        "markup": product["markup"],
        "margin": product["margin"],
        "status": product["status"]
    } 

def product_serial(products) -> list:
    return [product_dict_serial(product) for product in products]


# ---------------------------------------- Procurement ----------------------------------------
def procurement_dict_serial(purchase) -> dict:
    return {
        "purchase_no": purchase["purchase_no"],
        "item_name": purchase["item_name"],
        "supplier": purchase["supplier"],
        "order_date": purchase["order_date"],
        "delivery_date": purchase["delivery_date"],
        "cost": purchase["cost"],
        "quantity": purchase["quantity"],
        "status": purchase["status"]
    }

def procurement_serial(purchases) -> list:
    return [procurement_dict_serial(purchase) for purchase in purchases]


# ---------------------------------------- Inventory ----------------------------------------
def inventory_dict_serial(inventory) -> dict:
    return {
        "item_id": str(inventory["item_id"]),
        "item_name": inventory["item_name"],
        "category": inventory["category"],
        "quantity": inventory["quantity"],
        "unit_price": inventory["unit_price"],
        "total_price": inventory["total_price"],
        "supplier": inventory["supplier"],
        "status": inventory["status"]
    }

def inventory_serial(inventories) -> list:
    return [inventory_dict_serial(inventory) for inventory in inventories]

# ---------------------------------------- Sales Order ----------------------------------------
def sale_order_dict_serial(sale_order) -> dict:
    return {
        "order_no": sale_order["order_no"],
        "date": sale_order["date"],
        "customer_id": sale_order["customer_id"],
        "product_id": sale_order["product_id"],
        "product_name": sale_order["product_name"],
        "quantity": sale_order["quantity"],
        "total_price": sale_order["total_price"],
        "status": sale_order["status"]
    }

def sale_order_serial(sale_orders) -> list:
    return [sale_order_dict_serial(sale_order) for sale_order in sale_orders]

# ---------------------------------------- Sales Management ----------------------------------------
def company_monthly_sales_dict_serial(sale) -> dict:
    return {
        "year": sale["year"],
        "month": sale["month"],
        "sales": sale["sales"]
    }

def company_monthly_sales_serial(sales) -> list:
    return [company_monthly_sales_dict_serial(sale) for sale in sales]


# ---------------------------------------- Notes ----------------------------------------
def note_dict_serial(note) -> dict:
    return {
        "note_id": str(note["note_id"]),
        "date": note["date"],
        "memo": note["memo"]
    }