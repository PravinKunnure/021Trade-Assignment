/// Formatting helpers for prices, percentages, and volumes.
abstract class NumberFormatter {
  /// Format a price, e.g. 2945.60 → "₹2,945.60" or "$189.25".
  static String formatPrice(double price, {String symbol = '\$'}) {
    if (price >= 1000) {
      final parts = price.toStringAsFixed(2).split('.');
      final intPart = parts[0];
      final decPart = parts[1];
      final buffer = StringBuffer();
      int count = 0;
      for (int i = intPart.length - 1; i >= 0; i--) {
        buffer.write(intPart[i]);
        count++;
        if (count % 3 == 0 && i != 0) buffer.write(',');
      }
      return '$symbol${buffer.toString().split('').reversed.join()}.$decPart';
    }
    return '$symbol${price.toStringAsFixed(2)}';
  }

  /// Format percentage, e.g. 1.25 → "+1.25%" or -2.25 → "-2.25%".
  static String formatPercent(double value) {
    final sign = value >= 0 ? '+' : '';
    return '$sign${value.toStringAsFixed(2)}%';
  }

  /// Format change amount, e.g. 2.34 → "+2.34" or -5.72 → "-5.72".
  static String formatChange(double value, {String symbol = '\$'}) {
    final sign = value > 0 ? '+' : '';
    return '$sign$symbol${value.abs().toStringAsFixed(2)}';
  }

  /// Format volume, e.g. 54_230_000 → "54.23M" or 3_240_000 → "3.24M".
  static String formatVolume(double volume) {
    if (volume >= 1000000000) {
      return '${(volume / 1000000000).toStringAsFixed(2)}B';
    } else if (volume >= 1000000) {
      return '${(volume / 1000000).toStringAsFixed(2)}M';
    } else if (volume >= 1000) {
      return '${(volume / 1000).toStringAsFixed(1)}K';
    }
    return volume.toStringAsFixed(0);
  }
}
