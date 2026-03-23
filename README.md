# 021Trade — Stock Watchlist (Flutter BLoC)

A production-focused Flutter application built as part of the 021Trade (Diamond Hands LLP) assignment.

The app demonstrates a clean implementation of a stock watchlist with drag-to-reorder functionality, powered by the BLoC architecture. The focus is on predictable state management, scalability, and maintainable code structure.

---

## Key Features

- Drag-to-reorder with proper index handling
- Clean BLoC-based state management (no business logic in UI)
- Shimmer loading state for better perceived performance
- Context-aware "Reset Order" interaction
- Gain/Loss indicators with clear visual hierarchy
- Human-readable volume formatting
- Fully immutable and type-safe models
- Dark-themed UI aligned with trading apps
- Graceful error handling with retry
- Unit-tested BLoC using `bloc_test`

---

## Architecture Overview

The application strictly follows unidirectional data flow:

**UI → Event → BLoC → State → UI**

- Widgets only dispatch events
- BLoC handles all transformations
- UI rebuilds purely from state

This ensures:
- Predictability
- Testability
- No side effects in the widget tree

---

## Project Structure

```
lib/
├── bloc/        # Events, states, business logic
├── models/      # Entities and repository contracts
├── screens/     # Screen-level UI
├── widgets/     # Reusable UI components
├── theme/       # App styling
└── utils/       # Formatting helpers

test/
└── watchlist_bloc_test.dart
```

Each layer has a clearly defined responsibility, keeping the codebase easy to navigate and extend.

---

## Core Implementation Details

### Reordering Logic

Flutter’s `ReorderableListView` returns an adjusted index when moving items downward. This is handled at the BLoC level:

```dart
final adjustedIndex = event.newIndex > event.oldIndex
    ? event.newIndex - 1
    : event.newIndex;
```

Keeping this logic inside BLoC prevents duplication and keeps UI simple.

---

### Reset State Handling

- Original list is cached on load
- After every reorder, current state is compared
- Reset option appears only when needed

This avoids unnecessary UI state management and keeps behavior intuitive.

---

## Data Layer

The repository is abstracted:

```dart
abstract class StockRepository {
  List<Stock> getWatchlistStocks();
}
```

This allows:
- Easy API integration later
- Clean testability with mock/fake repositories

The `Stock` model is:
- Immutable
- Equatable
- Built for safe state comparison

---

## Design Decisions

- Dark theme to match trading UX expectations
- Minimal but clear visual hierarchy
- Haptic feedback for better interaction feel
- Shimmer over loader for perceived performance
- Lazy list rendering for scalability
- Subtle animations to avoid abrupt UI changes

---

## Running the Project

```bash
git clone https://github.com/PravinKunnure/021Trade-Assignment

flutter pub get
flutter run
```

---

## Running Tests

```bash
flutter test
```

Tests cover:
- State transitions
- Reordering correctness
- Reset behavior
- Edge cases

---

## Design Principles

- **Separation of concerns** — UI, logic, and data are fully decoupled
- **Immutability** — No in-place mutations
- **Dependency Injection** — Easy to swap implementations
- **Type Safety** — Compile-time guarantees using enums and sealed states
- **Performance-aware** — Avoid unnecessary rebuilds using Equatable

---