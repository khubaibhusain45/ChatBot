# 🤖 ChatBot App (Flutter + Gemini API)

A **fully functional AI ChatBot application** built with **Flutter**, powered by **Google Gemini API**, following **Bloc (Cubit) architecture** and backed by a **local SQLite database** for persistent chat storage.

This project demonstrates **real-world app architecture**, clean state management, API integration, and scalable UI patterns.

---

## 📱 App Overview

The ChatBot App allows users to:
- Chat with an AI model in real time
- View responses with proper Markdown formatting
- Store chat history locally
- Resume conversations even after restarting the app

This is not a demo-only project — it follows **production-grade practices**.

---

## 🧠 Core Technologies Used

- **Flutter (Material 3)**
- **Bloc / Cubit** – State Management
- **Google Gemini API**
- **HTTP Package** – API communication
- **SQLite (sqflite)** – Local database
- **GPT Markdown** – AI response formatting

---

---

## 🔄 State Management (Cubit)

The app uses **Cubit** to manage chatbot states:

### States:
- `SearchInitialState`
- `SearchLoadingState`
- `SearchLoadedState`
- `SearchErrorState`

### Responsibilities:
- Handle API calls
- Emit loading, success, and error states
- Maintain chat flow logic
- Sync UI with data updates

---

## 💬 Chat UI Features

### Chat Interface
- Bubble-style messages (User & AI)
- Auto-scroll to latest message
- Keyboard dismiss on outside tap
- Clean Material UI

### Message Rendering
- User messages → Plain text
- AI messages → Markdown-rendered text
- Supports:
  - Headings
  - Bullet points
  - Code blocks
  - Bold / italic formatting

---

## 🗃️ Local Database (SQLite)

Chat messages are stored locally using **sqflite**.

## 🌐 API Integration (Gemini)

### The app uses Google Gemini generateContent API.

- Request Flow
- User enters a message
- Message appended to chat history
- Full conversation sent to Gemini API
- AI response received
- Response saved locally
- UI updated instantly

## 🚀 Key Features Summary

- ✅ Real-time AI chat
- ✅ Persistent chat history
- ✅ Bloc/Cubit architecture
- ✅ SQLite local storage
- ✅ Markdown-formatted AI responses
- ✅ Clean and scalable UI
- ✅ Production-ready code structure

## 🛠️ How to Run the App

- Clone the repository
- Add your Gemini API key in SearchCubit
- Run:
```
flutter pub get
flutter run
```
---
## 👨‍💻 Author

- Khubaib Husain | Flutter Developer
