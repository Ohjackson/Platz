# Platz - German Language and Culture Learning App

![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![Platform](https://img.shields.io/badge/Platform-iOS%2017.0%2B-blue.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-green.svg)

**Platz** is a comprehensive iOS application designed to help Korean speakers learn German language and culture. The app combines structured language lessons, interactive dialogs, quizzes, and in-depth articles about Germany.

## Version 1.1 Updates
- Added expanded A2 lessons, dialogs, and quizzes with A1/A2 level selection.
- Updated app metadata and documentation for the 1.1 release.

---

## 📱 Features

### 1. **Learn Section** - German Language Learning
The core language learning module with multiple tracks:

#### Learning Tracks
- **Alphabet Track** (`alphabet`) - German alphabet and special characters (Ä, Ö, Ü, ß)
- **Numbers Track** (`numbers`) - Numbers from 1 to 1000+, including unique German number rules
- **Grammar Track** (`grammar`) - Essential German grammar (articles, verb conjugations)
- **Conversation Track** (`conversation`) - Common phrases and everyday conversations
- **A1/A2 Level Selection** - Filters lessons and dialogs by the selected CEFR level

#### Interactive Features
- **Lesson Detail View** - Markdown-based lesson content with examples, tips, and pronunciation guides
- **Dialog Practice** (`DialogView`) - Real-world conversation scenarios with speaker-by-speaker breakdowns
- **Mini Quizzes** (`QuizView`) - Multiple-choice quizzes linked to each lesson
- **Progress Tracking** - Automatic completion tracking and statistics
- **Speech Synthesis** - Text-to-speech for German pronunciation practice

#### Data Sources
- `lessons.json` - 30 structured lessons across A1/A2
- `dialogs.json` - 17 conversational scenarios across A1/A2
- `quizzes.json` - 33 quizzes with explanations
- `quotes.json` - Inspirational German quotes with translations and explanations

---

### 2. **Germany Section** - Cultural Knowledge
Comprehensive articles about German culture, politics, administration, and life:

#### Article Categories
- **General** (`general`) - Geography, education system, climate
- **Politics** (`politics`) - Political structure, parties, election system  
- **Administration** (`admin`) - Registration (Anmeldung), health insurance, bank accounts
- **Culture** (`culture`) - Food, Christmas traditions, soccer culture

#### Features
- **Article Detail View** with markdown support
- **Quick Facts** boxes for essential information
- **Related Articles** recommendations
- **Category-based browsing** and **popular articles** section
- **Search functionality** (planned)

#### Data Source
- `articles.json` - 12 in-depth articles covering various aspects of German life

---

### 3. **Home Section** - Dashboard
- **Daily Quote** - Random motivational quote in German with translation
- **Continue Learning** - Resume last lesson
- **Progress Overview** - Completed lessons, study streak, total minutes
- **Quick Access** - Direct links to tracks and featured content

---

### 4. **Settings Section**
- User profile customization
- Learning preferences
- Data management
- About information

---

## 🏗️ Architecture

### Tech Stack
- **Framework**: SwiftUI
- **Minimum iOS Version**: 17.0
- **Language**: Swift 5.9
- **Data Storage**: JSON files + UserDefaults for progress
- **Speech**: AVFoundation (AVSpeechSynthesizer)

### Project Structure

```
Platz/
├── Models/
│   ├── Article.swift      # Germany section articles
│   ├── Lesson.swift       # Language lessons
│   ├── Dialog.swift       # Conversation practices
│   ├── Quiz.swift         # Quiz questions and answers
│   ├── Quote.swift        # Daily motivational quotes
│   └── Progress.swift     # User progress tracking
│
├── Data/
│   ├── articles.json      # 12 articles about Germany
│   ├── lessons.json       # 30 language lessons
│   ├── dialogs.json       # 17 conversation scenarios
│   ├── quizzes.json       # 33 quiz sets
│   └── quotes.json        # 10 German quotes
│
├── Utilities/
│   ├── DataManager.swift  # JSON data loading and caching
│   └── SpeechManager.swift # Text-to-speech functionality
│
├── Components/
│   ├── PlatzCard.swift     # Reusable card component
│   ├── QuickFactsBox.swift # Info box for article facts
│   └── Theme.swift         # App-wide theming
│
├── Views/
│   ├── Main/
│   │   ├── MainTabView.swift  # Tab bar container
│   │   └── HomeView.swift     # Dashboard/home screen
│   │
│   ├── Learn/
│   │   ├── LearnView.swift         # Track selection
│   │   ├── TrackDetailView.swift   # Lesson list per track
│   │   ├── LessonDetailView.swift  # Lesson content
│   │   ├── DialogView.swift        # Dialog practice
│   │   └── QuizView.swift          # Quiz interface
│   │
│   ├── Germany/
│   │   ├── GermanyView.swift       # Article categories
│   │   └── ArticleDetailView.swift # Article reader
│   │
│   ├── Settings/
│   │   └── SettingsView.swift      # App settings
│   │
│   └── Onboarding/
│       └── OnboardingView.swift    # First-launch tutorial
│
└── Assets.xcassets/
    ├── AppIcon.appiconset/
    └── bedge.imageset/
```

---

## 📊 Data Structure Details

### Lessons (`lessons.json`)
Each lesson contains:
- `id`, `track`, `title`, `level`, `durationMin`, `order`
- `contentMarkdown` - Main lesson content in Markdown
- `examples[]` - Code examples with German, Korean, pronunciation, notes
- `tips[]` - Learning tips
- `miniQuizId` - Linked quiz reference

**Used in**: `LearnView`, `TrackDetailView`, `LessonDetailView`

---

### Dialogs (`dialogs.json`)
Conversation scenarios with:
- `topic`, `title`, `description`, `level`, `order`
- `lines[]` - Array of conversation turns with speaker, German text, Korean translation, notes
- `keywords[]` - Key vocabulary with meanings
- `quizId` - Optional linked quiz

**Used in**: `DialogView`, `LearnView`

---

### Quizzes (`quizzes.json`)
Quiz data structure:
- `type` - "lesson" or "dialog"
- `sourceLessonId` / `sourceDialogId` - Parent content reference
- `passingScore` - Required score (typically 60%)
- `questions[]` - Multiple choice questions with:
  - `question`, `options[]`, `correctAnswer`, `explanation`

**Used in**: `QuizView`, `LessonDetailView`, `DialogView`

---

### Articles (`articles.json`)
Comprehensive articles with:
- `category` - general, politics, admin, culture
- `title`, `summary`, `readTime`
- `sections[]` - Array with `heading` and `bodyMarkdown`
- `quickFacts[]` - Key-value pairs for quick reference
- `relatedIds[]` - Related article IDs
- `tags[]` - Categorization tags

**Used in**: `GermanyView`, `ArticleDetailView`

---

### Quotes (`quotes.json`)
Motivational quotes:
- `de` - German text
- `ko` - Korean translation
- `author` - Attribution (optional)
- `explain` - Detailed explanation
- `level` - beginner/intermediate
- `tags[]` - Thematic tags

**Used in**: `HomeView` (random daily quote)

---

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0+
- macOS 14.0+ (Sonoma)
- iOS 17.0+ device or simulator

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd Platz
```

2. Open the project:
```bash
open Platz.xcodeproj
```

3. Build and run:
- Select your target device/simulator
- Press `Cmd + R` to build and run

### Project Configuration
- **Bundle Identifier**: Set in project settings
- **Deployment Target**: iOS 17.0
- **Supported Devices**: iPhone (portrait orientation)

---

## 💾 Data Management

### DataManager
The `DataManager` singleton handles:
- JSON file loading and parsing
- Data caching for performance
- Error handling with graceful fallbacks

### Progress Tracking
User progress is stored using:
- **UserDefaults** for lesson completion status
- **@AppStorage** for reactive UI updates
- Progress model tracks: completed lessons, streaks, study time

### Speech Synthesis
`SpeechManager` provides:
- German language TTS via AVSpeechSynthesizer
- Voice configuration (de-DE locale)
- Playback control (play, pause, stop)

---
