import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edu_smart_assistant/config/theme.dart';

class DiyaaNavItem {
  final String icon;
  final String label;

  const DiyaaNavItem({required this.icon, required this.label});
}

class DiyaaBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<DiyaaNavItem> items;

  const DiyaaBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppTheme.bg200, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isActive = index == currentIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.icon,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: GoogleFonts.tajawal(
                          fontSize: 11,
                          color: isActive
                              ? AppTheme.primary200
                              : AppTheme.text200,
                          fontWeight:
                              isActive ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
