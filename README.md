# Mobile-Procurement-Inventory-Sales-Management-System-for-SMEs

## GRP TEAM-14

### Team Members:
Leon Loo Yang\
Zeyu Sun\
Huining Wang\
Haozhe Wang\
Tianpu Le

## Getting Started:
#### 1. Get Flutter
* Install flutter : [Flutter Installation](https://flutter.dev/docs/get-started/install)

### 2. Run on either Android Studios or VSC
* Install Android Studio : [Android Studio Installation](https://developer.android.com/studio)
* Using Android Studio's device manager on the top or at the right bar to create a virtual device
1. Select Pixel 7
2. Select Pie on system image
3. Finish
(You would require at least 8gb to start download and use the virtual device, the space required would increase as you develop on)\

If you wish to proceed the project with VSC, you would need to install android emulator extensions on VSC to run the virtual devices. If you have Code Runner Extensions installed, it is recommended to disable it before compiling the flutter code.

#### 3. Clone this repo
```
$ git clone https://github.com/leonnloo/Mobile-Procurement-Inventory-Sales-Management-System-for-SMEs.git
$ cd Mobile-Procurement-Inventory-Sales-Management-System-for-SMEs
```

#### 4. Run
Connect your device 

```
$ flutter upgrade
$ flutter pub get
$ flutter run
```

## Tasks
1) tianpu
- class diagram
- sql tables - look how to achieve every company have their own datasets, each employee has sales record (number of sales, revenue)
- learn how to link mongodb -> flask -> flutter
- CRUD (create, read, update, delete)

2) leon
LOGIN:
- authentication 
- register (only new company can register, employees have to be added by admin or people in authority to the database in settings)
- when user first time login, prompt for new password, other necessary information (added by admin)
- login
- verification for registering
- forgot password?
 
HOME:
- adjustable widgets?
- add icon on the bottom right (add orders, purchase, customer, supplier, product, inventory)
- 
3) huining
SALES:
- target sales
- profits and losses - month, opening(costs), total purchases, total sales, closing (cost), profit or loss, expenses, net profit
- sales by date
- sales by item (selling products, products by revenue)
- sales by time (day, week, month, last 3 month, ?year?)
- sales by customer
- individual employee sales

4) zeyu
ORDER:
- order dispatch and delivery (packed, shipped, delivered)
- customer claims and refunds - form, history
- filter system

5) haozhe
PROCUREMENT:
- add weekly, montly purchases statistics
- filter system

INVENTORY:
- add inventory statistics
- filter system
- safety quantity (critical level)