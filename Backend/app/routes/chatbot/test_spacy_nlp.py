import spacy
from spacy.lang.en.examples import sentences
# Load the English language model
nlp = spacy.load("updated_ner_model")

# doc = nlp("Give me the Ethan who is the customer with the id of CO6 having sex with its mom.")
# print()
# print([(ent.text, ent.label_) for ent in doc.ents])


sentences = [
    # CustomID in Queries
    "Can you tell me the status of order ID SO789?",
    "What's the delivery date for procurement ID PR5671?",
    "Do we have any updates on product item PD21?",
    
    # EMAIL in Queries
    "What is the contact email for the account associated with customer ID CO4234156?",
    "Who should I reach out to at Tech Innovations Inc. for billing questions?",
    
    # BUSINESS-NAME in Queries
    "Which supplier delivered the Bamboo Cutting Boards?",
    "Can you confirm if QuickFix Solutions processed our last order?",
    
    # PHONE-NUMBER in Queries
    "What's the contact number for our supplier, GreenTech Solutions?",
    "How can I get in touch with Solar Dynamics customer service?",
    
    # ITEM-QUANTITY in Queries
    "How many units of the EcoSmart light bulbs do we have in stock?",
    "Can you check the available quantity of Kingston DataTraveler USB drives?",
    
    # PRICE in Queries
    "What was the unit price for the Graphene Battery Packs in our last purchase?",
    "Can you find the total price for order ID SO456?",
    
    # STATUS in Queries
    "Is the shipment with order ID SO234 on track for delivery?",
    "What is the current status of customer ID CO345's order?",
    
    # ADDRESS in Queries
    "What is the shipping address for customer ID CO678526?",
    "Can you update the billing address for our office located at 500 Tesla Court, Fremont, CA?",
    
    # ITEM-NAME in Queries
    "Do we need to reorder the Philips Hue smart light bulbs soon?",
    "What's the latest inventory count for Adidas Yeezy Boost 350 sneakers?",
    
    # Complex Queries
    "Could you provide the contact details for the person handling our account at BrightScreen Technologies?",
    "I'm looking for the delivery date and total cost for the order containing 50 units of MultiSync LCDs. Can you help?",
    "What are the warranty terms for the product ID PD012, and whom should I contact for service?",
    
    # Additional sentence
    "The return request for product ID PD102 was initiated by customer ID CO897.",
]


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