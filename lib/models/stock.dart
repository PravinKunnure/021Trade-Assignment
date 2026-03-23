import 'package:equatable/equatable.dart';

enum StockTrend { up, down, neutral }

class Stock extends Equatable {
  final String id;
  final String symbol;
  final String companyName;
  final double currentPrice;
  final double changeAmount;
  final double changePercent;
  final double volume;
  final StockTrend trend;

  const Stock({
    required this.id,
    required this.symbol,
    required this.companyName,
    required this.currentPrice,
    required this.changeAmount,
    required this.changePercent,
    required this.volume,
    required this.trend,
  });

  bool get isPositive => changeAmount >= 0;

  Stock copyWith({
    String? id,
    String? symbol,
    String? companyName,
    double? currentPrice,
    double? changeAmount,
    double? changePercent,
    double? volume,
    StockTrend? trend,
  }) {
    return Stock(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      companyName: companyName ?? this.companyName,
      currentPrice: currentPrice ?? this.currentPrice,
      changeAmount: changeAmount ?? this.changeAmount,
      changePercent: changePercent ?? this.changePercent,
      volume: volume ?? this.volume,
      trend: trend ?? this.trend,
    );
  }

  @override
  List<Object?> get props => [
        id,
        symbol,
        companyName,
        currentPrice,
        changeAmount,
        changePercent,
        volume,
        trend,
      ];
}
