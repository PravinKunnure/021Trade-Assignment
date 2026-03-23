import 'package:equatable/equatable.dart';
import '../models/stock.dart';

sealed class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object?> get props => [];
}

/// Initial state before data is loaded.
class WatchlistInitial extends WatchlistState {
  const WatchlistInitial();
}

/// Stocks are being fetched / reloaded.
class WatchlistLoading extends WatchlistState {
  const WatchlistLoading();
}

/// Stocks are loaded and ready to display.
class WatchlistLoadSuccess extends WatchlistState {
  final List<Stock> stocks;
  final bool isReordered;

  const WatchlistLoadSuccess({
    required this.stocks,
    this.isReordered = false,
  });

  WatchlistLoadSuccess copyWith({
    List<Stock>? stocks,
    bool? isReordered,
  }) {
    return WatchlistLoadSuccess(
      stocks: stocks ?? this.stocks,
      isReordered: isReordered ?? this.isReordered,
    );
  }

  @override
  List<Object?> get props => [stocks, isReordered];
}

/// An error occurred while loading stocks.
class WatchlistLoadFailure extends WatchlistState {
  final String message;

  const WatchlistLoadFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
