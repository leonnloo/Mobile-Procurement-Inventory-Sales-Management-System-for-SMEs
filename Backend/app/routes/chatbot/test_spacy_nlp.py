import spacy
from spacy.lang.en.examples import sentences
# Load the English language model
nlp = spacy.load("updated_ner_model")
from dateutil import parser
from datetime import datetime

# def format_date(date_str):
#     try:
#         # Parse the date
#         parsed_date = parser.parse(date_str, dayfirst=True, fuzzy=True)
#         # Format the date
#         return parsed_date.strftime("%Y-%m-%d")
#     except (ValueError, TypeError):
#         print(f"Could not parse '{date_str}'.")
#         return None

# # Examples of usage:
# dates = [
#     "March 15, 2023",
#     "04/22/2024",
#     "July 4th",
#     "31/12/2023",
#     "2023-11-30",
#     "the first of June",
#     "January 2020",
#     "Q3 2024",
#     "the last Friday of November",
#     "the second Sunday in March",
#     "the end of this month",
#     "the twenty-third of April, 1998",
#     "May 5th",
#     "April 15",
#     "the third weekend of August"
# ]

# for date in dates:
#     formatted_date = format_date(date)
#     if formatted_date:
#         print(f"Original: {date}, Formatted: {formatted_date}")

# doc = nlp("Give me the Ethan who is the customer with the id of CO6 having sex with its mom.")
# print()
# print([(ent.text, ent.label_) for ent in doc.ents])
sentences = [
    "What is the status of procurement with ID PR234?",
    "Can you check the inventory levels for product ID PD456?",
    "I need shipping details for order ID SO789.",
    "Show me the last purchase date for supplier ID SP101.",
    "Has customer ID CO345 made any recent orders?",
    "What's the delivery timeframe for procurement ID PR567?",
    "Provide transaction history for customer ID CO678.",
    "Detail the product specifications for ID PD789.",
    "How many units are left for item ID IV901 in stock?",
    "Are there any pending deliveries for order ID SO234?",
    "What are the warranty terms for product ID PD012?",
    "Can I get a reorder timeline for supplier ID SP345?",
    "Please update the billing address for customer ID CO456.",
    "Check if there are any returns for product ID PD678.",
    "What was the last shipment date for item ID IV789?",
    "Give me the product Chair."
]


from word2number import w2n

# def words_to_number(words):
#     # Check if the input is already a number (int or float)
#     if isinstance(words, (int, float)):
#         return words
#     try:
#         return float(words) if '.' in words else int(words)
#     except ValueError:
#         try:
#             # Attempt to convert from words to number using w2n
#             # Note: This does not handle floating numbers in word form
#             return w2n.word_to_num(words)
#         except ValueError:
#             print(f"Could not convert '{words}' to a number.")
#             return None

# words_list = [69, 69.69, "69.1", "twenty-five", "one hundred", "three hundred and forty-two", "two thousand twenty", "69"]

# for words in words_list:
#     print(f"'{words}' -> {words_to_number(words)}")



for sentence in sentences:
    doc = nlp(sentence)
    print(f"Sentence: '{sentence}'")
    entities = [(ent.text, ent.label_) for ent in doc.ents]
    print([(token.text, token.idx) for token in doc])
    if entities:
        print("Entities and their labels:", entities)
    else:
        print("No entities found.")
    print()