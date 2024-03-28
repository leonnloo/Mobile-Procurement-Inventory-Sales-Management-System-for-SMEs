from datetime import datetime
def processNextID(query: str) -> str:
    # Find the index of the first digit in the query
    index_of_first_digit = next((index for index, char in enumerate(query) if char.isdigit()), None)
    
    if index_of_first_digit is not None:
        # Extract the prefix
        prefix = query[:index_of_first_digit]
        
        # Extract the number part of the ID
        number_part = query[index_of_first_digit:]
        
        # Extract integers from the number part
        extracted_numbers = ''.join(char for char in number_part if char.isdigit())
        
        # Convert the extracted numbers to an integer
        result = int(extracted_numbers) + 1
        
        # Combine prefix and incremented number
        return f"{prefix}{result}"
    else:
        # If no digits found, return None
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