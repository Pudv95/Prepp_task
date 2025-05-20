# Prepp - Cricket Video Platform

A modern Flutter application for cricket video content with advanced video playback features and a beautiful user interface.

## Features

### Video Player
- **Advanced Video Controls**
  - Mute/Unmute functionality
  - Playback speed control (0.5x, 1x, 2x)
  - Video looping
  - Gesture-based controls
  - Progress bar with seek functionality

- **Video Caching**
  - Efficient video caching system using Hive
  - Automatic cache management
  - Optimized video loading
  - Memory-efficient controller management

- **State Management**
  - BLoC pattern implementation
  - Efficient state handling for video controls
  - Asynchronous operations management
  - Proper resource cleanup

### User Interface
- **Video Grid Screen**
  - Grid layout for video thumbnails
  - Responsive design
  - Smooth navigation
  - Loading states and error handling

- **Video Player Screen**
  - Full-screen video playback
  - Vertical swipe navigation between videos
  - Custom video controls overlay
  - Mute and speed indicators
  - Beautiful UI with dark theme

- **Theme Support**
  - Dark theme by default
  - Theme switching capability
  - Persistent theme preferences

### Architecture
- **Clean Architecture**
  - Separation of concerns
  - Dependency injection using GetIt
  - Repository pattern
  - Data sources abstraction

- **State Management**
  - BLoC pattern for state management
  - Event-driven architecture
  - Efficient state updates
  - Proper error handling

### Technical Features
- **Dependency Injection**
  - GetIt for service locator
  - Injectable for code generation
  - Clean dependency management

- **Network Layer**
  - Dio for HTTP requests
  - Efficient API communication
  - Error handling
  - Response caching

- **Data Persistence**
  - Hive for local storage
  - Video caching
  - Theme preferences storage

## Getting Started

### Prerequisites
- Flutter SDK
- Dart SDK
- Android Studio / VS Code
- Git

### Installation
1. Clone the repository
```bash
git clone https://github.com/pudv95/prepp.git
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

## Project Structure
```
lib/
├── core/
│   ├── di/
│   ├── router/
│   └── theme/
├── features/
│   ├── home_screen/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── video_player/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── main.dart
```

## Dependencies
- **State Management**
  - flutter_bloc
  - bloc

- **Video Player**
  - video_player
  - path_provider
  - crypto

- **Storage**
  - hive
  - hive_flutter

- **Network**
  - dio
  - http

- **Dependency Injection**
  - get_it
  - injectable

