# Mobile-Procurement-Inventory-Sales-Management-System-for-SMEs

## GRP TEAM-14 (最后一次更新 - 24/2/2024)

### Team Members:
Leon Loo Yang\
Zeyu Sun\
Huining Wang\
Haozhe Zhang\
Tianpu Le

## ！！！重要 ！！！
开branch时，跟着这个方式取名，例如：
```
functionality-login (基本操作编码)
functionality-register
functionality-sales_management
functionality-procurement
enhancement-procurement (如果有更新或是换UI设计)
enhancement-sale_orders
database-linking_flask_mongodb (backend)
database-linking_flask_flutter
bugfix-... (修改bug)
```
前面是统一标题，后面自己设置，如果觉得有什么新的名字可以当作标题就在群里提出来\
\
还有就是commit的meesage, 都写成past tense, 例如：Added, Developed, Modified, Changed, Updated\
\
**你们能开issues就开，记得放milestones, labels, assignees等等**


## Getting Started:
#### 1. Get Flutter
* Install flutter : [Flutter Installation](https://flutter.dev/docs/get-started/install)
* 可以参考：
https://docs.flutter.dev/community/china

### 2. Run on either Android Studios or VSC
* Install Android Studio : [Android Studio Installation](https://developer.android.com/studio)
* Using Android Studio's device manager on the top or at the right bar to create a virtual device
1. Select Pixel 7 (要选别的device也可以，这样可以确保我们的app能在所有的框架里运行，但pixel 7是我们统一的developing框架)
2. Select Pie on system image
3. Finish
(You would require at least 8gb to start download and use the virtual device, the space required would increase as you develop on)

If you wish to proceed the project with VSC, you would need to install android emulator extensions on VSC to run the virtual devices. If you have Code Runner Extensions installed, it is recommended to disable it before compiling the flutter code.

#### 3. Clone this repo
```
$ git clone https://github.com/leonnloo/Mobile-Procurement-Inventory-Sales-Management-System-for-SMEs.git
$ cd Mobile-Procurement-Inventory-Sales-Management-System-for-SMEs
$ cd Prototype
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
如果 `flutter pub get` 不能运行（学校网可以运行），打开powershell输入：
```
setx PUB_HOSTED_URL "https://pub.flutter-io.cn"
setx FLUTTER_STORAGE_BASE_URL "https://storage.flutter-io.cn"
```
然后重启个人使用的IDE，打开再 `flutter pub get` 应该就行了
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

5. State Management - Get\
我已经加入get的dependency了，直接用就行
https://pub.dev/packages/get

6. Highly recommended to check out material 3 to plan out your design\
https://m3.material.io/

7. Useful Resources
- https://docs.flutter.dev/ui/widgets

- https://www.youtube.com/watch?v=Kq5ZsygfWAc&t=9s&ab_channel=FlutterMapp\

- https://www.youtube.com/watch?v=M9J-JJOuyE0&ab_channel=FlutterMapp
\
\
This repo is a guide to flutter widgets with sample codes and pictures 
- https://github.com/material-components/material-components-flutter

## Tasks
程序在进入lib里
记得跟着folder的名字归类
有什么问题就直接问

### 1) Tianpu
PRODUCTS:
- filter system
- safety quantity (critical level)
- markup (based on cost price, determine selling price to raise margin), margin (based on selling price, determine profit)

SUPPLIER & CUSTOMER:
filter system
obtain numbers from contacts (import from contacts)

### 2) Leon
BACKEND:
- sql tables - look how to achieve every company have their own datasets, each employee has sales record (number of sales, revenue)
- learn how to link mongodb -> flask -> flutter
- CRUD (create, read, update, delete)

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
- Design themes for the app\
\
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
