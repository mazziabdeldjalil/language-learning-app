import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/theme_provider.dart';
import 'login_screen.dart';

class WelcomeToEnglishAIScreen extends StatefulWidget {
  const WelcomeToEnglishAIScreen({super.key});

  @override
  State<WelcomeToEnglishAIScreen> createState() => _WelcomeToEnglishAIScreenState();
}

class _WelcomeToEnglishAIScreenState extends State<WelcomeToEnglishAIScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  Widget _buildOnboardPage({required String title, required String body, required ThemeProvider themeProvider}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Text(
          body,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.white70, height: 1.4),
        ),
        const SizedBox(height: 14),
        Container(
          width: 120,
          height: 6,
          decoration: BoxDecoration(
            color: themeProvider.primaryColor.withOpacity(0.18),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_welcome', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/onboarding_bg.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.72),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                        child: Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.12),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 112,
                                height: 112,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        themeProvider.primaryColor.withOpacity(0.9),
                                        const Color(0xFFC0C1FF),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: themeProvider.primaryColor.withOpacity(0.28),
                                        blurRadius: 28,
                                        spreadRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.school_rounded,
                                      size: 54,
                                      color: Color(0xFF613100),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),

                              SizedBox(
                                height: 220,
                                child: PageView(
                                  controller: _pageController,
                                  onPageChanged: (idx) => setState(() => _currentPage = idx),
                                  children: [
                                    _buildOnboardPage(
                                      title: 'FluentlyDZ',
                                      body: 'Your personalized coach is ready. Tap Next to learn more about the experience.',
                                      themeProvider: themeProvider,
                                    ),
                                    _buildOnboardPage(
                                      title: 'Practice with Real Scenarios',
                                      body: 'Role-play real conversations and get personalized feedback.',
                                      themeProvider: themeProvider,
                                    ),
                                    _buildOnboardPage(
                                      title: 'Track Your Progress',
                                      body: 'Daily goals, streaks and performance insights to keep you motivated.',
                                      themeProvider: themeProvider,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(3, (i) {
                                  final active = i == _currentPage;
                                  return Container(
                                    width: active ? 28 : 8,
                                    height: 8,
                                    margin: const EdgeInsets.symmetric(horizontal: 6),
                                    decoration: BoxDecoration(
                                      color: active ? themeProvider.primaryColor : Colors.white.withOpacity(0.18),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  );
                                }),
                              ),

                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: _currentPage == 0 ? null : () {
                                      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                                    },
                                    child: Text('Back', style: TextStyle(color: Colors.white70)),
                                  ),
                                  Row(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          // Skip to login
                                          _finishOnboarding();
                                        },
                                        child: Text('Skip', style: TextStyle(color: themeProvider.primaryColor, fontWeight: FontWeight.w700)),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (_currentPage < 2) {
                                            _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                                          } else {
                                            // Last page -> go to Login
                                            _finishOnboarding();
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: themeProvider.primaryColor,
                                        ),
                                        child: Text(_currentPage < 2 ? 'Next' : 'Get Started', style: const TextStyle(color: Color(0xFF613100))),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
