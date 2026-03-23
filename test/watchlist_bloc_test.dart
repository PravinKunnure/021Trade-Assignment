import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watchlist_app/bloc/bloc.dart';
import 'package:watchlist_app/models/stock.dart';
import 'package:watchlist_app/models/stock_repository.dart';

// ---------------------------------------------------------------------------
// Fake repository for testing
// ---------------------------------------------------------------------------

class _FakeRepository implements StockRepository {
  @override
  List<Stock> getWatchlistStocks() => const [
        Stock(
          id: 'A',
          symbol: 'A',
          companyName: 'Alpha',
          currentPrice: 100,
          changeAmount: 1,
          changePercent: 1,
          volume: 1000,
          trend: StockTrend.up,
        ),
        Stock(
          id: 'B',
          symbol: 'B',
          companyName: 'Beta',
          currentPrice: 200,
          changeAmount: -2,
          changePercent: -1,
          volume: 2000,
          trend: StockTrend.down,
        ),
        Stock(
          id: 'C',
          symbol: 'C',
          companyName: 'Gamma',
          currentPrice: 300,
          changeAmount: 0,
          changePercent: 0,
          volume: 3000,
          trend: StockTrend.neutral,
        ),
      ];
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late WatchlistBloc bloc;

  setUp(() {
    bloc = WatchlistBloc(repository: _FakeRepository());
  });

  tearDown(() => bloc.close());

  group('WatchlistBloc', () {
    test('initial state is WatchlistInitial', () {
      expect(bloc.state, const WatchlistInitial());
    });

    blocTest<WatchlistBloc, WatchlistState>(
      'emits [Loading, LoadSuccess] when WatchlistLoaded is added',
      build: () => WatchlistBloc(repository: _FakeRepository()),
      act: (b) => b.add(const WatchlistLoaded()),
      expect: () => [
        const WatchlistLoading(),
        isA<WatchlistLoadSuccess>().having(
          (s) => s.stocks.length,
          'stock count',
          3,
        ),
      ],
    );

    blocTest<WatchlistBloc, WatchlistState>(
      'reorders stocks correctly (move A from index 0 to end)',
      build: () => WatchlistBloc(repository: _FakeRepository()),
      seed: () => const WatchlistLoadSuccess(
        stocks: [
          Stock(
            id: 'A',
            symbol: 'A',
            companyName: 'Alpha',
            currentPrice: 100,
            changeAmount: 1,
            changePercent: 1,
            volume: 1000,
            trend: StockTrend.up,
          ),
          Stock(
            id: 'B',
            symbol: 'B',
            companyName: 'Beta',
            currentPrice: 200,
            changeAmount: -2,
            changePercent: -1,
            volume: 2000,
            trend: StockTrend.down,
          ),
          Stock(
            id: 'C',
            symbol: 'C',
            companyName: 'Gamma',
            currentPrice: 300,
            changeAmount: 0,
            changePercent: 0,
            volume: 3000,
            trend: StockTrend.neutral,
          ),
        ],
        isReordered: false,
      ),
      act: (b) =>
          b.add(const WatchlistReordered(oldIndex: 0, newIndex: 3)),
      expect: () => [
        isA<WatchlistLoadSuccess>()
            .having((s) => s.stocks.first.id, 'first stock', 'B')
            .having((s) => s.stocks.last.id, 'last stock', 'A')
            .having((s) => s.isReordered, 'isReordered', true),
      ],
    );

    blocTest<WatchlistBloc, WatchlistState>(
      'does nothing for WatchlistReordered when state is not LoadSuccess',
      build: () => WatchlistBloc(repository: _FakeRepository()),
      act: (b) =>
          b.add(const WatchlistReordered(oldIndex: 0, newIndex: 1)),
      expect: () => [],
    );

    blocTest<WatchlistBloc, WatchlistState>(
      'emits LoadSuccess with isReordered=false after reset',
      build: () => WatchlistBloc(repository: _FakeRepository()),
      act: (b) async {
        b.add(const WatchlistLoaded());
        await Future<void>.delayed(const Duration(milliseconds: 500));
        b.add(const WatchlistReordered(oldIndex: 0, newIndex: 3));
        b.add(const WatchlistOrderReset());
      },
      skip: 2, // skip Loading + initial LoadSuccess
      expect: () => [
        isA<WatchlistLoadSuccess>().having(
            (s) => s.isReordered, 'isReordered after reorder', true),
        isA<WatchlistLoadSuccess>().having(
            (s) => s.isReordered, 'isReordered after reset', false),
      ],
    );
  });
}
