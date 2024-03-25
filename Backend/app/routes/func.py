from datetime import datetime
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

def extract_year_month_day(date_str: str):
    try:
        date_obj = datetime.strptime(date_str, "%Y-%m-%d")
        year = date_obj.year
        month = date_obj.month
        day = date_obj.day
        return year, month, day
    except ValueError:
        raise ValueError("Invalid date format. Please provide a date in the format YYYY-MM-DD")


# # Example usage:
# date_str = "2024-03-19"
# year, month, day = extract_year_month_day(date_str)
# print("Year:", year)
# print("Month:", month)
# print("Day:", day)