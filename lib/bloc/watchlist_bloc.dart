import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/stock.dart';
import '../models/stock_repository.dart';
import 'watchlist_event.dart';
import 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final StockRepository _repository;

  /// Cached original order so we can reset at any time.
  late final List<Stock> _originalOrder;

  WatchlistBloc({required StockRepository repository})
      : _repository = repository,
        super(const WatchlistInitial()) {
    on<WatchlistLoaded>(_onLoaded);
    on<WatchlistReordered>(_onReordered);
    on<WatchlistOrderReset>(_onOrderReset);
    on<WatchlistStockTapped>(_onStockTapped);
  }

  // ---------------------------------------------------------------------------
  // Handlers
  // ---------------------------------------------------------------------------

  Future<void> _onLoaded(
    WatchlistLoaded event,
    Emitter<WatchlistState> emit,
  ) async {
    emit(const WatchlistLoading());
    try {
      // Simulate a brief async fetch (e.g. from a real API).
      await Future<void>.delayed(const Duration(milliseconds: 400));
      final stocks = _repository.getWatchlistStocks().toList();
      _originalOrder = List.unmodifiable(stocks);
      emit(WatchlistLoadSuccess(stocks: stocks));
    } catch (e) {
      emit(WatchlistLoadFailure(message: e.toString()));
    }
  }

  void _onReordered(
    WatchlistReordered event,
    Emitter<WatchlistState> emit,
  ) {
    final currentState = state;
    if (currentState is! WatchlistLoadSuccess) return;

    final updated = List<Stock>.from(currentState.stocks);

    // Flutter's ReorderableListView fires newIndex AFTER the item is removed;
    // we must adjust by 1 when the item moved downward.
    final int adjustedNew = event.newIndex > event.oldIndex
        ? event.newIndex - 1
        : event.newIndex;

    final Stock moved = updated.removeAt(event.oldIndex);
    updated.insert(adjustedNew, moved);

    final bool isReordered = _hasOrderChanged(updated);
    emit(currentState.copyWith(stocks: updated, isReordered: isReordered));
  }

  void _onOrderReset(
    WatchlistOrderReset event,
    Emitter<WatchlistState> emit,
  ) {
    final currentState = state;
    if (currentState is! WatchlistLoadSuccess) return;

    emit(currentState.copyWith(
      stocks: List<Stock>.from(_originalOrder),
      isReordered: false,
    ));
  }

  // Stock tap is intentionally a no-op in the BLoC; navigation is handled
  // by the UI layer via a BlocListener.  The event is kept in the BLoC so
  // that side-effects (analytics, etc.) can be added later without touching
  // the view.
  void _onStockTapped(
    WatchlistStockTapped event,
    Emitter<WatchlistState> emit,
  ) {}

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  bool _hasOrderChanged(List<Stock> current) {
    if (current.length != _originalOrder.length) return true;
    for (int i = 0; i < current.length; i++) {
      if (current[i].id != _originalOrder[i].id) return true;
    }
    return false;
  }
}
