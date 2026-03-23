import 'package:flutter/material.dart';
import '../models/stock.dart';
import '../theme/app_theme.dart';
import '../utils/number_formatter.dart';

class StockTile extends StatelessWidget {
  final Stock stock;
  final VoidCallback? onTap;

  const StockTile({
    super.key,
    required this.stock,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color trendColor = _trendColor(stock.trend);
    final Color trendBg = _trendBg(stock.trend);

    return InkWell(
      onTap: onTap,
      splashColor: AppColors.primary.withOpacity(0.08),
      highlightColor: AppColors.primary.withOpacity(0.04),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Symbol badge
            _SymbolBadge(symbol: stock.symbol),
            const SizedBox(width: 14),

            // Company name + volume
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stock.symbol,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    stock.companyName,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Vol: ${NumberFormatter.formatVolume(stock.volume)}',
                    style: const TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            // Price + change badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  NumberFormatter.formatPrice(stock.currentPrice),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 5),
                _ChangeBadge(
                  trendColor: trendColor,
                  trendBg: trendBg,
                  change: NumberFormatter.formatChange(stock.changeAmount),
                  percent: NumberFormatter.formatPercent(stock.changePercent),
                ),
              ],
            ),

            // Drag handle
            const SizedBox(width: 12),
            const _DragHandle(),
          ],
        ),
      ),
    );
  }

  Color _trendColor(StockTrend trend) {
    return switch (trend) {
      StockTrend.up => AppColors.gain,
      StockTrend.down => AppColors.loss,
      StockTrend.neutral => AppColors.neutral,
    };
  }

  Color _trendBg(StockTrend trend) {
    return switch (trend) {
      StockTrend.up => AppColors.gainBg,
      StockTrend.down => AppColors.lossBg,
      StockTrend.neutral => AppColors.darkCard,
    };
  }
}

// ---------------------------------------------------------------------------
// Sub-widgets
// ---------------------------------------------------------------------------

class _SymbolBadge extends StatelessWidget {
  final String symbol;
  const _SymbolBadge({required this.symbol});

  @override
  Widget build(BuildContext context) {
    final hue = symbol.codeUnits.fold(0, (a, b) => a + b) % 360;
    final color = HSLColor.fromAHSL(1, hue.toDouble(), 0.55, 0.40).toColor();

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.35), width: 0.8),
      ),
      child: Center(
        child: Text(
          symbol.length > 2 ? symbol.substring(0, 2) : symbol,
          style: TextStyle(
            color: color.withOpacity(0.9),
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _ChangeBadge extends StatelessWidget {
  final Color trendColor;
  final Color trendBg;
  final String change;
  final String percent;

  const _ChangeBadge({
    required this.trendColor,
    required this.trendBg,
    required this.change,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: trendBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            percent,
            style: TextStyle(
              color: trendColor,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          Text(
            change,
            style: TextStyle(
              color: trendColor.withOpacity(0.75),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 3,
      children: List.generate(
        3,
        (_) => Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 2,
          children: List.generate(
            2,
            (_) => Container(
              width: 3,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.textTertiary,
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
