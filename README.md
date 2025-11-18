# Favorite Music App

A Flutter application for managing a personal music library. Users can view their music collection, add new songs, and delete existing ones.

## Project Overview

This app displays a list of music tracks with their details (title, artist, album, and year). Users can interact with the library through an intuitive interface that supports adding and removing songs.

### Features
- **View Music Library**: Browse all songs in a scrollable list
- **Add New Music**: Add songs with title, artist, album, and year information
- **Delete Music**: Remove songs from the library
- **Track Count**: Display the total number of songs in the library
- **Input Validation**: Ensures all fields are filled when adding new music

## Changes from Previous Version

The previous version of this app had all code in a single `main.dart` file and only displayed a hard-coded list of music tracks with no interactive features.

### What's New:
1. **Modular Architecture**: Code is now organized into separate files and folders for better maintainability
2. **Stateful Management**: Converted from StatelessWidget to StatefulWidget to manage dynamic data
3. **Add Functionality**: Users can now add new songs through a dialog interface
4. **Delete Functionality**: Songs can be removed from the library with a delete button
5. **Input Validation**: Form validation ensures complete song information before adding
6. **Comprehensive Comments**: All files include detailed comments explaining functionality
7. **Reusable Components**: Dialog widget separated for potential reuse

## Project Structure

```
lib/
├── main.dart                       # App entry point and MaterialApp configuration
├── models/
│   └── music.dart                  # Music data model class
├── screens/
│   └── music_library_home.dart     # Main screen with music list and state management
└── widgets/
    └── add_music_dialog.dart       # Reusable dialog for adding new music

test/
└── widget_test.dart                # Default Flutter widget tests

android/                            # Android-specific configuration
ios/                                # iOS-specific configuration
linux/                              # Linux-specific configuration
macos/                              # macOS-specific configuration
windows/                            # Windows-specific configuration
web/                                # Web-specific configuration

pubspec.yaml                        # Project dependencies and metadata
analysis_options.yaml               # Dart/Flutter linting rules
.gitignore                          # Git ignore rules for Flutter projects
```

### File Descriptions

#### `lib/main.dart`
- Application entry point
- Configures MaterialApp theme and navigation
- Sets up the app title and initial route

#### `lib/models/music.dart`
- Defines the `Music` class
- Contains properties: title, artist, album, year
- Used as the data model throughout the app

#### `lib/screens/music_library_home.dart`
- Main screen component (StatefulWidget)
- Manages the music library list state
- Handles add and delete operations
- Displays total song count and scrollable list
- Implements the floating action button for adding music

#### `lib/widgets/add_music_dialog.dart`
- Reusable dialog component (StatelessWidget)
- Provides input fields for song information
- Validates user input before submission
- Uses callback pattern to return data to parent
- Automatically closes after successful submission

## Getting Started

### Prerequisites
- Flutter SDK installed
- An IDE (VS Code, Android Studio, or IntelliJ)
- An emulator or physical device for testing

### Running the App

1. Clone the repository:
```bash
git clone https://github.com/delanobmarques/favorite-music-app.git
```

2. Navigate to the project directory:
```bash
cd favorite_music_app
```

3. Get dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## Learning Resources

If this is your first Flutter project, check out these resources:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Flutter Documentation](https://docs.flutter.dev/)
