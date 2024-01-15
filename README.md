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
Connect your device\
Flutter upgrade 有可能学校网或是vpn网来下载\
如果还是不能的话，就参考：
https://docs.flutter.dev/community/china
```
$ flutter upgrade
$ flutter pub get
$ flutter run
```
## Reference
1. 这是网上的例子，应该是运行不了，可以当作参考:\
https://github.com/hemanta212/Flutter-Inventory-App

2. 你们上次问的，这是我之前在油管学的基础flutter: \
https://www.youtube.com/watch?v=1ukSR1GRtMU&list=PL4cUxeGkcC9jLYyp2Aoh6hcWuxFDX6PBJ&ab_channel=NetNinja

3. 有一些widgets可以网上找open source的，例如\
https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/bar_chart.md#sample-2-source-code
\
拿了来改就不需要重新写一些比较复杂的编码

4. Quick hands on practice\
https://www.youtube.com/watch?v=D4nhaszNW4o&ab_channel=FlutterGuys

## Tasks (截至 - 开学那个星期，到时候出来约出来讨论)
程序在进入lib里
记得跟着folder的名字归类
有什么问题就直接问

### 1) Tianpu
- class diagram
- sql tables - look how to achieve every company have their own datasets, each employee has sales record (number of sales, revenue)
- learn how to link mongodb -> flask -> flutter
- CRUD (create, read, update, delete)

### 2) Leon
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

### 3) huining
SALES:
- target sales
- profits and losses - month, opening(costs), total purchases, total sales, closing (cost), profit or loss, expenses, net profit
- sales by date
- sales by item (selling products, products by revenue)
- sales by time (day, week, month, last 3 month, ?year?)
- sales by customer
- individual employee sales

### 4) Zeyu
ORDER:
- order dispatch and delivery (packed, shipped, delivered)
- customer claims and refunds - form, history
- filter system

### 5) Haozhe
PROCUREMENT:
- add weekly, montly purchases statistics
- filter system

INVENTORY:
- add inventory statistics
- filter system
- safety quantity (critical level)