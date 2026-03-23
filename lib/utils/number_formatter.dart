
abstract class NumberFormatter {
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
  static String formatPercent(double value) {
    final sign = value >= 0 ? '+' : '';
    return '$sign${value.toStringAsFixed(2)}%';
  }
  static String formatChange(double value, {String symbol = '\$'}) {
    final sign = value > 0 ? '+' : '';
    return '$sign$symbol${value.abs().toStringAsFixed(2)}';
  }
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
