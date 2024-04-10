# Mobile-Procurement-Inventory-Sales-Management-System-for-SMEs

## GRP TEAM-14

### Team Members:
Leon Loo Yang\
Zeyu Sun\
Huining Wang\
Haozhe Zhang\
Tianpu Le

# Installation Guide:
## Frontend:
### 1. Get Flutter
* Install flutter : [Flutter Installation](https://flutter.dev/docs/get-started/install)
* If there's any problem persists,  consider checking out:
https://docs.flutter.dev/community/china

### 2. Run on either Android Studios or Visual Studio Code (VSC)
* Install Android Studio : [Android Studio Installation](https://developer.android.com/studio)
* Using Android Studio's device manager on the top or at the right bar to create a virtual device


If you wish to proceed the project with VSC, you would need to install android emulator extensions on VSC to run the virtual devices. If you have Code Runner Extensions installed, it is recommended to disable it before compiling the flutter code.

### 3. Clone this repo
```
$ git clone https://github.com/leonnloo/Mobile-Procurement-Inventory-Sales-Management-System-for-SMEs.git
$ cd Mobile-Procurement-Inventory-Sales-Management-System-for-SMEs
$ cd Prototype
```

### 4. Run
Connect your device using emulator on Android Studio or VSC (install android emulator extension)
```
$ flutter upgrade
$ flutter pub get
$ flutter run
```
If `flutter pub get` cannot be executed due to network restrictions, consider changing source of download to the mirror ones in China：
```
setx PUB_HOSTED_URL "https://pub.flutter-io.cn"
setx FLUTTER_STORAGE_BASE_URL "https://storage.flutter-io.cn"
```
After executing, restart the IDE and run `flutter pub get` once more.

## Backend Setup:
### Backend is hosted on the cloud, but here's how to run the backend on local:

Change directory into Backend and select python 3.12.2 as the interpreter after cloning the repository.\
Create a virtual environment:
```
py -3 -m venv venv
```
After creating the virtual environment, change the interpreter to use the `python` on `venv/Scripts/python`.\
Activate the virtual machine by executing:
```
venv/Scripts/activate
```
Install the libraries using:
```
python install -r requirements.txt
```
Execute the following command after cd into `app`:
```
python -m spacy download en_core_web_lg
python routes/chatbot/spacy_train.py
```
Run and the API would be hosted on local:
```
uvicorn main:app --reload
```

