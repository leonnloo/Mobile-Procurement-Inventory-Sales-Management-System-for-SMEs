# Mobile-Procurement-Inventory-Sales-Management-System-for-SMEs

## GRP TEAM-14

### Team Members:
Leon Loo Yang\
Zeyu Sun\
Huining Wang\
Haozhe Zhang\
Tianpu Le

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

