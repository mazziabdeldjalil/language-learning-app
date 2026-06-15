import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:language_learning_app/core/backend.dart';
import '../core/supabase_service.dart';
import '../core/supabase_config.dart';
import '../providers/theme_provider.dart';
import '../widgets/gradient_bottom_nav.dart';
import 'progress_screen.dart';
import 'exercises_screen.dart';
import 'login_screen.dart';
import 'community_screen.dart';
import 'admin_screen.dart';
import 'index.dart' show PronunciationScreen, LearnScreen, SettingsScreen;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isAdmin = false;
  int _navIndex = 0;

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    if (mounted) {
      Provider.of<ChatProvider>(context, listen: false).clearAll();
    }
    await SupabaseConfig.client.auth.signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _checkAdmin();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatProvider>(context, listen: false).initialize();
    });
  }

  Future<void> _checkAdmin() async {
    final admin = await SupabaseService.isAdmin();
    if (mounted) setState(() => _isAdmin = admin);
  }

  void _onNavTap(int index) {
    if (index == _navIndex) return;
    switch (index) {
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const LearnScreen()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const CommunityScreen()));
        break;
      case 3:
        Provider.of<ChatProvider>(context, listen: false).loadHistory();
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgressScreen()));
        break;
      case 4:
        _showProfileSheet();
        break;
    }
  }

  void _showProfileSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Consumer<ChatProvider>(
                builder: (context, provider, _) => Text(
                  provider.userId.isNotEmpty ? provider.userId : 'My Profile',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),

              // Theme color picker
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Theme Color',
                    style: TextStyle(
                        color: Color(0xFFDDC1AE),
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _colorSwatch(context, themeProvider, 0, const Color(0xFFFF6B6B), 'Red'),
                  _colorSwatch(context, themeProvider, 1, const Color(0xFFFF8A00), 'Orange'),
                  _colorSwatch(context, themeProvider, 2, const Color(0xFFF39C12), 'Yellow'),
                  _colorSwatch(context, themeProvider, 3, const Color(0xFF2ECC71), 'Green'),
                  _colorSwatch(context, themeProvider, 4, const Color(0xFF4ECDC4), 'Teal'),
                  _colorSwatch(context, themeProvider, 5, const Color(0xFF3498DB), 'Blue'),
                  _colorSwatch(context, themeProvider, 6, const Color(0xFF00B3FC), 'Sky'),
                  _colorSwatch(context, themeProvider, 7, const Color(0xFF7C83FD), 'Violet'),
                  _colorSwatch(context, themeProvider, 8, const Color(0xFF9B59B6), 'Purple'),
                  _colorSwatch(context, themeProvider, 9, const Color(0xFFC0C1FF), 'Lavender'),
                  _colorSwatch(context, themeProvider, 10, const Color(0xFFE74C3C), 'Crimson'),
                  _colorSwatch(context, themeProvider, 11, const Color(0xFF1ABC9C), 'Mint'),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.white12),
              const SizedBox(height: 8),

              if (_isAdmin)
                ListTile(
                  leading: Icon(Icons.admin_panel_settings,
                      color: themeProvider.primaryColor),
                  title: const Text('Admin Panel',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const AdminScreen()));
                  },
                ),
              ListTile(
                leading: const Icon(Icons.logout, color: Color(0xFFFFB4AB)),
                title: const Text('Logout',
                    style: TextStyle(color: Color(0xFFFFB4AB))),
                onTap: () {
                  Navigator.pop(context);
                  _logout();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _colorSwatch(BuildContext context, ThemeProvider themeProvider,
      int index, Color color, String name) {
    final isSelected = themeProvider.primaryColor == color;
    return GestureDetector(
      onTap: () {
        themeProvider.setColorByIndex(index);
        Navigator.pop(context);
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 2.5,
              ),
              boxShadow: isSelected
                  ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 8)]
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : null,
          ),
          const SizedBox(height: 4),
          Text(name,
              style: TextStyle(
                  fontSize: 9,
                  color: isSelected ? color : Colors.white38)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final provider = context.watch<ChatProvider>();
    final streak = provider.userProfile?.sessionsCompleted ?? 0;
    final username = provider.userId.isNotEmpty ? provider.userId : 'Learner';
    final sessions = provider.sessionHistory.length;
    final lastScore = sessions > 0
      ? provider.sessionHistory.last.averageScore * 10
      : 0.0;
    final dailyGoalMinutes = 20;
    final completedMinutes = (sessions * 6).clamp(0, dailyGoalMinutes);
    final dailyProgress = dailyGoalMinutes == 0
      ? 0.0
      : (completedMinutes / dailyGoalMinutes).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/dashboard.png'),
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
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'LinguistAI',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: themeProvider.primaryColor,
                      ),
                    ),
                    Row(
                      children: [
                        _buildChip(
                          Icons.local_fire_department,
                          '$streak days',
                          themeProvider.primaryColor,
                        ),
                        const SizedBox(width: 8),
                        // Profile chip hidden for now
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(
                            Icons.settings_rounded,
                            color: themeProvider.primaryColor,
                            size: 24,
                          ),
                          onPressed: () {
                            // Open profile sheet which contains theme swatches and logout
                            _showProfileSheet();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Scrollable Body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // Welcome hero section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: themeProvider.primaryColor.withOpacity(0.3),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              themeProvider.primaryColor.withOpacity(0.15),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good day, $username!',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Ready to master English today?',
                              style: TextStyle(fontSize: 15, color: Color(0xFFDDC1AE)),
                            ),
                            const SizedBox(height: 14),
                            _buildDailyGoalCard(
                              themeProvider: themeProvider,
                              progress: dailyProgress,
                              completedMinutes: completedMinutes,
                              totalMinutes: dailyGoalMinutes,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Metrics removed per request (Words Learned, Accuracy, Practice, Streak)
                      const SizedBox(height: 6),

                      // Practice Tip Card
                      Consumer<ChatProvider>(
                        builder: (context, p, _) {
                          final mistakes = p.userProfile?.frequentWordMistakes ?? [];
                          if (mistakes.isEmpty) return const SizedBox.shrink();
                          final top = mistakes.first;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildGlassCard(
                              themeProvider,
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: themeProvider.primaryColor.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text('✍️', style: TextStyle(fontSize: 20)),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Practice tip',
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                                color: themeProvider.primaryColor)),
                                        const SizedBox(height: 4),
                                        RichText(
                                          text: TextSpan(
                                            style: const TextStyle(fontSize: 13, color: Color(0xFFDDC1AE)),
                                            children: [
                                              const TextSpan(text: 'You often write '),
                                              TextSpan(
                                                text: '"${top.wrong}"',
                                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                              ),
                                              const TextSpan(text: ' — try '),
                                              TextSpan(
                                                text: '"${top.correct}"',
                                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      // Word of the Day Card
                      Consumer<ChatProvider>(
                        builder: (context, p, _) {
                          final difficulty = p.selectedDifficulty?.apiValue ?? 'beginner';
                          final word = _getWordOfTheDay(difficulty, p.userId);
                          if (word == null) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildGlassCard(
                              themeProvider,
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF88CEFF).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text('💡', style: TextStyle(fontSize: 20)),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Word of the day',
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF88CEFF))),
                                        const SizedBox(height: 4),
                                        RichText(
                                          text: TextSpan(
                                            style: const TextStyle(fontSize: 13, color: Color(0xFFDDC1AE)),
                                            children: [
                                              TextSpan(
                                                text: '${word['word']} ',
                                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                              ),
                                              TextSpan(text: '— ${word['definition']}'),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '"${word['example']}"',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFFDDC1AE),
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 8),

                      // START CONVERSATION Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<ChatProvider>().resetConversation();
                            Navigator.pushNamed(context, '/scenario');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeProvider.primaryColor,
                            foregroundColor: const Color(0xFF2F1500),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.play_circle_fill, size: 28),
                              const SizedBox(width: 12),
                              const Text('START PRACTICE',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Quick Actions Label removed as requested
                      const SizedBox(height: 8),

                      // Action Cards
                      // Hidden: Practice Exercises moved to Library screen
                      /* _buildActionCard(
                        themeProvider,
                        icon: Icons.school_outlined,
                        title: 'Practice Exercises',
                        subtitle: 'Sharpen grammar, vocab, and more',
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const ExercisesScreen())),
                      ), */
                      _buildActionCard(
                        themeProvider,
                        icon: Icons.record_voice_over,
                        title: 'How to Pronounce',
                        subtitle: 'Practice speaking and pronunciation',
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const PronunciationScreen())),
                      ),
                      _buildActionCard(
                        themeProvider,
                        icon: Icons.menu_book,
                        title: 'Learn',
                        subtitle: 'Stories, passages, grammar & idioms',
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const LearnScreen())),
                      ),
                      // Community card removed (accessible via bottom navigation)
                      if (_isAdmin)
                        _buildActionCard(
                          themeProvider,
                          icon: Icons.admin_panel_settings,
                          title: 'Admin Panel',
                          subtitle: 'Manage app administration',
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const AdminScreen())),
                          isHighlighted: true,
                        ),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GradientBottomNavBar(
        currentIndex: _navIndex,
        onTap: _onNavTap,
        hideProfile: true,
      ),
    );
  }

  Widget _buildChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildGlassCard(ThemeProvider themeProvider, {required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
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

  Widget _buildDailyGoalCard({
    required ThemeProvider themeProvider,
    required double progress,
    required int completedMinutes,
    required int totalMinutes,
  }) {
    final pct = (progress * 100).round();
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Daily Goal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '$pct%',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: themeProvider.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  color: themeProvider.primaryColor,
                  backgroundColor: Colors.white.withOpacity(0.15),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '$completedMinutes/$totalMinutes minutes completed',
                style: const TextStyle(
                  color: Color(0xFFDDC1AE),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFFDDC1AE),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.7,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(
    ThemeProvider themeProvider, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isHighlighted = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isHighlighted
                      ? themeProvider.primaryColor.withOpacity(0.6)
                      : Colors.white.withOpacity(0.06),
                ),
                boxShadow: [
                  BoxShadow(
                    color: themeProvider.primaryColor.withOpacity(isHighlighted ? 0.10 : 0.04),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: themeProvider.primaryColor.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: themeProvider.primaryColor.withOpacity(0.12)),
                    ),
                    child: Icon(icon, color: themeProvider.primaryColor, size: 26),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 16)),
                        const SizedBox(height: 6),
                        Text(subtitle,
                            style: const TextStyle(
                                color: Color(0xFFDDC1AE), fontSize: 13)),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.white.withOpacity(0.45)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Map<String, String>? _getWordOfTheDay(String difficulty, String userId) {
    final words = _wordLists[difficulty] ?? _wordLists['beginner']!;
    if (words.isEmpty) return null;
    final dayOfYear =
        DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    final userHash = userId.codeUnits.fold(0, (a, b) => a + b);
    final index = (dayOfYear + userHash) % words.length;
    return words[index];
  }

  static const Map<String, List<Map<String, String>>> _wordLists = {
    'beginner': [
      {'word': 'greet', 'definition': 'to say hello to someone', 'example': 'I greeted my teacher at the door.'},
      {'word': 'purchase', 'definition': 'to buy something', 'example': 'She purchased a new book yesterday.'},
      {'word': 'assist', 'definition': 'to help someone', 'example': 'Can you assist me with this bag?'},
      {'word': 'reply', 'definition': 'to answer or respond', 'example': 'Please reply to my message soon.'},
      {'word': 'request', 'definition': 'to ask for something politely', 'example': 'He requested a glass of water.'},
      {'word': 'prefer', 'definition': 'to like one thing more than another', 'example': 'I prefer tea over coffee.'},
      {'word': 'arrive', 'definition': 'to reach a place', 'example': 'The bus arrives at 8 AM.'},
      {'word': 'suggest', 'definition': 'to give an idea or recommendation', 'example': 'She suggested going to the park.'},
      {'word': 'explain', 'definition': 'to make something clear', 'example': 'Can you explain this word to me?'},
      {'word': 'decide', 'definition': 'to make a choice', 'example': 'We decided to eat at home tonight.'},
    ],
    'intermediate': [
      {'word': 'negotiate', 'definition': 'to discuss to reach an agreement', 'example': 'They negotiated the price for an hour.'},
      {'word': 'emphasize', 'definition': 'to give special importance to something', 'example': 'She emphasized the importance of punctuality.'},
      {'word': 'demonstrate', 'definition': 'to show how something works', 'example': 'He demonstrated the new software to the team.'},
      {'word': 'accomplish', 'definition': 'to successfully complete something', 'example': 'She accomplished all her goals this year.'},
      {'word': 'summarize', 'definition': 'to give a brief account of the main points', 'example': 'Please summarize the report in two sentences.'},
      {'word': 'evaluate', 'definition': 'to judge or assess something carefully', 'example': 'The manager evaluated each candidate fairly.'},
      {'word': 'acknowledge', 'definition': 'to recognize or admit something', 'example': 'He acknowledged the mistake immediately.'},
      {'word': 'collaborate', 'definition': 'to work together with others', 'example': 'The two teams collaborated on the project.'},
      {'word': 'elaborate', 'definition': 'to explain in more detail', 'example': 'Could you elaborate on your last point?'},
      {'word': 'anticipate', 'definition': 'to expect something before it happens', 'example': 'We anticipated the questions and prepared answers.'},
    ],
    'advanced': [
      {'word': 'articulate', 'definition': 'to express ideas clearly and effectively', 'example': 'She articulated her concerns in a calm manner.'},
      {'word': 'ambiguous', 'definition': 'open to more than one interpretation', 'example': 'The instructions were ambiguous and caused confusion.'},
      {'word': 'concise', 'definition': 'giving information clearly using few words', 'example': 'His report was concise but covered all key points.'},
      {'word': 'pragmatic', 'definition': 'dealing with things sensibly and realistically', 'example': 'A pragmatic approach works better than an idealistic one.'},
      {'word': 'nuance', 'definition': 'a subtle difference in meaning or expression', 'example': 'Understanding nuance is key to fluency.'},
      {'word': 'coherent', 'definition': 'logical and consistent, easy to understand', 'example': 'Her argument was coherent and well-structured.'},
      {'word': 'initiative', 'definition': 'the ability to act independently without prompting', 'example': 'He showed initiative by proposing a new solution.'},
      {'word': 'perseverance', 'definition': 'continued effort despite difficulty', 'example': 'Her perseverance paid off after years of practice.'},
      {'word': 'eloquent', 'definition': 'fluent and persuasive in speech or writing', 'example': 'The speaker gave an eloquent presentation.'},
      {'word': 'discrepancy', 'definition': 'a difference or inconsistency between things', 'example': 'There was a discrepancy between the two reports.'},
    ],
  };
}
