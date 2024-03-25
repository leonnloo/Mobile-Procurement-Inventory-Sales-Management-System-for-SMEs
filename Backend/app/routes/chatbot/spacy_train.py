import random
import spacy
from spacy.training.example import Example
from spacy.training import offsets_to_biluo_tags
# Load a pre-trained spaCy model
nlp = spacy.load("en_core_web_lg")
# nlp = spacy.blank("en")

if "ner" not in nlp.pipe_names:
    ner = nlp.add_pipe("ner")
else:
    ner = nlp.get_pipe("ner")

labels = ["customID", "EMAIL", "BUSINESS-NAME", "PHONE-NUMBER", "ITEM-QUANTITY", "PRICE", "STATUS", "ADDRESS", "ITEM-NAME"]
for label in labels:
    ner.add_label(label)

# Prepare your annotated training data
train_data = [
    # ------------------------------ customID ------------------------------ 
    ("We received a new order from customer ID CO1 yesterday.", {"entities": [(41, 44, "customID")]}),
    ("Supplier SP1 delivered the items on time.", {"entities": [(9, 12, "customID")]}),
    ("Inventory check for item IV1 shows low stock levels.", {"entities": [(25, 28, "customID")]}),
    ("Procurement PR1 has been approved and is now in processing.", {"entities": [(12, 15, "customID")]}),
    ("Product item PD1 is currently our best-seller in the electronics category.", {"entities": [(13, 16, "customID")]}),
    ("Sales order SO1 was fulfilled last week.", {"entities": [(12, 15, "customID")]}),
    ("Can you provide the details for customer CO2?", {"entities": [(41, 44, "customID")]}),
    ("What is the latest update on supplier SP2's delivery schedule?", {"entities": [(38, 41, "customID")]}),
    ("I need the stock levels for inventory item IV2 as soon as possible.", {"entities": [(43, 46, "customID")]}),
    ("Please send the purchase order associated with procurement PR2.", {"entities": [(59, 62, "customID")]}),
    ("Do we have any updates on product item PD21?", {"entities": [(39, 43, "customID")]}),
    ("When was sales order SO2 last updated in our system?", {"entities": [(21, 24, "customID")]}),
    ("Check the status for customer CO3 in the CRM.", {"entities": [(30, 33, "customID")]}),
    ("Has supplier SP3 been notified about the payment terms?", {"entities": [(13, 16, "customID")]}),
    ("Is inventory item IV3 available for immediate shipment?", {"entities": [(18, 21, "customID")]}),
    ("What's the delivery date for procurement PR3?", {"entities": [(41, 44, "customID")]}),
    ("How many units of product item PD3 are in stock?", {"entities": [(31, 34, "customID")]}),
    ("Confirm if sales order SO3 has been dispatched.", {"entities": [(23, 26, "customID")]}),
    ("What is the status of procurement with ID PR234?", {"entities": [(42, 47, "customID")]}),
    ("Can you check the inventory levels for product ID PD456?", {"entities": [(50, 55, "customID")]}),
    ("I need shipping details for order ID SO789.", {"entities": [(37, 42, "customID")]}),
    ("Show me the last purchase date for supplier ID SP101.", {"entities": [(47, 52, "customID")]}),
    ("Has customer ID CO345 made any recent orders?", {"entities": [(16, 21, "customID")]}),
    ("What's the delivery timeframe for procurement ID PR5671?", {"entities": [(49, 55, "customID")]}),
    ("Provide transaction history for customer ID CO678526.", {"entities": [(44, 52, "customID")]}),
    ("Detail the product specifications for ID PD789.", {"entities": [(41, 46, "customID")]}),
    ("How many units are left for item ID IV901 in stock?", {"entities": [(36, 41, "customID")]}),
    ("Are there any pending deliveries for order ID SO234?", {"entities": [(46, 51, "customID")]}),
    ("What are the warranty terms for product ID PD012?", {"entities": [(43, 48, "customID")]}),
    ("Can I get a reorder timeline for supplier ID SP3425?", {"entities": [(45, 51, "customID")]}),
    ("Please update the billing address for customer ID CO4234156.", {"entities": [(50, 59, "customID")]}),
    ("Check if there are any returns for product ID PD678.", {"entities": [(46, 51, "customID")]}),
    ("What was the last shipment date for item ID IV789?", {"entities": [(44, 49, "customID")]}),
    
    # ------------------------------ EMAIL ------------------------------ 
    ("Please contact john.doe@example.com for more information.", {"entities": [(15, 35, "EMAIL")]}),
    ("Send your response to jane.smith@company.org", {"entities": [(22, 44, "EMAIL")]}),
    ("You can reach out at info@startup.io with your questions.", {"entities": [(21, 36, "EMAIL")]}),
    ("Our support email is support@techhub.com, feel free to drop a message.", {"entities": [(21, 40, "EMAIL")]}),
    ("For partnerships, please email partner.relations@globalnet.net.", {"entities": [(31, 62, "EMAIL")]}),
    ("The HR department can be reached at hr@ourcompany.com.", {"entities": [(36, 53, "EMAIL")]}),
    ("To unsubscribe, please send an email to unsubscribe@newslettersite.com.", {"entities": [(40, 70, "EMAIL")]}),
    ("Any complaints? Email us at feedback@serviceprovider.com", {"entities": [(28, 56, "EMAIL")]}),

    # ----------------------------- PERSON ------------------------
    ("Mr. Leon.", {"entities": [(4, 8, "PERSON")]}),
    ("Give me the information about the customer Ethan with the id of CO69 having fun with his mom.", {"entities": [(43, 48, "PERSON"), (64, 68 , "customID")]}),
    ("Contact Alex Smith for further assistance.", {"entities": [(8, 18, "PERSON")]}),
    ("Samantha will be leading the next meeting.", {"entities": [(0, 8, "PERSON")]}),
    ("Is Jessica attending the conference tomorrow?", {"entities": [(3, 10, "PERSON")]}),
    ("Daniel's report was exceptionally well-received.", {"entities": [(0, 6, "PERSON")]}),
    ("Please forward the email to Michael Jordan.", {"entities": [(28, 42, "PERSON")]}),
    ("Sara and Tom are working on the project proposal.", {"entities": [(0, 4, "PERSON"), (9, 12, "PERSON")]}),
    ("Dr. Emily Stone will review the medical records.", {"entities": [(4, 15, "PERSON")]}),
    ("The artwork by Leonardo Da Vinci is priceless.", {"entities": [(15, 32, "PERSON")]}),
    ("Can you ask Rachel Green to send the files?", {"entities": [(12, 24, "PERSON")]}),
    ("Notify Prof. John Doe about the schedule change.", {"entities": [(13, 21, "PERSON")]}),
    ("David and Victoria will be attending the gala.", {"entities": [(0, 5, "PERSON"), (10, 18, "PERSON")]}),


    # ----------------------------- BUSINESS-NAME -----------------------------
    ("I ordered the parts from Tech Innovations Inc.", {"entities": [(25, 46, "BUSINESS-NAME")]}),
    ("Our main supplier, GreenTech Solutions, just delivered the new batch.", {"entities": [(19, 38, "BUSINESS-NAME")]}),
    ("Please draft a contract for Velocity Enterprises.", {"entities": [(28, 48, "BUSINESS-NAME")]}),
    ("The partnership with Phoenix Industries will bring new opportunities.", {"entities": [(21, 39, "BUSINESS-NAME")]}),
    ("Jupiter Communications LLC has submitted their proposal.", {"entities": [(0, 26, "BUSINESS-NAME")]}),
    ("The invoice from Lunar Properties Ltd. was received yesterday.", {"entities": [(17, 38, "BUSINESS-NAME")]}),
    ("Can you check if we have an account with Alpine Electronics?", {"entities": [(41, 59, "BUSINESS-NAME")]}),
    ("Solar Dynamics is a new contender in the renewable energy market.", {"entities": [(0, 14, "BUSINESS-NAME")]}),
    ("Our coffee is sourced directly from Mountaintop Coffee Roasters.", {"entities": [(36, 63, "BUSINESS-NAME")]}),
    ("The software developed by CipherTech has been deployed.", {"entities": [(26, 36, "BUSINESS-NAME")]}),
    ("Next week's meeting is with the team from Quantum Solutions Inc.", {"entities": [(42, 59, "BUSINESS-NAME")]}),
    ("BrightStar Logistics provided the shipping estimate.", {"entities": [(0, 20, "BUSINESS-NAME")]}),
    ("A new branch of Waterfront Bistro just opened downtown.", {"entities": [(16, 26, "BUSINESS-NAME")]}),
    ("Contact BlueRiver Associates for investment advice.", {"entities": [(8, 28, "BUSINESS-NAME")]}),
    ("PioneerTech and Nova Industries have merged to form a new company.", {"entities": [(0, 11, "BUSINESS-NAME"), (16, 31, "BUSINESS-NAME")]}),

    # ----------------------------- PHONE-NUMBER -----------------------------
    ("You can reach us at (555) 123-4567 for support.", {"entities": [(20, 34, "PHONE-NUMBER")]}),
    ("Our office number is +1-800-555-0199.", {"entities": [(21, 36, "PHONE-NUMBER")]}),
    ("Fax your documents to 555.987.6543.", {"entities": [(22, 34, "PHONE-NUMBER")]}),
    ("For reservations, call 555 321 0987.", {"entities": [(23, 35, "PHONE-NUMBER")]}),
    ("The helpline +44 20 7946 0991 is available 24/7.", {"entities": [(13, 29, "PHONE-NUMBER")]}),
    ("Contact our agent at 555-1122 for more details.", {"entities": [(21, 29, "PHONE-NUMBER")]}),
    ("Reach out to our sales department at +49 30 123456.", {"entities": [(37, 50, "PHONE-NUMBER")]}),
    ("For inquiries outside the US, dial +91-98765-43210.", {"entities": [(35, 50, "PHONE-NUMBER")]}),
    ("Our Sydney office can be reached at (02) 9876 5432.", {"entities": [(36, 50, "PHONE-NUMBER")]}),
    ("WhatsApp inquiries: +1 (555) 654-3210.", {"entities": [(20, 37, "PHONE-NUMBER")]}),
    ("Our 24-hour hotline is 0800 555 111.", {"entities": [(23, 35, "PHONE-NUMBER")]}),
    ("Book your appointment, call 123-456-7890 now!", {"entities": [(28, 40, "PHONE-NUMBER")]}),
    ("Our customer service can be reached at (123) 456 7890 during business hours.", {"entities": [(39, 53, "PHONE-NUMBER")]}),

    # ----------------------------- DATES -----------------------------
    ("The contract expires on March 15, 2023.", {"entities": [(24, 32, "DATE")]}),
    ("Our next meeting is scheduled for 04/22/2024.", {"entities": [(34, 44, "DATE")]}),
    ("Independence Day is celebrated on July 4th every year.", {"entities": [(34, 42, "DATE")]}),
    ("Please deliver the materials by 31/12/2023.", {"entities": [(32, 42, "DATE")]}),
    ("Please deliver the materials by 2023/12/31.", {"entities": [(32, 42, "DATE")]}),
    ("The warranty period ends on 2023-11-30.", {"entities": [(28, 38, "DATE")]}),
    ("The warranty period ends on 31-03-2003.", {"entities": [(28, 38, "DATE")]}),
    ("The project started on January 2020.", {"entities": [(23, 35, "DATE")]}),
    ("We will launch the new product in Q3 2024.", {"entities": [(34, 41, "DATE")]}),
    ("She was born on the twenty-third of April, 1998.", {"entities": [(20, 47, "DATE")]}),
    ("Our anniversary is on May 5th.", {"entities": [(22, 29, "DATE")]}),
    ("Tax documents must be filed by April 15.", {"entities": [(31, 39, "DATE")]}),

    # ----------------------------- ITEM-QUANTITY -----------------------------
    ("We need to order 500 units of the new processors.", {"entities": [(17, 20, "ITEM-QUANTITY")]}),
    ("The client requested twenty-five chairs for the event.", {"entities": [(21, 32, "ITEM-QUANTITY")]}),
    ("A total of 1500 sheets of paper were used last month.", {"entities": [(11, 15, "ITEM-QUANTITY")]}),
    ("The recipe calls for two cups of flour.", {"entities": [(21, 24, "ITEM-QUANTITY")]}),
    ("Order seventy bolts of cotton fabric.", {"entities": [(6, 13, "ITEM-QUANTITY")]}),
    ("We have only 2 boxes of nails left in stock.", {"entities": [(13, 14, "ITEM-QUANTITY")]}),
    ("They delivered 15 tons of gravel yesterday.", {"entities": [(15, 17, "ITEM-QUANTITY")]}),
    ("Each pack contains 12 water bottles.", {"entities": [(19, 21, "ITEM-QUANTITY")]}),
    ("We sold 300 tickets for the concert.", {"entities": [(8, 11, "ITEM-QUANTITY")]}),
    ("The machine can produce up to 100 units per hour.", {"entities": [(30, 33, "ITEM-QUANTITY")]}),
    ("The order includes 40 pieces of the custom hardware.", {"entities": [(19, 21, "ITEM-QUANTITY")]}),

    # ----------------------------- PRICE -----------------------------
    ("The total cost is $200.50.", {"entities": [(19, 25, "PRICE")]}),
    ("Each ticket costs fifty dollars.", {"entities": [(18, 31, "PRICE")]}),
    ("The price range is $100 to $150 for early birds.", {"entities": [(20, 23, "PRICE"), (28, 31, "PRICE")]}),
    ("You owe £123.99 for the service.", {"entities": [(9, 15, "PRICE")]}),
    ("Can you believe the dress was only 99 euros?", {"entities": [(35, 37, "PRICE")]}),
    ("The laptop is on sale for $899.", {"entities": [(27, 30, "PRICE")]}),
    ("They're offering a special deal: buy one get one free for ¥5000.", {"entities": [(59, 63, "PRICE")]}),
    ("Our dinner cost over three hundred dollars last night.", {"entities": [(21, 34, "PRICE")]}),
    ("The repair costs could be between $250 and $300.", {"entities": [(35, 38, "PRICE"), (44, 47, "PRICE")]}),
    ("That vintage guitar is priced at around 1500 dollars.", {"entities": [(40, 44, "PRICE")]}),
    ("The membership fee is 200 dollars annually.", {"entities": [(22, 25, "PRICE")]}),
    ("A cup of coffee costs about 2.99.", {"entities": [(28, 32, "PRICE")]}),
    ("Selling my bike for £75, it's a steal!", {"entities": [(21, 23, "PRICE")]}),
    ("Upgrade now for just $49.99 a month.", {"entities": [(22, 27, "PRICE")]}),

    # ----------------------------- STATUS -----------------------------
    ("Your order is currently being delivered.", {"entities": [(30, 39, "STATUS")]}),
    ("The package was successfully delivered yesterday.", {"entities": [(29, 38, "STATUS")]}),
    ("This order is to be delivered by the end of the week.", {"entities": [(14, 29, "STATUS")]}),
    ("Your items are to be packaged within the next 24 hours.", {"entities": [(15, 29, "STATUS")]}),
    ("The shipment is to be shipped tomorrow morning.", {"entities": [(16, 29, "STATUS")]}),
    ("The project was completed ahead of schedule.", {"entities": [(16, 25, "STATUS")]}),
    ("Your application is still pending approval.", {"entities": [(26, 33, "STATUS")]}),
    ("The customer was refunded due to a pricing error.", {"entities": [(17, 25, "STATUS")]}),
    ("Give me the items of to be delivered.", {"entities": [(21, 36, "STATUS")]}),

    # ----------------------------- ADDRESS -----------------------------
    ("The package was sent to 123 Main St, Springfield, IL 62704.", {"entities": [(24, 58, "ADDRESS")]}),
    ("Our office located at 456 Park Ave, New York, NY 10022.", {"entities": [(22, 54, "ADDRESS")]}),
    ("Please send returns to P.O. Box 789, Boston, MA 02110.", {"entities": [(32, 53, "ADDRESS")]}),
    ("The event will be held at Liberty Square, Philadelphia, PA.", {"entities": [(26, 58, "ADDRESS")]}),
    ("You can visit us at 987 Elm Street, Denver, CO 80203.", {"entities": [(20, 52, "ADDRESS")]}),
    ("The new cafe is opening at 321 Birch Road, Austin, TX 78704.", {"entities": [(27, 59, "ADDRESS")]}),
    ("Mail your documents to 654 Pine Lane, Seattle, WA 98101.", {"entities": [(23, 55, "ADDRESS")]}),
    ("The conference takes place at 258 Willow Ave, Orlando, FL 32801.", {"entities": [(30, 63, "ADDRESS")]}),
    ("Drop off the package at 1600 Amphitheatre Parkway, Mountain View, CA 94043.", {"entities": [(24, 74, "ADDRESS")]}),
    ("Our new branch is located at 10 Downing Street, London, SW1A 2AA, UK.", {"entities": [(29, 68, "ADDRESS")]}),
    ("The workshop will be conducted at 1 Infinite Loop, Cupertino, CA 95014.", {"entities": [(34, 70, "ADDRESS")]}),
    ("Send all correspondence to Suite 600, 350 Fifth Avenue, New York, NY 10118.", {"entities": [(27, 74, "ADDRESS")]}),
    ("The wedding will take place at 12 Rue de Rivoli, 75004 Paris, France.", {"entities": [(31, 68, "ADDRESS")]}),
    ("Our factory is situated at 500 Tesla Court, Fremont, CA 94538.", {"entities": [(27, 61, "ADDRESS")]}),
    ("Please forward to Building 3A, Piccadilly Circus, London, W1J 9HP.", {"entities": [(18, 65, "ADDRESS")]}),
    ("The clinic is at 1234 Mercy Drive, Los Angeles, CA 90026.", {"entities": [(17, 56, "ADDRESS")]}),
    ("My house is located at B308, Jalan 10, Cinta Sayang Resort Homes, 08000 Sungai Petani, Kedah, Malaysia.", {"entities": [(23, 102, "ADDRESS")]}),

    # ----------------------------- ITEM-NAME -----------------------------
    ("Can you add the iPhone 12 and MacBook Pro to my cart?", {"entities": [(16, 25, "ITEM-NAME"), (30, 41, "ITEM-NAME")]}),
    ("I need to buy more Dove soap and Listerine mouthwash.", {"entities": [(19, 28, "ITEM-NAME"), (33, 52, "ITEM-NAME")]}),
    ("The Samsung Galaxy S21 offers great features.", {"entities": [(4, 22, "ITEM-NAME")]}),
    ("We ran out of Nespresso coffee capsules.", {"entities": [(14, 39, "ITEM-NAME")]}),
    ("Could you replace the HP Envy printer ink?", {"entities": [(22, 41, "ITEM-NAME")]}),
    ("She ordered a pair of Nike Air Max sneakers online.", {"entities": [(22, 43, "ITEM-NAME")]}),
    ("The new Lego Star Wars set is out of stock.", {"entities": [(8, 26, "ITEM-NAME")]}),
    ("He enjoys reading the Harry Potter series.", {"entities": [(22, 41, "ITEM-NAME")]}),
    ("The kitchen needs a new Vitamix blender.", {"entities": [(24, 39, "ITEM-NAME")]}),
    ("I love the scent of Yankee Candle vanilla cupcake.", {"entities": [(20, 49, "ITEM-NAME")]}),
    ("She uses the Canon EOS 5D camera for her photography.", {"entities": [(13, 32, "ITEM-NAME")]}),
    ("The Bose QuietComfort headphones have noise cancellation.", {"entities": [(4, 32, "ITEM-NAME")]}),
    ("I prefer using the Dyson V11 Torque Drive for cleaning.", {"entities": [(19, 41, "ITEM-NAME")]}),
    ("They serve Starbucks Pike Place Roast in the office.", {"entities": [(11, 37, "ITEM-NAME")]}),
    ("He bought the latest model of the Tesla Model 3.", {"entities": [(34, 47, "ITEM-NAME")]}),
    ("Add a KitchenAid stand mixer and a Keurig coffee maker to the shopping list.", {"entities": [(6, 28, "ITEM-NAME"), (35, 54, "ITEM-NAME")]}),
    ("The Philips Hue smart light bulbs change colors.", {"entities": [(4, 33, "ITEM-NAME")]}),
    ("She purchased a pair of Adidas Yeezy Boost 350.", {"entities": [(24, 46, "ITEM-NAME")]}),
    ("Check out the GoPro HERO9 for stunning action shots.", {"entities": [(14, 25, "ITEM-NAME")]}),
    ("He uses a Fender Stratocaster guitar for his performances.", {"entities": [(10, 36, "ITEM-NAME")]}),
    ("The Instant Pot Duo 7-in-1 is a versatile kitchen appliance.", {"entities": [(4, 26, "ITEM-NAME")]}),
    ("We stocked up on Clorox disinfecting wipes.", {"entities": [(17, 42, "ITEM-NAME")]}),
    ("She swears by the effectiveness of the Roomba 960 robot vacuum.", {"entities": [(39, 62, "ITEM-NAME")]}),
    ("Try the new flavor of Ben & Jerry's ice cream - Cherry Garcia.", {"entities": [(22, 61, "ITEM-NAME")]}),
    ("The Sony PlayStation 5 console is hard to find.", {"entities": [(4, 30, "ITEM-NAME")]}),
    ("I can't wait for the release of the Apple Watch Series 6.", {"entities": [(36, 56, "ITEM-NAME")]}),
    ("He ordered the Microsoft Surface Pro 7 for work.", {"entities": [(15, 38, "ITEM-NAME")]}),
    ("I bought a new pair of Ray-Ban Aviator sunglasses.", {"entities": [(23, 49, "ITEM-NAME")]}),
    ("The Gillette Fusion ProGlide razor gives a close shave.", {"entities": [(4, 34, "ITEM-NAME")]}),
    ("She loves painting with Winsor & Newton watercolors.", {"entities": [(24, 51, "ITEM-NAME")]}),
    ("How much bubble wrap do I have left.", {"entities": [(9, 20, "ITEM-NAME")]}),
    ("Is there any scissors left in the stock?", {"entities": [(13, 21, "ITEM-NAME")]}),
    ("How much cardboard boxes is there in system", {"entities": [(9, 24, "ITEM-NAME")]}),
    ("Do we have enough lights in the store?", {"entities": [(18, 24, "ITEM-NAME")]}),
    ("The shipment delivered us the luggage.", {"entities": [(30, 37, "ITEM-NAME")]}),
    ("The shipment delivered us the knives.", {"entities": [(30, 36, "ITEM-NAME")]}),
    ("We need to replace the old chairs in the conference room.", {"entities": [(27, 33, "ITEM-NAME")]}),
    ("Can you turn off the stove before leaving?", {"entities": [(21, 26, "ITEM-NAME")]}),
    ("She bought a beautiful vase for her living room.", {"entities": [(23, 27, "ITEM-NAME")]}),
    ("The new curtains will brighten up the kitchen.", {"entities": [(8, 16, "ITEM-NAME")]}),
    ("He fixed the leaky faucet in the bathroom.", {"entities": [(19, 25, "ITEM-NAME")]}),
    ("They installed a modern ceiling fan in the bedroom.", {"entities": [(24, 35, "ITEM-NAME")]}),
    ("I need a new laptop for my work.", {"entities": [(13, 19, "ITEM-NAME")]}),
    ("She uses a kettle to boil water every morning.", {"entities": [(11, 17, "ITEM-NAME")]}),
    ("Please bring the toolbox; we need to fix the door.", {"entities": [(17, 24, "ITEM-NAME")]}),
    ("The garden needs a new hose for watering the plants.", {"entities": [(23, 27, "ITEM-NAME")]}),
    ("I bought a lamp to read at night.", {"entities": [(11, 15, "ITEM-NAME")]}),
    ("They're looking for a durable rug for the entrance.", {"entities": [(30, 33, "ITEM-NAME")]}),
    ("Can we get some plates and cutlery for the picnic?", {"entities": [(16, 22, "ITEM-NAME"), (27, 34, "ITEM-NAME")]}),
    ("He wants a skateboard for his birthday.", {"entities": [(11, 21, "ITEM-NAME")]}),
    ("We need more shelves for storage in the garage.", {"entities": [(13, 20, "ITEM-NAME")]}),
    ("We need more shelves for storage in the garage.", {"entities": [(13, 20, "ITEM-NAME")]}),
    ("Smartphone.", {"entities": [(0, 10, "ITEM-NAME")]}),
    ("Tablet.", {"entities": [(0, 6, "ITEM-NAME")]}),
    ("Laptop.", {"entities": [(0, 6, "ITEM-NAME")]}),
    ("E-reader.", {"entities": [(0, 8, "ITEM-NAME")]}),
    ("Smartwatch.", {"entities": [(0, 10, "ITEM-NAME")]}),
    ("Drone.", {"entities": [(0, 5, "ITEM-NAME")]}),
    ("Give me the product chair.", {"entities": [(20, 25, "ITEM-NAME")]}),
    ("There's an item with id of IV6902 and the name of the product is table.", {"entities": [(27, 33, "customID"), (65, 70, "ITEM-NAME")]}),
    ("What's the quantity of the product with id of IV690893745 and the name remote control?", {"entities": [(46, 57, "customID"), (71, 85, "ITEM-NAME")]}),
    ("Is there a product name called monitor?", {"entities": [(31, 38, "ITEM-NAME")]}),
    ("Give me the product called socks.", {"entities": [(27, 32, "ITEM-NAME")]}),
    ("I want to obtain the information of the inventory item paper.", {"entities": [(55, 60, "ITEM-NAME")]}),
    ("Query about the inventory item plastics.", {"entities": [(31, 39, "ITEM-NAME")]}),
    ("The raw materials for production include steel and aluminum.", {"entities": [(41, 46, "ITEM-NAME"), (51, 59, "ITEM-NAME")]}),
    ("We need more electronic chips and wires for the new project.", {"entities": [(34, 39, "ITEM-NAME"), (13, 29, "ITEM-NAME")]}),
    ("Order more laptops and cameras for the electronics section.", {"entities": [(11, 18, "ITEM-NAME"), (23, 30, "ITEM-NAME")]}),
    ("The new shipment includes various skincare products.", {"entities": [(34, 42, "ITEM-NAME")]}),
    ("Restock the gloves, syringes, and bandages in the medical supply room.", {"entities": [(12, 18, "ITEM-NAME"), (20, 28, "ITEM-NAME"), (34, 42, "ITEM-NAME")]}),
    ("We're low on prescription drugs and over-the-counter medications.", {"entities": [(13, 31, "ITEM-NAME"), (36, 64, "ITEM-NAME")]}),
    ("The kitchen requires additional spices and meats for the new menu.", {"entities": [(32, 28, "ITEM-NAME"), (43, 48, "ITEM-NAME")]}),
    ("Ensure the bar is stocked with soft drinks and coffee.", {"entities": [(31, 42, "ITEM-NAME"), (47, 53, "ITEM-NAME")]}),
    ("Update the inventory with more hard drives and RAM modules.", {"entities": [(31, 42, "ITEM-NAME"), (47, 50, "ITEM-NAME")]}),
    ("The office needs new routers and servers for the network upgrade.", {"entities": [(21, 28, "ITEM-NAME"), (33, 40, "ITEM-NAME")]}),
    ("Order additional lumber and cement for the construction project.", {"entities": [(17, 23, "ITEM-NAME"), (28, 34, "ITEM-NAME")]}),
    ("The site requires more drills and excavators.", {"entities": [(23, 29, "ITEM-NAME"), (34, 44, "ITEM-NAME")]}),
    ("Pack the orders with bubble wrap and packing tape.", {"entities": [(21, 32, "ITEM-NAME"), (37, 49, "ITEM-NAME")]}),
    ("Include flyers and samples in the promotional packages.", {"entities": [(8, 14, "ITEM-NAME"), (19, 26, "ITEM-NAME")]}),
    ("I would like to obtain the inventory cup.", {"entities": [(37, 40, "ITEM-NAME")]}),
    ("I would like to obtain the inventory screwdriver with PR92834725123.", {"entities": [(37, 48, "ITEM-NAME"), (54, 67, "customID")]}),
]
# nlp.initialize()




# Function to check and print misaligned entities
def check_alignment(text, annotations):
    doc = nlp.make_doc(text)
    biluo_tags = offsets_to_biluo_tags(doc, annotations['entities'])
    if '-' in biluo_tags:
        print(f"Misaligned entities in: \"{text}\"")
        print("Misaligned entities' BILOU tags:", biluo_tags)

# Fine-tune the NER model
optimizer = nlp.resume_training()
for iteration in range(50):  # Adjust the number of iterations
    random.shuffle(train_data)
    losses = {}
    for text, annotations in train_data:
        # Check alignment for each training example
        check_alignment(text, annotations)
        
        doc = nlp.make_doc(text)
        example = Example.from_dict(doc, annotations)
        nlp.update([example], sgd=optimizer, losses=losses)
    # print(f"Iteration {iteration}, Losses: {losses}")


# Save the updated model
nlp.to_disk("updated_ner_model")

