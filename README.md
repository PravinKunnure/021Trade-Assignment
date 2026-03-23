# 021Trade — Stock Watchlist (Flutter BLoC Assignment)

A production-quality Flutter application implementing a drag-to-reorder stock watchlist using the BLoC architecture pattern, built as part of the Diamond Hands LLP / 021Trade assignment.

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