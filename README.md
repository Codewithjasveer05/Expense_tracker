# Expense Tracker 

A simple expense tracker built with Flutter.

## Features
- Add, edit and delete expenses (swipe left to delete, with Undo)
- Browse month by month with a monthly total
- Set a monthly budget with a progress bar
- Statistics: 6-month chart and category breakdown
- Data is saved on the device (shared_preferences)

## Tech
- Flutter and Dart
- provider (state management)
- intl (money and date formatting)
- shared_preferences (local storage)

## Run locally
```
flutter pub get
flutter run -d chrome
```

## Build for web
```
flutter build web --release
```