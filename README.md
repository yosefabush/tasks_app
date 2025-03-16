# Tasks App

A modern tasks app built with Flutter for Android, iOS, and Web.

## Features

- Create, read, update, and delete tasks
- Mark tasks as completed
- Set due dates for tasks
- Categorize tasks
- Set priority levels
- Filter tasks by status (all, active, completed)
- Swipe to delete tasks
- Persistent storage using shared preferences

## Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Android Studio or Visual Studio Code
- For mobile: Android or iOS emulator/device
- For web: Chrome or any modern browser

### Installation

1. Clone this repository
   ```
   git clone https://github.com/yourusername/tasks_app.git
   ```

2. Navigate to the project directory
   ```
   cd tasks_app
   ```

3. Install dependencies
   ```
   flutter pub get
   ```

4. Run the app
   ```
   # For mobile
   flutter run
   
   # For web
   flutter run -d chrome
   
   # To build for web deployment
   flutter build web
   ```

5. Web optimization
   ```
   The pubspec.yaml file has been corrected. The error was caused by including a "web" section under the
   "flutter" section, which isn't a valid configuration.

   The web configuration isn't actually specified in the pubspec.yaml file. Instead, web settings are
   configured through command line arguments when building or running the app.

   For web optimization, you can use these commands:

   # Run with HTML renderer
   flutter run -d chrome --web-renderer html

   # Build with optimizations
   flutter build web --web-renderer html --release

   The web support is still fully functional in your app with the corrected pubspec.yaml file.
   ```
## Architecture

The app follows a simple layered architecture:

- **Models**: Defines the data structures
- **Services**: Handles business logic and data persistence
- **Screens**: UI components

## Dependencies

- [shared_preferences](https://pub.dev/packages/shared_preferences): For persistent storage
- [uuid](https://pub.dev/packages/uuid): For generating unique IDs

## License

This project is licensed under the MIT License - see the LICENSE file for details.