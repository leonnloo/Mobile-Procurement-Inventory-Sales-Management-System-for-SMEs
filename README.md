# 📱 Business Management Solution for SMEs

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Mobile-blue" alt="Platform">
  <img src="https://img.shields.io/badge/Framework-Flutter-blue" alt="Framework">
  <img src="https://img.shields.io/badge/Backend-FastAPI-green" alt="Backend">
  <img src="https://img.shields.io/badge/Database-MongoDB-green" alt="Database">
</p>

## 🚀 Product Overview

This lightweight mobile application is designed to help small and medium enterprises (SMEs) streamline their business operations. It offers an integrated solution for procurement, inventory, and sales management in a single platform accessible anytime, anywhere.

### 🎯 Problem

SMEs struggle with slow, manual procurement, inventory, and sales management processes. Existing ERPs are often too expensive or complex for their needs.

### 💡 Solution

Our application provides an affordable, user-friendly mobile platform that simplifies business operations, reduces paperwork, and improves efficiency.

### ✨ Key Features

- 🤝 **Supplier & Customer Management**  
  Maintain comprehensive databases of suppliers and customers with all relevant information.

- 📝 **Procurement Tracking**  
  Manage purchase orders, track deliveries, and handle supplier contracts efficiently.

- 📦 **Inventory Management**  
  Real-time inventory updates, low stock alerts, and demand forecasting to optimize inventory levels.

- 🏷️ **Product Catalog**  
  Easy product management with pricing, categories, and specifications.

- 📊 **Sales Monitoring**  
  Track sales targets, employee performance, and view monthly breakdowns.

- 📑 **Sales Order Automation**  
  Generate quotes, contracts, and templates with a few taps.

- 👥 **Role-based Access Control**  
  Secure user accounts with customized permissions based on roles.

- 🤖 **Integrated Chatbot**  
  Quick help and guidance through an AI-powered assistant.

- 🔔 **Notifications & Analytics**  
  Real-time alerts and comprehensive dashboards for business insights.

## 🔧 Technology Stack

- **Frontend**: Flutter (cross-platform mobile app)
- **Backend**: FastAPI (Python lightweight REST API)
- **Database**: MongoDB Atlas (cloud NoSQL)
- **Authentication**: JWT-based
- **Mail Service**: Mailersend (for password resets)
- **Chatbot**: PyTorch-powered lightweight NLP model

## 📋 Development Setup

### Frontend Setup:

#### 1. Flutter Installation

- Install Flutter: [Flutter Installation](https://flutter.dev/docs/get-started/install)
- For regions with access restrictions: [Flutter in China](https://docs.flutter.dev/community/china)

#### 2. IDE Setup

- Option 1: [Android Studio](https://developer.android.com/studio) with Flutter plugin
- Option 2: Visual Studio Code with Flutter and Android Emulator extensions

#### 3. Getting the Source Code

```
$ git clone https://github.com/leonnloo/Mobile-Procurement-Inventory-Sales-Management-System-for-SMEs.git
$ cd Mobile-Procurement-Inventory-Sales-Management-System-for-SMEs
$ cd Prototype
```

#### 4. Running the Application

Connect a physical device or set up an emulator, then run:

```
$ flutter upgrade
$ flutter pub get
$ flutter run
```

Network access workaround if needed:

```
setx PUB_HOSTED_URL "https://pub.flutter-io.cn"
setx FLUTTER_STORAGE_BASE_URL "https://storage.flutter-io.cn"
```

### Backend Setup:

The backend is hosted in the cloud for production use. For local development:

1. **Environment Setup**:

   - Use Python 3.12.2 as interpreter
   - Create and activate a virtual environment:

   ```
   py -3 -m venv venv
   venv/Scripts/activate
   ```

2. **Install Dependencies**:

   ```
   python install -r requirements.txt
   ```

3. **NLP Model Setup**:

   ```
   python -m spacy download en_core_web_lg
   python routes/chatbot/spacy_train.py
   ```

4. **Start the Server**:
   ```
   uvicorn main:app --reload
   ```

The API server will be available on your local machine for development purposes.
