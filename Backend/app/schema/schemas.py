def user_serial(user) -> dict:
    return {
        "Object id": str(user["_id"]),
        "Employee name": user["employee_name"],
        "Employee ID": user["employee_id"],
        "email": user["email"],
        "password": user["password"],
        "role": user["role"],
        "sales_record": user["sales_record"]
    }

def user_serial(users) -> list:
    return [user_serial(user) for user in users]