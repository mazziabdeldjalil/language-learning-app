import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class GradientBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool hideProfile;

  const GradientBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.hideProfile = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final items = [
      {'icon': Icons.home, 'label': 'Home'},
      {'icon': Icons.menu_book, 'label': 'Library'},
      {'icon': Icons.groups, 'label': 'Community'},
      {'icon': Icons.leaderboard, 'label': 'Progress'},
    ];
    if (!hideProfile) {
      items.add({'icon': Icons.person, 'label': 'Profile'});
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            themeProvider.primaryColor.withOpacity(0.85),
            themeProvider.primaryColor.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: themeProvider.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            color: Colors.white.withOpacity(0.1),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(items.length, (index) {
                    final isActive = index == currentIndex;
                    return GestureDetector(
                      onTap: () => onTap(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isActive
                              ? themeProvider.primaryColor
                              .withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              items[index]['icon'] as IconData,
                              color: isActive
                                  ? themeProvider.primaryColor
                                  : Colors.white.withOpacity(0.6),
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              items[index]['label'] as String,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: isActive
                                    ? themeProvider.primaryColor
                                    : Colors.white.withOpacity(0.6),
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
          ),
        ),
      ),
    );
  }
}