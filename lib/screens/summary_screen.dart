import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/backend.dart';
import '../providers/theme_provider.dart';
import '../data/scenario_phrases.dart';

class SummaryScreen extends StatelessWidget {
  final SessionSummary summary;
  final String iconName;

  const SummaryScreen({super.key, required this.summary, this.iconName = 'chat_bubble'});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final streak = context.watch<ChatProvider>().userProfile?.sessionsCompleted ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/progress.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.78),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () =>
                          Navigator.of(context).popUntil((r) => r.isFirst),
                    ),
                    const SizedBox(width: 8),
                    Text('FluentlyDZ',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: themeProvider.primaryColor)),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: themeProvider.primaryColor.withOpacity(0.22),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        themeProvider.primaryColor.withOpacity(0.16),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Great work finishing the session.',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.4,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Review your strengths, spot the areas to refine, and jump into another round when you are ready.',
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
              const SizedBox(height: 14),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // Success icon + title
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: themeProvider.primaryColor, width: 2),
                                color: themeProvider.primaryColor.withOpacity(0.1),
                              ),
                              child: Icon(Icons.check_circle_rounded,
                                  color: themeProvider.primaryColor, size: 44),
                            ),
                            const SizedBox(height: 16),
                            const Text('Session Complete!',
                                style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -0.5)),
                            const SizedBox(height: 8),
                            Text(
                              summary.sessionSummary,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 14, color: Color(0xFFDDC1AE)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeProvider.primaryColor.withOpacity(0.15),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: BorderSide(color: themeProvider.primaryColor.withOpacity(0.4)),
                            ),
                          ),
                          icon: Icon(Icons.format_quote, color: themeProvider.primaryColor),
                          label: Text('Useful Expressions',
                              style: TextStyle(color: themeProvider.primaryColor,
                                  fontSize: 15, fontWeight: FontWeight.w600)),
                          onPressed: () => _showPhrasesSheet(context, themeProvider),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Scores section
                      const Text('Your Scores',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.5)),
                      const SizedBox(height: 12),
                      _ScoreBar(
                        label: 'Grammar',
                        score: summary.grammarScore,
                        progressColor: themeProvider.primaryColor,
                        icon: Icons.spellcheck,
                        themeProvider: themeProvider,
                      ),
                      _ScoreBar(
                        label: 'Vocabulary',
                        score: summary.vocabularyScore,
                        progressColor: const Color(0xFF88CEFF),
                        icon: Icons.menu_book_outlined,
                        themeProvider: themeProvider,
                      ),
                      _ScoreBar(
                        label: 'Pronunciation',
                        score: summary.pronunciationScore,
                        progressColor: const Color(0xFFC0C1FF),
                        icon: Icons.record_voice_over,
                        themeProvider: themeProvider,
                      ),
                      const SizedBox(height: 24),

                      // Mistakes
                      if (summary.mistakes.isNotEmpty) ...[
                        const Text('Areas to Improve',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -0.5)),
                        const SizedBox(height: 12),
                        _buildGlassCard(
                          themeProvider,
                          child: Column(
                            children: summary.mistakes
                                .map((m) => Padding(
                                      padding:
                                          const EdgeInsets.symmetric(vertical: 5),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.circle,
                                              size: 7,
                                              color: themeProvider.primaryColor),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(m,
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Color(0xFFDDC1AE))),
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Focus areas
                      if (summary.focusAreas.isNotEmpty) ...[
                        const Text('Focus Next Session On',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -0.5)),
                        const SizedBox(height: 12),
                        _buildGlassCard(
                          themeProvider,
                          child: Column(
                            children: summary.focusAreas
                                .map((f) => Padding(
                                      padding:
                                          const EdgeInsets.symmetric(vertical: 5),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.arrow_forward_ios,
                                              size: 12,
                                              color: themeProvider.primaryColor),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(f,
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Color(0xFFDDC1AE))),
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Session Feedback card
                      _buildGlassCard(
                        themeProvider,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.lightbulb_outline,
                                color: Color(0xFF88CEFF), size: 22),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Session Feedback',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                  const SizedBox(height: 6),
                                  Text(summary.improvement,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          height: 1.5,
                                          color: Color(0xFFDDC1AE))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Streak card
                      _buildGlassCard(
                        themeProvider,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: themeProvider.primaryColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.local_fire_department,
                                  color: themeProvider.primaryColor, size: 28),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Streak Extended!',
                                    style: TextStyle(
                                        color: Color(0xFFDDC1AE), fontSize: 12)),
                                Text('$streak sessions',
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w800,
                                        color: themeProvider.primaryColor)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Back to Home button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.of(context).popUntil((r) => r.isFirst),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeProvider.primaryColor,
                            foregroundColor: const Color(0xFF2F1500),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          child: const Text('Back to Home',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Practice Again button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () =>
                              Navigator.of(context).popUntil((r) => r.isFirst),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            side: BorderSide(
                                color: Colors.white.withOpacity(0.2)),
                          ),
                          child: const Text('Practice Again',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPhrasesSheet(BuildContext context, ThemeProvider themeProvider) {
    final phrases = ScenarioPhrases.getPhrasesForIcon(iconName);
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (ctx, scrollController) => Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(Icons.format_quote, color: themeProvider.primaryColor),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text('Useful Expressions',
                        style: TextStyle(color: Colors.white,
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Phrases you can use in this type of conversation',
                  style: TextStyle(color: Colors.white38, fontSize: 13)),
            ),
            const SizedBox(height: 12),
            const Divider(color: Colors.white12),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: phrases.length,
                itemBuilder: (ctx, index) {
                  final phrase = phrases[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: themeProvider.primaryColor.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(phrase.expression,
                            style: TextStyle(
                                color: themeProvider.primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(phrase.meaning,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 13)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.format_quote,
                                  color: Colors.white24, size: 14),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(phrase.example,
                                    style: const TextStyle(
                                        color: Colors.white54,
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassCard(ThemeProvider themeProvider,
      {required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: themeProvider.primaryColor.withOpacity(0.2)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _ScoreBar extends StatelessWidget {
  final String label;
  final int score;
  final Color progressColor;
  final IconData icon;
  final ThemeProvider themeProvider;

  const _ScoreBar({
    required this.label,
    required this.score,
    required this.progressColor,
    required this.icon,
    required this.themeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: progressColor, size: 16),
                    const SizedBox(width: 8),
                    Text(label.toUpperCase(),
                        style: const TextStyle(
                            color: Color(0xFFDDC1AE),
                            fontSize: 11,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w600)),
                    const Spacer(),
                    Text('$score',
                        style: TextStyle(
                            color: progressColor,
                            fontSize: 28,
                            fontWeight: FontWeight.w800)),
                    Text('/10',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: score / 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: progressColor,
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: [
                          BoxShadow(
                              color: progressColor.withOpacity(0.4),
                              blurRadius: 6)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}







