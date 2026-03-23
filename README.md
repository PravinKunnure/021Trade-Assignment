# 021Trade — Stock Watchlist (Flutter BLoC Assignment)

A production-quality Flutter application implementing a drag-to-reorder stock watchlist using the BLoC architecture pattern, built as part of the Diamond Hands LLP / 021Trade assignment.

---

## Table of Contents

1. [Demo](#demo)
2. [Features](#features)
3. [Architecture Overview](#architecture-overview)
4. [Project Structure](#project-structure)
5. [BLoC Implementation](#bloc-implementation)
6. [Data Layer](#data-layer)
7. [UI/UX Decisions](#uiux-decisions)
8. [Getting Started](#getting-started)
9. [Running Tests](#running-tests)
10. [Design Principles](#design-principles)

---

## Features

- **Drag-to-reorder** — long-press any stock tile and drag it to a new position; haptic feedback fires on lift.
- **BLoC architecture** — every state mutation flows through typed events and sealed states; zero business logic in the widget tree.
- **Loading shimmer** — animated placeholder tiles replace the list while data loads.
- **Reset order** — an animated "Reset" chip appears whenever the order differs from the original; tapping it restores the default sort.
- **Gain / Loss badges** — each tile shows a colour-coded % change and absolute change amount.
- **Volume display** — human-readable volume (e.g. `54.23M`) per stock.
- **Type-safe models** — `Stock` extends `Equatable`; `StockTrend` is a Dart `enum`; all fields are `final`.
- **Dark trading-app theme** — deep backgrounds, green accent (`#00D09C`), red/green gain-loss colours.
- **Error state with retry** — if loading fails, an error screen is shown with a retry button.
- **Unit-tested BLoC** — all event handlers covered with `bloc_test`.

---

## Architecture Overview

```
┌─────────────────────────────────────────┐
│              Presentation Layer          │
│  WatchlistScreen  ←  BlocConsumer/      │
│  (screens/)           BlocBuilder       │
│       │                                 │
│  Widgets (stock_tile, header, shimmer…) │
└──────────────┬──────────────────────────┘
               │  Events ↑  States ↓
┌──────────────▼──────────────────────────┐
│               BLoC Layer                │
│  WatchlistBloc                          │
│  ├── WatchlistEvent (sealed hierarchy)  │
│  └── WatchlistState (sealed hierarchy)  │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│               Data Layer                │
│  StockRepository (abstract)             │
│  SampleStockRepository (concrete impl)  │
└─────────────────────────────────────────┘
```

The UI layer **never** mutates state directly — it only dispatches events. The BLoC processes each event deterministically and emits a new state. Widgets rebuild only when the state they care about changes (powered by `Equatable`).

---

## Project Structure

```
lib/
├── main.dart                        # Entry point — BlocProvider + MaterialApp
│
├── bloc/
│   ├── watchlist_bloc.dart          # Business logic, event handlers
│   ├── watchlist_event.dart         # All events (sealed abstract class)
│   ├── watchlist_state.dart         # All states (sealed abstract class)
│   └── bloc.dart                    # Barrel export
│
├── models/
│   ├── stock.dart                   # Stock entity + StockTrend enum
│   └── stock_repository.dart        # Abstract repo + sample data impl
│
├── screens/
│   └── watchlist_screen.dart        # Full watchlist page
│
├── widgets/
│   ├── stock_tile.dart              # Draggable stock row
│   ├── watchlist_header.dart        # Count pill + drag hint + reset chip
│   ├── watchlist_loading_shimmer.dart # Shimmer placeholders
│   ├── watchlist_empty_state.dart   # Empty watchlist view
│   └── watchlist_error_state.dart   # Error + retry view
│
├── theme/
│   └── app_theme.dart               # AppColors constants + ThemeData
│
└── utils/
    └── number_formatter.dart        # Price, %, volume formatters

test/
└── watchlist_bloc_test.dart         # BLoC unit tests (bloc_test)
```

---

## BLoC Implementation

### Events

| Event | Payload | Purpose |
|---|---|---|
| `WatchlistLoaded` | — | Triggers initial data fetch |
| `WatchlistReordered` | `oldIndex`, `newIndex` | Persists a drag-and-drop swap |
| `WatchlistOrderReset` | — | Restores the original sort order |
| `WatchlistStockTapped` | `stockId` | Extensibility hook for navigation |

### States

| State | Fields | When emitted |
|---|---|---|
| `WatchlistInitial` | — | Before any event is fired |
| `WatchlistLoading` | — | While the repository fetch is in progress |
| `WatchlistLoadSuccess` | `stocks`, `isReordered` | Data ready; after every reorder |
| `WatchlistLoadFailure` | `message` | Repository throws |

### Reorder logic

`ReorderableListView` emits a `newIndex` **after** the item has been removed from the list, meaning it is off by 1 when moving an item downward. The BLoC corrects this:

```dart
final int adjustedNew = event.newIndex > event.oldIndex
    ? event.newIndex - 1
    : event.newIndex;
```

This is a well-known Flutter caveat — handling it in the BLoC keeps the widget layer clean.

### `isReordered` flag

After every `WatchlistReordered` event the BLoC compares the current list against the cached `_originalOrder` (stored on first load). If the lists are identical the flag is cleared, making the Reset chip disappear automatically if the user happens to drag stocks back to their original positions.

---

## Data Layer

`StockRepository` is an **abstract class** — the production app would inject a network-backed implementation (e.g. `HttpStockRepository`). Tests inject `_FakeRepository`. The `SampleStockRepository` ships with 10 realistic stocks including US tech and Indian equities.

```dart
abstract class StockRepository {
  List<Stock> getWatchlistStocks();
}
```

`Stock` is a fully immutable value object:
- All fields `final`
- `copyWith` for functional updates
- `Equatable` props list drives state comparison and prevents unnecessary rebuilds

---

## UI/UX Decisions

| Decision | Rationale |
|---|---|
| **Dark theme only** | Matches the reference video and standard trading-app convention |
| **`#00D09C` green accent** | Chosen to complement the 021Trade brand colour visible in the assignment video |
| **Symbol badge with HSL-derived colour** | Each stock gets a deterministic unique colour without manual assignment |
| **`proxyDecorator` override** | The default drag overlay is a flat card; overriding it adds a green-tinted shadow so the dragged item feels "lifted" |
| **Haptic feedback on drag** | `HapticFeedback.lightImpact()` fires on lift for physical confirmation |
| **Animated shimmer on load** | Better perceived performance than a spinner |
| **Animated Reset chip** | `AnimatedSwitcher` slides the chip in/out so the header does not jump |
| **`ReorderableListView.builder`** | Uses the builder constructor for lazy rendering — scales to large lists |
| **Divider at `indent: 74`** | Lines up with the text column, not the leading badge, matching modern app conventions |

---

## Getting Started

### Prerequisites

- Flutter SDK `≥ 3.0.0`
- Dart SDK `≥ 3.0.0`

### Install & Run

```bash
git clone https://github.com/<your-username>/021trade-watchlist.git
cd 021trade-watchlist

flutter pub get
flutter run
```

Tested on:
- Android emulator (API 33) and physical device
- iOS Simulator (iOS 17) and physical device
- Flutter 3.19 / Dart 3.3

---

## Running Tests

```bash
flutter test
```

The test suite covers:
- Initial state assertion
- `WatchlistLoaded` → `[Loading, LoadSuccess]` sequence
- `WatchlistReordered` — verifies correct new order and `isReordered` flag
- `WatchlistReordered` no-op when state is not `LoadSuccess`
- `WatchlistOrderReset` — verifies list is restored and `isReordered` becomes `false`

---

## Design Principles

**Single Responsibility** — Each file has one job. The BLoC knows nothing about widgets; widgets know nothing about repositories.

**Dependency Injection** — `WatchlistBloc` receives a `StockRepository` via constructor. Swapping implementations (mock, network, local DB) requires zero changes to the BLoC.

**Type Safety** — `StockTrend` is an exhaustive `enum` consumed via `switch` expressions; the compiler enforces all cases are handled. State pattern-matching uses Dart's sealed-class exhaustiveness checking.

**Immutability** — `Stock` objects are never mutated. Reordering creates a new `List<Stock>` and emits a new state; the previous state is discarded.

**Equatable** — Both `Stock` and all `WatchlistState` subclasses extend `Equatable`. BLoC skips emitting identical consecutive states, preventing unnecessary widget rebuilds.
