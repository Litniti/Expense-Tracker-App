# Expense Tracker

A portfolio-quality personal finance app built with SwiftUI, SwiftData, MVVM, Charts, and protocol-driven dependency injection. The project is designed to feel like a polished fintech product while also showing production-minded architecture, reusable UI, testability, and clean separation of concerns.

## Features

- Dashboard with current month spending, total spending, budget progress, and recent expenses
- Expense management with add, edit, delete, validation, and persisted SwiftData storage
- Analytics powered by Apple Charts for monthly spending, category breakdown, and trend visualization
- Search and filtering by title, notes, category, and date range
- Settings for dark mode, currency selection, and full data reset
- Reusable design system components including summary cards, expense cards, chips, buttons, and empty states
- Accessibility support with labels, readable typography, and VoiceOver-friendly combined elements

## Architecture

- `SwiftUI` for the UI layer
- `MVVM` with dedicated ViewModels for dashboard, expenses, analytics, and settings
- `SwiftData` for persistence
- `NavigationStack` inside a tab-based shell
- `Charts` for analytics visualizations
- `Dependency Injection` through `AppContainer`
- `Protocol-Oriented Programming` through `ExpenseServicing` and `SettingsServicing`

Project structure:

```text
ExpenseTracker
├── App
├── Models
├── Views
├── ViewModels
├── Services
├── Components
├── Theme
├── Resources
└── Utils
```

## Screenshots

Add screenshots here once you run the app in Xcode:

- Dashboard
- Expenses
- Analytics
- Settings

## Setup

1. Open `ExpenseTracker/ExpenseTracker.xcodeproj` in Xcode.
2. Select an iOS 17+ simulator or device with SwiftData and Charts support.
3. Build and run the `ExpenseTracker` scheme.

## Testing

The project includes unit tests for:

- Dashboard summary calculations
- Expense form validation
- Expense filtering behavior

Run tests from Xcode with `Product > Test`.
