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
        title: 'Waqti',
        theme: ThemeData(
          // ✅ Update tema sesuai warna baru (Teal + Gold)
          primaryColor: const Color(0xFF00695C),
          scaffoldBackgroundColor: const Color(0xFF004D40),
          cardColor: Colors.white,
          textTheme: const TextTheme(
            titleMedium: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            bodyMedium: TextStyle(
              color: Colors.white,
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF00695C),
            foregroundColor: Colors.white,
          ),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}