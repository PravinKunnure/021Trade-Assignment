import 'package:equatable/equatable.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}

/// Fired once when the screen initialises — loads the stock list.
class WatchlistLoaded extends WatchlistEvent {
  const WatchlistLoaded();
}

/// Fired when the user completes a drag-and-drop reorder.
class WatchlistReordered extends WatchlistEvent {
  final int oldIndex;
  final int newIndex;

  const WatchlistReordered({
    required this.oldIndex,
    required this.newIndex,
  });

  @override
  List<Object?> get props => [oldIndex, newIndex];
}

/// Fired when the user taps the reset button to restore original order.
class WatchlistOrderReset extends WatchlistEvent {
  const WatchlistOrderReset();
}

/// Fired when the user taps a stock row (for detail navigation).
class WatchlistStockTapped extends WatchlistEvent {
  final String stockId;

  const WatchlistStockTapped({required this.stockId});

  @override
  List<Object?> get props => [stockId];
}
