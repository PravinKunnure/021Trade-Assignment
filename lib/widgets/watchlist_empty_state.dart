import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WatchlistEmptyState extends StatelessWidget {
  const WatchlistEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.show_chart, size: 56, color: AppColors.textTertiary),
          SizedBox(height: 16),
          Text(
            'Your watchlist is empty',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add stocks to track them here',
            style: TextStyle(color: AppColors.textTertiary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
