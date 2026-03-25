import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/prayer_time.dart';
import '../providers/prayer_time_provider.dart';

// --- Konfigurasi Tema Warna ---
class AppColors {
  static const Color primary = Color(0xFF00695C); // Teal Dark
  static const Color secondary = Color(0xFF4DB6AC); // Teal Light
  static const Color accent = Color(0xFFFFD54F); // Gold/Yellow
  static const Color cardWhite = Colors.white;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PrayerTimeProvider>(context, listen: false).loadPrayerTimes();
    });
  }

  // Helper untuk mencari index sholat berikutnya
  int? _getNextPrayerIndex(List<PrayerTime> times) {
    final now = DateTime.now();
    for (int i = 0; i < times.length; i++) {
      if (times[i].time.isAfter(now) || times[i].time.isAtSameMomentAs(now)) {
        return i;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background Gradient yang Modern
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF004D40), Color(0xFF00695C)],
          ),
        ),
        child: Consumer<PrayerTimeProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            } else if (provider.error != null) {
              return Center(
                child: Text(
                  'Error: ${provider.error}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            } else if (provider.prayerTimes == null) {
              return const Center(
                child: Text(
                  'Data belum tersedia',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final times = provider.prayerTimes!.times;
            final nextPrayerIndex = _getNextPrayerIndex(times);

            return SafeArea(
              child: CustomScrollView(
                slivers: [
                  // --- 1. AppBar (Dihapus Judul) ---
                  
                  // --- 2. Header Info (Tanggal, Daerah, Koordinat) ---
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tanggal
                          Text(
                            DateFormat('EEEE, d MMMM yyyy', 'id')
                                .format(DateTime.now()),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Nama Daerah (Dinamis dari Provider)
                          Row(
                            children: [
                              const Icon(Icons.location_city,
                                  color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  provider.regionName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          
                          // Garis Pemisah (Strip)
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          const SizedBox(height: 8),
                          
                          // Koordinat (Diperkecil agar tidak terpotong)
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  color: Colors.white, size: 14),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${provider.latitude.toStringAsFixed(4)}, ${provider.longitude.toStringAsFixed(4)}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,  // ✅ Diperkecil dari 12 ke 10
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- 3. Next Prayer Highlight (Hero Section) ---
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: nextPrayerIndex != null
                          ? _buildNextPrayerCard(times[nextPrayerIndex])
                          : const SizedBox.shrink(),
                    ),
                  ),

                  // --- 4. Prayer List Grid ---
                  SliverPadding(
                    padding: const EdgeInsets.all(20.0),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.0,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final isNext = index == nextPrayerIndex;
                          return _buildPrayerCard(
                            times[index],
                            isNext: isNext,
                          );
                        },
                        childCount: times.length,
                      ),
                    ),
                  ),

                  // --- Bottom Spacing ---
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 40),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Widget untuk Sholat Berikutnya (Highlight)
  Widget _buildNextPrayerCard(PrayerTime prayer) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD54F), Color(0xFFFFCA28)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Circle
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getPrayerIcon(prayer.name),
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          // Text Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sholat Berikutnya',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  prayerName(prayer.name),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('HH:mm').format(prayer.time),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          // Countdown Placeholder (Visual only for now)
          const Icon(Icons.access_time, color: Colors.white, size: 24),
        ],
      ),
    );
  }

  // Widget Kartu Sholat Biasa
  Widget _buildPrayerCard(PrayerTime prayer, {required bool isNext}) {
    return Container(
      decoration: BoxDecoration(
        color: isNext ? AppColors.primary : AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Pattern (Opsional)
          if (!isNext)
            Positioned(
              right: -10,
              top: -10,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getPrayerIcon(prayer.name),
                  color: isNext ? Colors.white : AppColors.primary,
                  size: 32,
                ),
                const SizedBox(height: 12),
                Text(
                  prayerName(prayer.name),
                  style: TextStyle(
                    color: isNext ? Colors.white : AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Perbaikan Overflow: maxLines dan overflow
                Text(
                  DateFormat('HH:mm').format(prayer.time),
                  style: TextStyle(
                    color: isNext ? Colors.white : AppColors.primary,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Indicator jika ini sholat berikutnya
          if (isNext)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'NEXT',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Helper untuk nama sholat
  String prayerName(String name) {
    switch (name) {
      case 'Fajr':
        return 'Subuh';
      case 'Sunrise':
        return 'Syuruq';
      case 'Dhuhr':
        return 'Dzuhur';
      case 'Asr':
        return 'Ashar';
      case 'Maghrib':
        return 'Maghrib';
      case 'Isha':
        return 'Isya';
      default:
        return name;
    }
  }

  // Helper untuk ikon sholat
  IconData _getPrayerIcon(String name) {
    switch (name) {
      case 'Fajr':
        return Icons.night_shelter;
      case 'Sunrise':
        return Icons.sunny;
      case 'Dhuhr':
        return Icons.wb_sunny_outlined;
      case 'Asr':
        return Icons.wb_cloudy;
      case 'Maghrib':
        return Icons.nightlight_round;
      case 'Isha':
        return Icons.nights_stay;
      default:
        return Icons.access_time;
    }
  }
}