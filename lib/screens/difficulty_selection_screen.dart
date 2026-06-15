import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:language_learning_app/core/backend.dart';
import '../providers/theme_provider.dart';
import '../widgets/help_dialog.dart';

class DifficultySelectionScreen extends StatelessWidget {
  const DifficultySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/scenario.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.75),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Consumer<ChatProvider>(
            builder: (context, chatProvider, _) {
              final scenario = chatProvider.selectedScenario;
              final hasScenario = chatProvider.selectedScenarioModel != null || scenario != null;

              if (!hasScenario) {
                return const Center(
                  child: Text('Please select a scenario first',
                      style: TextStyle(color: Colors.white)),
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'FluentlyDZ',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                                color: themeProvider.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () => showHelpDialog(context),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.06),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'HELP',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      4,
                      (index) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == 1
                              ? themeProvider.primaryColor
                              : Colors.white.withOpacity(0.25),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: themeProvider.primaryColor.withOpacity(0.24),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            themeProvider.primaryColor.withOpacity(0.18),
                            Colors.white.withOpacity(0.02),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Pick your challenge.',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.4,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Choose a difficulty level that matches your comfort zone and push a little further.',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFDDC1AE),
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Selected scenario',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                        Text(
                          'Tap a level below',
                          style: TextStyle(
                            color: Color(0xFFDDC1AE),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select difficulty',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Choose your level to get the right challenge.',
                            style: TextStyle(
                                fontSize: 14, color: Color(0xFFDDC1AE)),
                          ),
                          const SizedBox(height: 20),

                          // Selected scenario chip
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: themeProvider.primaryColor
                                        .withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Show icon from model if available, otherwise from enum
                                    Icon(
                                      chatProvider.selectedScenarioModel != null
                                          ? _getIconFromName(chatProvider.selectedScenarioModel!.iconName)
                                          : scenario!.icon,
                                      color: themeProvider.primaryColor,
                                      size: 28,
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Selected Scenario',
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Color(0xFFDDC1AE))),
                                        Text(
                                          chatProvider.selectedScenarioModel != null
                                              ? chatProvider.selectedScenarioModel!.title
                                              : scenario!.name,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Difficulty options
                          ...[
                            Difficulty.beginner,
                            Difficulty.intermediate,
                            Difficulty.advanced
                          ].map((difficulty) =>
                              _DifficultyOption(difficulty: difficulty)),

                          const SizedBox(height: 24),

                          // Start Chat Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: chatProvider.selectedDifficulty != null
                                  ? () => Navigator.pushNamed(context, '/chat')
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeProvider.primaryColor,
                                foregroundColor: const Color(0xFF2F1500),
                                disabledBackgroundColor:
                                    Colors.white.withOpacity(0.1),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.play_circle_fill, size: 24),
                                  SizedBox(width: 10),
                                  Text('Start Chat',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

IconData _getIconFromName(String iconName) {
  switch (iconName) {
    case 'work':
      return Icons.work_outline;
    case 'flight':
      return Icons.flight_outlined;
    case 'school':
      return Icons.school_outlined;
    case 'restaurant':
      return Icons.restaurant_outlined;
    case 'local_hospital':
      return Icons.local_hospital_outlined;
    case 'sports':
      return Icons.sports_outlined;
    case 'shopping_cart':
      return Icons.shopping_cart_outlined;
    case 'music_note':
      return Icons.music_note_outlined;
    default:
      return Icons.chat_bubble_outline;
  }
}

class _DifficultyOption extends StatelessWidget {
  final Difficulty difficulty;
  const _DifficultyOption({required this.difficulty});

  Color _getLevelColor(String name) {
    switch (name.toLowerCase()) {
      case 'beginner':
        return const Color(0xFF2ECC71);
      case 'intermediate':
        return const Color(0xFFFF8A00);
      case 'advanced':
        return const Color(0xFFEF5350);
      default:
        return const Color(0xFF88CEFF);
    }
  }

  IconData _getLevelIcon(String name) {
    switch (name.toLowerCase()) {
      case 'beginner':
        return Icons.eco;
      case 'intermediate':
        return Icons.trending_up;
      case 'advanced':
        return Icons.rocket;
      default:
        return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, _) {
        final isSelected = chatProvider.selectedDifficulty == difficulty;
        final levelColor = _getLevelColor(difficulty.name);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () => chatProvider.setDifficulty(difficulty),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? themeProvider.primaryColor.withOpacity(0.1)
                        : Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? themeProvider.primaryColor
                          : Colors.white.withOpacity(0.1),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: levelColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(_getLevelIcon(difficulty.name),
                            color: levelColor, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              difficulty.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? themeProvider.primaryColor
                                    : Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              difficulty.description,
                              style: const TextStyle(
                                  fontSize: 12, color: Color(0xFFDDC1AE)),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        Icon(Icons.check_circle,
                            color: themeProvider.primaryColor, size: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}






