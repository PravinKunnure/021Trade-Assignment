import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc.dart';
import 'models/stock_repository.dart';
import 'screens/watchlist_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait; remove if the app should support landscape.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Use a dark system navigation bar to match the app theme.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.darkBg,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const WatchlistApp());
}

class WatchlistApp extends StatelessWidget {
  const WatchlistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WatchlistBloc(
        repository: SampleStockRepository(),
      ),
      child: MaterialApp(
        title: '021Trade Watchlist',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const WatchlistScreen(),
      ),
    );
  }
}
