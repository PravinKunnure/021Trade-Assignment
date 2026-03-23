import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WatchlistHeader extends StatelessWidget {
  final int stockCount;
  final bool isReordered;
  final VoidCallback onReset;

  const WatchlistHeader({
    super.key,
    required this.stockCount,
    required this.isReordered,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        border: Border(
          bottom: BorderSide(color: AppColors.darkDivider, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Count pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha:0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$stockCount stocks',
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Spacer(),

          // Drag hint
          const Icon(Icons.swap_vert, size: 15, color: AppColors.textTertiary),
          const SizedBox(width: 4),
          const Text(
            'Drag to reorder',
            style: TextStyle(color: AppColors.textTertiary, fontSize: 12),
          ),

          // Reset button — only visible when order has changed
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: isReordered
                ? Padding(
                    key: const ValueKey('reset'),
                    padding: const EdgeInsets.only(left: 10),
                    child: GestureDetector(
                      onTap: onReset,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.loss.withValues(alpha:0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.refresh,
                                size: 12, color: AppColors.loss),
                            SizedBox(width: 4),
                            Text(
                              'Reset',
                              style: TextStyle(
                                color: AppColors.loss,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(key: ValueKey('empty')),
          ),
        ],
      ),
    );
  }
}
