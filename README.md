# Flutter AI Chat Demo 🤖

A simple AI Chat demo app built with Flutter, BLoC, Dio, Firebase, and Groq API.

This project is created as a small **Flutter community/GitHub demo** to demonstrate AI API integration, state management, asynchronous API handling, and chat UI.

## ✨ Features

* 💬 AI Chat
* 🤖 Groq AI API integration
* ⚡ BLoC state management
* 🌐 Dio API integration
* 🔥 Firebase integration
* 🧹 Clear chat
* 📋 Copy AI response
* 🌙 Dark/Light theme
* 📡 Streaming AI response

## 🛠 Tech Stack

* Flutter
* Dart
* BLoC
* Dio
* Firebase
* Groq API

## 📱 Platform

* Android
* iOS

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/ykflutter/flutter-ai-chat-demo.git
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure API Key

Create your Groq API key and configure it locally.

**Do not commit your API key to GitHub.**

### 4. Run the app

```bash
flutter run
```

## 📂 Project Structure

```text
lib/
├── bloc/
│   ├── chat_bloc.dart
│   ├── chat_event.dart
│   └── chat_state.dart
│
├── core/
│
├── data/
│   └── ai_service.dart
│
├── screens/
│   └── chat_screen.dart
│
└── main.dart
```

## 🎯 Purpose

This project is intentionally kept simple so Flutter developers can understand the basic flow:

```text
User
  ↓
Chat UI
  ↓
BLoC
  ↓
AI Service
  ↓
Groq API
  ↓
AI Response
  ↓
Chat UI
```

## 🤝 Contributions

Suggestions, improvements, and pull requests are welcome.

## 📄 License

This project is open source and available for learning and community use.
