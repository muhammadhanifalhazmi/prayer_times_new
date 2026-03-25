import 'package:flutter/material.dart';

class FuturisticBottomNav extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const FuturisticBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<FuturisticBottomNav> createState() => _FuturisticBottomNavState();
}

class _FuturisticBottomNavState extends State<FuturisticBottomNav>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (widget.currentIndex != index) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
      widget.onTap(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        // ✅ Background Solid (tidak transparan)
        color: const Color(0xFF00695C),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFFFD54F).withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home_rounded, 'Beranda'),
          _buildNavItem(1, Icons.calendar_today_rounded, 'Jadwal'),
          _buildNavItem(2, Icons.settings_rounded, 'Pengaturan'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = widget.currentIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFFD54F).withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFFD54F)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFFFD54F)
                      : Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFFFFD54F).withOpacity(0.6),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? const Color(0xFF00695C)
                      : Colors.white,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(height: 4),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isSelected ? 1.0 : 0.6,
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? const Color(0xFFFFD54F)
                      : Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}