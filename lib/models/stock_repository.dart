import '../models/stock.dart';

abstract class StockRepository {
  List<Stock> getWatchlistStocks();
}

class SampleStockRepository implements StockRepository {
  static const List<Stock> _stocks = [
    Stock(
      id: 'AAPL',
      symbol: 'AAPL',
      companyName: 'Apple Inc.',
      currentPrice: 189.25,
      changeAmount: 2.34,
      changePercent: 1.25,
      volume: 54230000,
      trend: StockTrend.up,
    ),
    Stock(
      id: 'TSLA',
      symbol: 'TSLA',
      companyName: 'Tesla, Inc.',
      currentPrice: 248.50,
      changeAmount: -5.72,
      changePercent: -2.25,
      volume: 89120.000,
      trend: StockTrend.down,
    ),
    Stock(
      id: 'GOOGL',
      symbol: 'GOOGL',
      companyName: 'Alphabet Inc.',
      currentPrice: 174.10,
      changeAmount: 1.88,
      changePercent: 1.09,
      volume: 21540000,
      trend: StockTrend.up,
    ),
    Stock(
      id: 'MSFT',
      symbol: 'MSFT',
      companyName: 'Microsoft Corp.',
      currentPrice: 415.80,
      changeAmount: 3.45,
      changePercent: 0.84,
      volume: 18750000,
      trend: StockTrend.up,
    ),
    Stock(
      id: 'AMZN',
      symbol: 'AMZN',
      companyName: 'Amazon.com, Inc.',
      currentPrice: 198.73,
      changeAmount: -2.19,
      changePercent: -1.09,
      volume: 33210000,
      trend: StockTrend.down,
    ),
    Stock(
      id: 'NVDA',
      symbol: 'NVDA',
      companyName: 'NVIDIA Corporation',
      currentPrice: 875.40,
      changeAmount: 14.60,
      changePercent: 1.70,
      volume: 42890000,
      trend: StockTrend.up,
    ),
    Stock(
      id: 'META',
      symbol: 'META',
      companyName: 'Meta Platforms, Inc.',
      currentPrice: 527.30,
      changeAmount: -8.45,
      changePercent: -1.58,
      volume: 15670000,
      trend: StockTrend.down,
    ),
    Stock(
      id: 'NFLX',
      symbol: 'NFLX',
      companyName: 'Netflix, Inc.',
      currentPrice: 632.15,
      changeAmount: 0.00,
      changePercent: 0.00,
      volume: 4320000,
      trend: StockTrend.neutral,
    ),
    Stock(
      id: 'RELIANCE',
      symbol: 'RELIANCE',
      companyName: 'Reliance Industries',
      currentPrice: 2945.60,
      changeAmount: 38.20,
      changePercent: 1.31,
      volume: 9870000,
      trend: StockTrend.up,
    ),
    Stock(
      id: 'TCS',
      symbol: 'TCS',
      companyName: 'Tata Consultancy Services',
      currentPrice: 3892.45,
      changeAmount: -22.10,
      changePercent: -0.56,
      volume: 3240000,
      trend: StockTrend.down,
    ),
  ];

  @override
  List<Stock> getWatchlistStocks() => List.unmodifiable(_stocks);
}
