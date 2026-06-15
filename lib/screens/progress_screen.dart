import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/backend.dart';
import '../core/supabase_service.dart';
import '../providers/theme_provider.dart';
import '../widgets/gradient_bottom_nav.dart';
import 'edit_profile_screen.dart';
import 'index.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int _streak = 0;
  List<Map<String, dynamic>> _activityLog = [];
  List<Map<String, dynamic>> _enrichedSessions = [];
  bool _loadingExtra = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ChatProvider>(context, listen: false);
      if (!provider.isLoadingHistory && provider.hasUsername) {
        provider.loadHistory();
      }
      provider.loadExerciseHistory();
    });
    _loadExtraData();
  }

  Future<void> _loadExtraData() async {
    if (mounted) setState(() => _loadingExtra = true);
    final supaId = SupabaseService.currentUserId;
    if (supaId != null) {
      final streak = await SupabaseService.getLoginStreak(supaId);
      final log = await SupabaseService.getActivityLog(supaId);
      final sessions = await SupabaseService.getEnrichedSessions(supaId);
      if (!mounted) return;
      setState(() {
        _streak = streak;
        _activityLog = log;
        _enrichedSessions = sessions;
        _loadingExtra = false;
      });
    } else {
      if (mounted) setState(() => _loadingExtra = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/progress.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.75),
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
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text('FluentlyDZ',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: themeProvider.primaryColor)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.local_fire_department,
                              size: 16, color: themeProvider.primaryColor),
                          const SizedBox(width: 6),
                          Text(
                            '$_streak Days',
                            style: TextStyle(
                              color: themeProvider.primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Progress',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Consistency is the key to fluency.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFDDC1AE),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: Consumer<ChatProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoadingHistory) {
                      return Center(
                        child: CircularProgressIndicator(
                            color: themeProvider.primaryColor),
                      );
                    }

                    final history = provider.sessionHistory;

                    if (history.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bar_chart,
                                size: 64,
                                color: Colors.white.withOpacity(0.2)),
                            const SizedBox(height: 16),
                            const Text('No sessions yet',
                                style: TextStyle(
                                    fontSize: 18, color: Color(0xFFDDC1AE))),
                            const SizedBox(height: 8),
                            const Text(
                              'Complete a conversation to see your progress',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.white38),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: _buildPeriodSwitch(themeProvider),
                          ),
                          const SizedBox(height: 12),
                          _StatsSummaryRow(
                              history: history,
                              themeProvider: themeProvider),
                          const SizedBox(height: 16),
                          _buildStreakBanner(themeProvider),
                          const SizedBox(height: 16),
                          const Text('Score History',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -0.5)),
                          const SizedBox(height: 12),
                          _buildChartCard(history, themeProvider),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _LegendDot(
                                  color: themeProvider.primaryColor,
                                  label: 'Grammar'),
                              const SizedBox(width: 16),
                              const _LegendDot(
                                  color: Color(0xFF88CEFF),
                                  label: 'Vocabulary'),
                              const SizedBox(width: 16),
                              const _LegendDot(
                                  color: Color(0xFFC0C1FF),
                                  label: 'Pronunciation'),
                            ],
                          ),
                              const SizedBox(height: 16),
                              _buildWeeklyActivityCard(themeProvider),
                              const SizedBox(height: 16),
                              _buildActivityLog(themeProvider),
                              const SizedBox(height: 16),
                              _buildSessionHistory(themeProvider),
                          const SizedBox(height: 28),
                          const Text('Past Sessions',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -0.5)),
                          const SizedBox(height: 12),
                          ...history.reversed.map((session) =>
                              _SessionCard(
                                  session: session,
                                  themeProvider: themeProvider)),
                          const SizedBox(height: 24),
                          const Text('Exercise Sessions',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -0.5)),
                          const SizedBox(height: 12),
                          if (provider.isLoadingExerciseHistory)
                            Padding(
                              padding: const EdgeInsets.all(32),
                              child: CircularProgressIndicator(
                                  color: themeProvider.primaryColor),
                            )
                          else if (provider.exerciseHistory.isEmpty)
                            _buildGlassCard(
                              themeProvider,
                              child: const Column(
                                children: [
                                  Icon(Icons.school_outlined,
                                      size: 48, color: Colors.white24),
                                  SizedBox(height: 12),
                                  Text('No exercise sessions yet',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFFDDC1AE))),
                                  SizedBox(height: 4),
                                  Text('Try the "Practice Exercises" feature',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white38),
                                      textAlign: TextAlign.center),
                                ],
                              ),
                            )
                          else
                            ...provider.exerciseHistory.reversed.map(
                                (result) => _ExerciseResultCard(
                                    result: result,
                                    themeProvider: themeProvider)),
                          const SizedBox(height: 40),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GradientBottomNavBar(
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/home');
          if (index == 1) Navigator.pushReplacementNamed(context, '/learn');
          if (index == 2) Navigator.pushReplacementNamed(context, '/community');
          if (index == 4) Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
        },
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

  Widget _buildHeroTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildChartCard(
      List<SessionRecord> history, ThemeProvider themeProvider) {
    return ClipRRect(
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
          child: _ScoreLineChart(
              history: history, themeProvider: themeProvider),
        ),
      ),
    );
  }

  Widget _buildPeriodSwitch(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.45),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: themeProvider.primaryColor.withOpacity(0.9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'WEEK',
              style: TextStyle(
                color: Color(0xFF2F1500),
                fontWeight: FontWeight.w800,
                fontSize: 12,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              'MONTH',
              style: TextStyle(
                color: Colors.white.withOpacity(0.45),
                fontWeight: FontWeight.w700,
                fontSize: 12,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyActivityCard(ThemeProvider themeProvider) {
    final rows = _activityLog.take(7).toList();
    final values = rows
        .map((row) {
          final scenarios = (row['scenarios_done'] ?? 0) as num;
          final exercises = (row['exercises_done'] ?? 0) as num;
          final messages = (row['messages_sent'] ?? 0) as num;
          return scenarios.toDouble() * 12 +
              exercises.toDouble() * 10 +
              messages.toDouble() * 1.2;
        })
        .toList();

    while (values.length < 7) {
      values.add(0);
    }
    final maxValue = values.isEmpty
        ? 1.0
        : values.reduce((a, b) => a > b ? a : b).clamp(1.0, double.infinity);
    final labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return _buildGlassCard(
      themeProvider,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Weekly Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                'Avg ${values.reduce((a, b) => a + b) ~/ values.length} pts/day',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFDDC1AE),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final value = values[index];
                final ratio = (value / maxValue).clamp(0.08, 1.0);
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 90 * ratio,
                          decoration: BoxDecoration(
                            color: themeProvider.primaryColor.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          labels[index],
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFFDDC1AE),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakBanner(ThemeProvider themeProvider) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: themeProvider.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: themeProvider.primaryColor.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Text('🔥', style: TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$_streak Day Streak',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: themeProvider.primaryColor)),
                    Text(
                      _streak > 0
                          ? 'Keep it up!'
                          : 'Start your streak today!',
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFFDDC1AE)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityLog(ThemeProvider themeProvider) {
    final rows = _activityLog.take(7).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recent Activity',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.5)),
        const SizedBox(height: 12),
        if (_loadingExtra)
          Center(
              child: CircularProgressIndicator(
                  color: themeProvider.primaryColor))
        else if (rows.isEmpty)
          const Text('No activity recorded yet.',
              style: TextStyle(fontSize: 13, color: Colors.white38))
        else
          ...rows.map((row) {
            final scenariosDone = (row['scenarios_done'] ?? 0) as num;
            final exercisesDone = (row['exercises_done'] ?? 0) as num;
            final messagesSent = (row['messages_sent'] ?? 0) as num;
            final parts = <String>[];
            if (scenariosDone.toInt() > 0) {
              parts.add('${scenariosDone.toInt()} conversation(s)');
            }
            if (exercisesDone.toInt() > 0) {
              parts.add('${exercisesDone.toInt()} exercise session(s)');
            }
            if (messagesSent.toInt() > 0) {
              parts.add('${messagesSent.toInt()} messages');
            }
            if (parts.isEmpty) parts.add('Opened app');

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today,
                            color: themeProvider.primaryColor, size: 18),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${row['date'] ?? ''}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13)),
                              Text(parts.join(' · '),
                                  style: const TextStyle(
                                      color: Color(0xFFDDC1AE),
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildSessionHistory(ThemeProvider themeProvider) {
    final sessions = _enrichedSessions.take(10).toList();

    String formatDate(dynamic value) {
      if (value == null) return '';
      try {
        final dt = DateTime.parse(value.toString());
        return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
      } catch (_) {
        final text = value.toString();
        return text.length >= 10 ? text.substring(0, 10) : text;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Session History',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.5)),
        const SizedBox(height: 12),
        if (_loadingExtra)
          Center(
              child: CircularProgressIndicator(
                  color: themeProvider.primaryColor))
        else if (sessions.isEmpty)
          const Text('No sessions yet.',
              style: TextStyle(fontSize: 13, color: Colors.white38))
        else
          ...sessions.map((session) {
            final grammar = session['grammar_score'];
            final vocab = session['vocabulary_score'];
            final pronunciation = session['pronunciation_score'];
            final overall = session['overall_score'];
            final aiFeedback =
                (session['ai_feedback'] ?? '').toString();
            final scenario =
                (session['scenario'] ?? 'Session').toString();
            final difficulty =
                (session['difficulty'] ?? '').toString();
            final createdAt = formatDate(session['created_at']);

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
                      border: Border.all(
                          color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                scenario.isNotEmpty
                                    ? scenario
                                    : 'Session',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 14),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(difficulty,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFFDDC1AE))),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            _chip('🧠 Grammar: ${grammar?.toStringAsFixed(0) ?? '0'}%', themeProvider.primaryColor),
                            _chip('📖 Vocab: ${vocab?.toStringAsFixed(0) ?? '0'}%', const Color(0xFF88CEFF)),
                            _chip('🎤 Pronunciation: ${pronunciation?.toStringAsFixed(0) ?? '0'}%', const Color(0xFFC0C1FF)),
                          ],
                        ),
                        if (overall != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            'Overall: ${((overall as num).toDouble()).toStringAsFixed(0)}%',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: themeProvider.primaryColor,
                                fontSize: 13),
                          ),
                        ],
                        if (aiFeedback.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(aiFeedback,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  color: Color(0xFFDDC1AE))),
                        ],
                        const SizedBox(height: 4),
                        Text(createdAt,
                            style: const TextStyle(
                                fontSize: 11, color: Colors.white38)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(text,
          style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600)),
    );
  }
}

class _StatsSummaryRow extends StatelessWidget {
  final List<SessionRecord> history;
  final ThemeProvider themeProvider;
  const _StatsSummaryRow(
      {required this.history, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    final totalSessions = history.length;
    final avgMinutes = totalSessions * 15;
    final avgScore = history
            .map((s) => s.averageScore)
            .reduce((a, b) => a + b) /
        totalSessions;
    final latest = history.last;

    String levelLabel() {
      if (avgScore >= 8.5) return 'B2+';
      if (avgScore >= 7.0) return 'B1';
      if (avgScore >= 5.5) return 'A2+';
      return 'A1';
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'SESSIONS',
                value: '$totalSessions',
                subtitle: '+ active this week',
                icon: Icons.play_circle_fill,
                color: themeProvider.primaryColor,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                label: 'LEARNING TIME',
                value: '$avgMinutes min',
                subtitle: 'Estimated from sessions',
                icon: Icons.timer,
                color: const Color(0xFF88CEFF),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _StatCard(
          label: 'OVERALL SCORE',
          value: levelLabel(),
          subtitle: 'Last score ${latest.averageScore.toStringAsFixed(1)}/10',
          icon: Icons.auto_awesome,
          color: const Color(0xFFFFB77F),
          highlighted: true,
          fullWidth: true,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool highlighted;
  final bool fullWidth;

  const _StatCard({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.highlighted = false,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final card = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: highlighted
                ? const Color(0xFF2A1A0E).withOpacity(0.9)
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: highlighted
                  ? color.withOpacity(0.45)
                  : Colors.white.withOpacity(0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 1.1,
                      color: highlighted ? color : const Color(0xFFDDC1AE),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Icon(icon, color: color, size: 20),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: TextStyle(
                  fontSize: fullWidth ? 46 : 40,
                  fontWeight: FontWeight.w800,
                  color: highlighted ? color : Colors.white,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFDDC1AE),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (fullWidth) return card;
    return SizedBox(height: 148, child: card);
  }
}

class _ScoreLineChart extends StatelessWidget {
  final List<SessionRecord> history;
  final ThemeProvider themeProvider;
  const _ScoreLineChart(
      {required this.history, required this.themeProvider});

  List<FlSpot> _spots(List<int> scores) {
    return scores
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final grammarSpots =
        _spots(history.map((s) => s.grammarScore).toList());
    final vocabSpots =
        _spots(history.map((s) => s.vocabularyScore).toList());
    final pronSpots =
        _spots(history.map((s) => s.pronunciationScore).toList());

    return SizedBox(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.only(right: 16, top: 8),
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: 10,
            gridData: FlGridData(
              show: true,
              horizontalInterval: 2,
              getDrawingHorizontalLine: (_) => FlLine(
                color: Colors.white.withOpacity(0.08),
                strokeWidth: 1,
              ),
              drawVerticalLine: false,
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                left: BorderSide(
                    color: Colors.white.withOpacity(0.15)),
                bottom: BorderSide(
                    color: Colors.white.withOpacity(0.15)),
                top: const BorderSide(color: Colors.transparent),
                right: const BorderSide(color: Colors.transparent),
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 2,
                  reservedSize: 28,
                  getTitlesWidget: (value, _) => Text(
                    '${value.toInt()}',
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFFDDC1AE)),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, _) {
                    final index = value.toInt();
                    if (index < 0 || index >= history.length) {
                      return const SizedBox();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        history[index].formattedDate,
                        style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFFDDC1AE)),
                      ),
                    );
                  },
                ),
              ),
              rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false)),
            ),
            lineBarsData: [
              _line(grammarSpots, themeProvider.primaryColor),
              _line(vocabSpots, const Color(0xFF88CEFF)),
              _line(pronSpots, const Color(0xFFC0C1FF)),
            ],
          ),
        ),
      ),
    );
  }

  LineChartBarData _line(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 2.5,
      dotData: FlDotData(
        show: true,
        getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
          radius: 4,
          color: color,
          strokeWidth: 0,
        ),
      ),
      belowBarData: BarAreaData(
        show: true,
        color: color.withOpacity(0.05),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 10,
            height: 10,
            decoration:
                BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                fontSize: 12, color: Color(0xFFDDC1AE))),
      ],
    );
  }
}

class _SessionCard extends StatelessWidget {
  final SessionRecord session;
  final ThemeProvider themeProvider;
  const _SessionCard(
      {required this.session, required this.themeProvider});

  Color _scoreColor(int score) {
    if (score >= 8) return const Color(0xFF2ECC71);
    if (score >= 5) return const Color(0xFF88CEFF);
    return const Color(0xFFEF5350);
  }

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
              border:
                  Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(session.formattedDate,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _scoreColor(
                                session.averageScore.round())
                            .withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Avg ${session.averageScore.toStringAsFixed(1)}/10',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _scoreColor(
                                session.averageScore.round())),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _ScoreChip(
                        label: 'G',
                        score: session.grammarScore,
                        color: themeProvider.primaryColor),
                    const SizedBox(width: 6),
                    const _ScoreChip(
                        label: 'V',
                        score: 0,
                        color: Color(0xFF88CEFF),
                        overrideScore: true),
                    const SizedBox(width: 6),
                    const _ScoreChip(
                        label: 'P',
                        score: 0,
                        color: Color(0xFFC0C1FF),
                        overrideScore: true),
                  ],
                ),
                const SizedBox(height: 10),
                if (session.sessionSummary.isNotEmpty)
                  Text(session.sessionSummary,
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFFDDC1AE)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                if (session.mistakes.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: session.mistakes
                        .map((m) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF5350)
                                    .withOpacity(0.1),
                                borderRadius:
                                    BorderRadius.circular(20),
                                border: Border.all(
                                    color: const Color(0xFFEF5350)
                                        .withOpacity(0.2)),
                              ),
                              child: Text(m,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFFEF5350))),
                            ))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreChip extends StatelessWidget {
  final String label;
  final int score;
  final Color color;
  final bool overrideScore;

  const _ScoreChip({
    required this.label,
    required this.score,
    required this.color,
    this.overrideScore = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        overrideScore ? '$label: —' : '$label: $score/10',
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color),
      ),
    );
  }
}

class _ExerciseResultCard extends StatelessWidget {
  final ExerciseResult result;
  final ThemeProvider themeProvider;
  const _ExerciseResultCard(
      {required this.result, required this.themeProvider});

  Color _scoreColor(double percent) {
    if (percent >= 70) return const Color(0xFF2ECC71);
    if (percent >= 50) return const Color(0xFF88CEFF);
    return const Color(0xFFEF5350);
  }

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
              border:
                  Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(result.formattedDate,
                        style: const TextStyle(
                            fontSize: 13, color: Color(0xFFDDC1AE))),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _scoreColor(result.scorePercent)
                            .withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${result.scorePercent.toStringAsFixed(0)}%',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _scoreColor(result.scorePercent)),
                      ),
                    ),
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
                    widthFactor: result.scorePercent / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _scoreColor(result.scorePercent),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text('${result.correct} of ${result.total} correct',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
                if (result.categoryScores.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: result.categoryScores.entries
                        .map((entry) {
                      final color =
                          _scoreColor(entry.value.toDouble());
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: color.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_getTypeIcon(entry.key),
                                style:
                                    const TextStyle(fontSize: 13)),
                            const SizedBox(width: 4),
                            Text(
                              '${entry.value.toStringAsFixed(0)}%',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: color),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTypeIcon(String type) {
    switch (type) {
      case 'grammar':
        return '📝';
      case 'vocabulary':
        return '📚';
      case 'fill_blank':
        return '✏️';
      case 'word_order':
        return '🔀';
      default:
        return '📝';
    }
  }
}
