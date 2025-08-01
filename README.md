# AdHocLifeLessons

A beautiful, minimalist iOS and macOS app that displays daily life lessons and inspirational quotes. The app fetches wisdom from a remote API and gracefully handles offline scenarios with local storage.

## Features

- 📱 **Cross-Platform**: Runs on iOS, iPadOS, macOS, and tvOS
- 🔄 **Auto-Refresh**: Automatically fetches fresh lessons on app launch
- 💾 **Offline Support**: Stores lessons locally using SwiftData
- 🎨 **Beautiful Typography**: Large, centered text with Georgia serif font for optimal readability
- 📱 **Responsive Design**: Works in any orientation and screen size
- ⏰ **Smart Footer**: Shows last update time and manual refresh option

## How It Works

The app displays life lessons retrieved from `https://rohand.app/lifelesson/quote.json`. When the API is unreachable, it falls back to the last stored lesson or shows the default message "Love Each Other".

### API Response Format
```json
{
  "ts": "20250731",
  "v": 1,
  "s": "Life is Happy"
}
```

- `ts`: Timestamp when the lesson was last updated
- `v`: Version number of the lesson
- `s`: The actual lesson text to display

## Architecture

The app is built using SwiftUI and SwiftData with a clean MVVM architecture:

- **ContentView**: Main UI displaying the lesson and footer
- **LifeLessonService**: Handles API calls and data management
- **LifeLesson**: SwiftData model for local storage

## Message Loading Flow

### App Launch Flow
```mermaid
sequenceDiagram
    participant U as User
    participant CV as ContentView
    participant LS as LifeLessonService
    participant SD as SwiftData
    participant API as API Endpoint

    U->>CV: Launch App
    CV->>LS: setModelContext()
    CV->>LS: loadStoredLesson()
    LS->>SD: Fetch latest lesson
    SD-->>LS: Return stored lesson (or none)
    LS->>CV: Display stored/default lesson
    
    CV->>LS: fetchLesson() (background)
    LS->>API: GET /lifelesson/quote.json
    
    alt API Success
        API-->>LS: JSON response
        LS->>SD: Save new lesson
        LS->>CV: Update UI with new lesson
    else API Failure
        API-->>LS: Network error
        LS->>CV: Keep current lesson displayed
    end
```

### Manual Refresh Flow
```mermaid
sequenceDiagram
    participant U as User
    participant CV as ContentView
    participant LS as LifeLessonService
    participant SD as SwiftData
    participant API as API Endpoint

    U->>CV: Tap Refresh Button
    CV->>LS: fetchLesson()
    LS->>CV: Show loading indicator
    LS->>API: GET /lifelesson/quote.json
    
    alt API Success
        API-->>LS: JSON response
        LS->>SD: Save new lesson
        LS->>CV: Update lesson text
        LS->>CV: Update timestamp
        LS->>CV: Hide loading indicator
    else API Failure
        API-->>LS: Network error
        LS->>CV: Keep current lesson
        LS->>CV: Hide loading indicator
    end
```

### Data Storage Strategy
```mermaid
flowchart TD
    A[App Launch] --> B{Has Stored Lesson?}
    B -->|Yes| C[Display Latest Stored Lesson]
    B -->|No| D[Display Default message: Love Each Other]
    
    C --> E[Attempt API Fetch]
    D --> E
    
    E --> F{API Available?}
    F -->|Yes| G[Fetch New Lesson]
    F -->|No| H[Keep Current Display]
    
    G --> I[Save to SwiftData]
    I --> J[Update UI]
    
    H --> K[App Ready]
    J --> K
```

## Installation

1. Clone this repository
2. Open `AdHocLifeLessons.xcodeproj` in Xcode
3. Build and run on your preferred device/simulator

## Requirements

- iOS 17.0+ / macOS 14.0+ / tvOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Technical Details

- **UI Framework**: SwiftUI
- **Data Persistence**: SwiftData
- **Networking**: URLSession with async/await
- **Architecture**: MVVM with Observable pattern
- **Error Handling**: Graceful degradation with offline support
