// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'providers/prayer_time_provider.dart';
import 'screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null); // ✅ Tambahkan ini
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PrayerTimeProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Waktu Sholat',
        theme: ThemeData(
          primaryColor: const Color(0xFF727381),
          scaffoldBackgroundColor: const Color(0xFFF4F3F1),
          cardColor: const Color(0xFFBDB8A8),
          textTheme: const TextTheme(
            titleMedium: TextStyle(
              color: Color(0xFF727381),
              fontWeight: FontWeight.bold,
            ),
            bodyMedium: TextStyle(
              color: Color(0xFF727381),
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF727381),
            foregroundColor: Colors.white,
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}