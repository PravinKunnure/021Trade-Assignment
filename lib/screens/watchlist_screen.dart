import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc.dart';
import '../theme/app_theme.dart';
import '../widgets/stock_tile.dart';
import '../widgets/watchlist_empty_state.dart';
import '../widgets/watchlist_error_state.dart';
import '../widgets/watchlist_header.dart';
import '../widgets/watchlist_loading_shimmer.dart';

class WatchlistMainScreen extends StatefulWidget {
  const WatchlistMainScreen({super.key});

  @override
  State<WatchlistMainScreen> createState() => _WatchlistMainScreenState();
}

class _WatchlistMainScreenState extends State<WatchlistMainScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WatchlistBloc>().add(const WatchlistLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: _buildAppBar(context),
      body: BlocConsumer<WatchlistBloc, WatchlistState>(
        listener: _handleStateChange,
        builder: _buildBody,
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.darkSurface,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              '021',
              style: TextStyle(
                color: AppColors.darkBg,
                fontWeight: FontWeight.w800,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Text('Trade', style: TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.textSecondary),
          onPressed: () {},
          tooltip: 'Search',
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none,
              color: AppColors.textSecondary),
          onPressed: () {},
          tooltip: 'Notifications',
        ),
        const SizedBox(width: 4),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 0.5,
          color: AppColors.darkDivider,
        ),
      ),
    );
  }


  Widget _buildBody(BuildContext context, WatchlistState state) {
    return switch (state) {
      WatchlistInitial() => const SizedBox.shrink(),
      WatchlistLoading() => const WatchlistLoadingShimmer(),
      WatchlistLoadSuccess() => _buildList(context, state),
      WatchlistLoadFailure() => WatchlistErrorState(
          message: state.message,
          onRetry: () =>
              context.read<WatchlistBloc>().add(const WatchlistLoaded()),
        ),
    };
  }

  Widget _buildList(BuildContext context, WatchlistLoadSuccess state) {
    if (state.stocks.isEmpty) return const WatchlistEmptyState();

    return Column(
      children: [
        WatchlistHeader(
          stockCount: state.stocks.length,
          isReordered: state.isReordered,
          onReset: () =>
              context.read<WatchlistBloc>().add(const WatchlistOrderReset()),
        ),
        Expanded(
          child: ReorderableListView.builder(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 16,
            ),
            itemCount: state.stocks.length,
            onReorder: (oldIndex, newIndex) {
              HapticFeedback.lightImpact();
              context.read<WatchlistBloc>().add(
                    WatchlistReordered(
                      oldIndex: oldIndex,
                      newIndex: newIndex,
                    ),
                  );
            },
            itemBuilder: (context, index) {
              final stock = state.stocks[index];
              return Column(
                key: ValueKey(stock.id),
                mainAxisSize: MainAxisSize.min,
                children: [
                  StockTile(
                    stock: stock,
                    onTap: () => context.read<WatchlistBloc>().add(
                          WatchlistStockTapped(stockId: stock.id),
                        ),
                  ),
                  if (index < state.stocks.length - 1)
                    const Divider(indent: 74),
                ],
              );
            },
            // Override the default drag overlay
            proxyDecorator: (child, index, animation) {
              return AnimatedBuilder(
                animation: animation,
                builder: (_, __) {
                  final double elevation =
                      Tween<double>(begin: 0, end: 8).evaluate(animation);
                  return Material(
                    elevation: elevation,
                    color: AppColors.darkCard,
                    borderRadius: BorderRadius.circular(12),
                    shadowColor: AppColors.primary.withOpacity(0.35),
                    child: child,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _handleStateChange(BuildContext context, WatchlistState state) {
    // if (state is WatchlistLoadSuccess && state.isReordered) {
    //   // Could show a SnackBar on first reorder, etc.
    // }
  }
}
