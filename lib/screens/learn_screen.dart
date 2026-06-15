import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/learn_content.dart';
import 'exercises_screen.dart';
import '../providers/theme_provider.dart';
import '../widgets/help_dialog.dart';
import '../data/vocabulary_dictionary.dart';
import 'edit_profile_screen.dart';
import '../services/gcp_tts_service.dart';
import '../widgets/gradient_bottom_nav.dart';
import '../services/library_service.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  int _passageCount = 0;
  int _storyCount = 0;
  int _childrenCount = 0;
  int _idiomCount = 0;
  int _grammarCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    final results = await Future.wait([
      LibraryService.fetchPassages(),
      LibraryService.fetchStories(),
      LibraryService.fetchChildrenStories(),
      LibraryService.fetchIdioms(),
      LibraryService.fetchGrammarGuides(),
    ]);
    if (mounted) {
      setState(() {
        _passageCount = results[0].length;
        _storyCount = results[1].length;
        _childrenCount = results[2].length;
        _idiomCount = results[3].length;
        _grammarCount = results[4].length;
      });
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
            image: const AssetImage('assets/images/library.png'),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 4),
                        Text('FluentlyDZ',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                                color: themeProvider.primaryColor)),
                      ],
                    ),
                    TextButton(
                      onPressed: () => showHelpDialog(context),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.06),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Flexible(
                      child: Text(
                        'Your learning library',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    Text(
                      'Browse and practice',
                      style: TextStyle(
                        color: Color(0xFFDDC1AE),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const SizedBox(height: 4),
                    Container(
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
                        children: [
                          const Text(
                            'Library',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.8,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Your personal knowledge vault and study hub.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFDDC1AE),
                              height: 1.4,
                            ),
                          ),
                          // Search and filter tabs removed
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        const Text(
                          'Recommended for You',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.6,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '',
                          style: TextStyle(
                            color: themeProvider.primaryColor,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _CategoryCard(
                      icon: Icons.menu_book_rounded,
                      label: 'Reading Passages',
                      subtitle: '$_passageCount passages · Beginner to Advanced',
                      color: const Color(0xFF88CEFF),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _PassageListScreen())),
                    ),
                    _CategoryCard(
                      icon: Icons.auto_stories_rounded,
                      label: 'Short Stories',
                      subtitle: '$_storyCount stories · Beginner to Advanced',
                      color: const Color(0xFF2ECC71),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _StoryListScreen())),
                    ),
                    _CategoryCard(
                      icon: Icons.child_care_rounded,
                      label: "Children's Stories",
                      subtitle: '$_childrenCount fables · Beginner friendly',
                      color: const Color(0xFFFF8A00),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _ChildrenStoryListScreen())),
                    ),
                    _CategoryCard(
                      icon: Icons.format_quote_rounded,
                      label: 'English Idioms',
                      subtitle: '$_idiomCount idioms & expressions with meaning & examples',
                      color: const Color(0xFFFFD700),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _IdiomListScreen())),
                    ),
                    _CategoryCard(
                      icon: Icons.rule_rounded,
                      label: 'Grammar Guides',
                      subtitle: '$_grammarCount guides · Common rules explained',
                      color: const Color(0xFFC0C1FF),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _GrammarListScreen())),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Practice Exercises',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildLibraryActionCard(
                      themeProvider,
                      icon: Icons.school_outlined,
                      title: 'Practice Exercises',
                      subtitle: 'Sharpen grammar, vocab, and more',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ExercisesScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GradientBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/home');
          if (index == 2) Navigator.pushReplacementNamed(context, '/community');
          if (index == 3) Navigator.pushReplacementNamed(context, '/progress');
          if (index == 4) Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
        },
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 26),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(label,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(subtitle,
                            style: const TextStyle(
                                color: Color(0xFFDDC1AE), fontSize: 12)),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded,
                      color: Colors.white.withOpacity(0.3)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _difficultyBadge(Difficulty d) {
  final labels = {
    Difficulty.beginner: ('Beginner', const Color(0xFF2ECC71)),
    Difficulty.intermediate: ('Intermediate', const Color(0xFF88CEFF)),
    Difficulty.advanced: ('Advanced', const Color(0xFFFF8A00)),
  };
  final entry = labels[d]!;
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: entry.$2.withOpacity(0.15),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: entry.$2.withOpacity(0.4)),
    ),
    child: Text(entry.$1,
        style: TextStyle(
            color: entry.$2, fontSize: 11, fontWeight: FontWeight.w600)),
  );
}

class _ReaderScreen extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String body;
  final Widget? badge;
  final String? footer;
  final List<QuizQuestion> questions;

  const _ReaderScreen({
    required this.title,
    this.subtitle,
    required this.body,
    this.badge,
    this.footer,
    this.questions = const [],
  });

  @override
  State<_ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<_ReaderScreen> {
  bool _showQuiz = false;
  int _currentQuestion = 0;
  int? _selectedAnswer;
  bool _answered = false;
  int _score = 0;
  bool _quizComplete = false;
  bool _vocabMode = false;
  final GcpTtsService _tts = GcpTtsService();
  bool _isSpeaking = false;
  int _activeParagraphIndex = -1;
  List<String> _paragraphs = [];
  bool _ttsCancel = false;

  @override
  void initState() {
    super.initState();
    _paragraphs = widget.body
        .split('\n')
        .where((p) => p.trim().isNotEmpty)
        .toList();
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _speakParagraph(int index) async {
    if (index < 0 || index >= _paragraphs.length) return;
    _ttsCancel = false;
    await _tts.stop();
    if (mounted) setState(() { _isSpeaking = true; _activeParagraphIndex = index; });
    await _tts.speak(_paragraphs[index]);
    if (mounted) setState(() { _isSpeaking = false; _activeParagraphIndex = -1; });
  }

  Future<void> _speakFullStory() async {
    _ttsCancel = false;
    await _tts.stop();
    for (int i = 0; i < _paragraphs.length; i++) {
      if (_ttsCancel || !mounted) break;
      if (mounted) setState(() { _isSpeaking = true; _activeParagraphIndex = i; });
      await _tts.speak(_paragraphs[i]);
      if (_ttsCancel) break;
    }
    if (mounted) setState(() { _isSpeaking = false; _activeParagraphIndex = -1; });
  }

  Future<void> _stopSpeaking() async {
    _ttsCancel = true;
    await _tts.stop();
    if (mounted) setState(() { _isSpeaking = false; _activeParagraphIndex = -1; });
  }

  Widget _buildQuizSection(ThemeProvider themeProvider) {
    if (_quizComplete) {
      return Container(
        margin: const EdgeInsets.only(top: 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: themeProvider.primaryColor.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(
              _score == widget.questions.length ? Icons.star : Icons.check_circle,
              color: _score == widget.questions.length ? Colors.orange : const Color(0xFF2ECC71),
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              'Quiz Complete!',
              style: TextStyle(color: themeProvider.primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'You scored $_score out of ${widget.questions.length}',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: themeProvider.primaryColor),
              onPressed: () {
                setState(() {
                  _currentQuestion = 0;
                  _selectedAnswer = null;
                  _answered = false;
                  _score = 0;
                  _quizComplete = false;
                  _showQuiz = true;
                });
              },
              child: const Text('Try Again', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    final question = widget.questions[_currentQuestion];
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: themeProvider.primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.quiz, color: themeProvider.primaryColor, size: 18),
              const SizedBox(width: 8),
              Text(
                'Question ${_currentQuestion + 1} of ${widget.questions.length}',
                style: TextStyle(color: themeProvider.primaryColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(question.question, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ...List.generate(question.options.length, (i) {
            Color optionColor = Colors.white.withOpacity(0.07);
            Color textColor = Colors.white70;
            if (_answered) {
              if (i == question.correctIndex) {
                optionColor = const Color(0xFF2ECC71).withOpacity(0.2);
                textColor = const Color(0xFF2ECC71);
              } else if (i == _selectedAnswer) {
                optionColor = const Color(0xFFEF5350).withOpacity(0.2);
                textColor = const Color(0xFFEF5350);
              }
            } else if (i == _selectedAnswer) {
              optionColor = themeProvider.primaryColor.withOpacity(0.2);
              textColor = themeProvider.primaryColor;
            }
            return GestureDetector(
              onTap: _answered ? null : () => setState(() => _selectedAnswer = i),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: optionColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: textColor.withOpacity(0.3)),
                ),
                child: Text(question.options[i], style: TextStyle(color: textColor, fontSize: 14)),
              ),
            );
          }),
          if (_answered) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline, color: Colors.orange, size: 16),
                  const SizedBox(width: 8),
                  Flexible(child: Text(question.explanation, style: const TextStyle(color: Colors.white60, fontSize: 13))),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: themeProvider.primaryColor),
                onPressed: () {
                  setState(() {
                    if (_selectedAnswer == question.correctIndex) _score++;
                    if (_currentQuestion + 1 < widget.questions.length) {
                      _currentQuestion++;
                      _selectedAnswer = null;
                      _answered = false;
                    } else {
                      _quizComplete = true;
                    }
                  });
                },
                child: Text(
                  _currentQuestion + 1 < widget.questions.length ? 'Next Question' : 'See Results',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ] else if (_selectedAnswer != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: themeProvider.primaryColor),
                onPressed: () => setState(() => _answered = true),
                child: const Text('Submit Answer', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRichText(String text, ThemeProvider themeProvider) {
    if (!_vocabMode) {
      return Text(
        text,
        style: const TextStyle(
            color: Colors.white, fontSize: 16, height: 1.8),
      );
    }

    final List<InlineSpan> spans = [];
    final paragraphs = text.split('\n');

    for (int p = 0; p < paragraphs.length; p++) {
      final paragraph = paragraphs[p];
      if (paragraph.trim().isEmpty) {
        spans.add(const TextSpan(text: '\n\n'));
        continue;
      }

      final words = paragraph.split(' ');
      for (int w = 0; w < words.length; w++) {
        final word = words[w];
        final clean = word.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
        final entry = VocabularyDictionary.lookup(clean);

        if (entry != null) {
          spans.add(WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: GestureDetector(
              onTap: () => _showWordDefinition(word, clean, entry, themeProvider),
              child: Text(
                '${word}${w < words.length - 1 ? ' ' : ''}',
                style: TextStyle(
                  color: themeProvider.primaryColor,
                  fontSize: 16,
                  height: 1.8,
                  decoration: TextDecoration.underline,
                  decorationColor: themeProvider.primaryColor.withOpacity(0.5),
                ),
              ),
            ),
          ));
        } else {
          spans.add(TextSpan(
            text: '${word}${w < words.length - 1 ? ' ' : ''}',
            style: const TextStyle(
                color: Colors.white, fontSize: 16, height: 1.8),
          ));
        }
      }

      if (p < paragraphs.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
    }

    return RichText(text: TextSpan(children: spans));
  }

  void _showWordDefinition(String word, String clean, VocabEntry entry, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          clean,
          style: TextStyle(
              color: themeProvider.primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(entry.definition,
                style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.5)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.format_quote, color: Colors.white24, size: 14),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(entry.example,
                        style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                            fontStyle: FontStyle.italic)),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Got it',
                style: TextStyle(color: themeProvider.primaryColor)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1F0D),
        foregroundColor: Colors.white,
        title: Text(widget.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: themeProvider.primaryColor, fontSize: 16)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              _vocabMode ? Icons.text_fields : Icons.text_fields_outlined,
              color: _vocabMode ? themeProvider.primaryColor : Colors.white54,
            ),
            tooltip: 'Vocabulary Mode',
            onPressed: () => setState(() => _vocabMode = !_vocabMode),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.badge != null) ...[widget.badge!, const SizedBox(height: 12)],
            if (widget.subtitle != null) ...[
              Text(widget.subtitle!,
                  style: const TextStyle(
                      color: Color(0xFFDDC1AE),
                      fontSize: 13,
                      fontStyle: FontStyle.italic)),
              const SizedBox(height: 16),
            ],
            // TTS full story button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _isSpeaking
                    ? TextButton.icon(
                        onPressed: _stopSpeaking,
                        icon: const Icon(Icons.stop_circle, color: Colors.redAccent),
                        label: const Text('Stop', style: TextStyle(color: Colors.redAccent)),
                      )
                    : TextButton.icon(
                        onPressed: _speakFullStory,
                        icon: const Icon(Icons.play_circle_fill, color: Color(0xFF88CEFF)),
                        label: const Text('Read Aloud',
                            style: TextStyle(color: Color(0xFF88CEFF))),
                      ),
              ],
            ),
            const SizedBox(height: 8),

            // Paragraphs with per-paragraph TTS + highlight
            ...(_paragraphs.asMap().entries.map((entry) {
              final index = entry.key;
              final para = entry.value.trim();
              final isActive = _activeParagraphIndex == index;
              return GestureDetector(
                onTap: () {
                  if (_isSpeaking && isActive) {
                    _stopSpeaking();
                  } else {
                    _speakParagraph(index);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFF88CEFF).withOpacity(0.10)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isActive
                          ? const Color(0xFF88CEFF).withOpacity(0.35)
                          : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildRichText(para, themeProvider)),
                      const SizedBox(width: 6),
                      Icon(
                        isActive ? Icons.volume_up : Icons.volume_up_outlined,
                        color: isActive ? const Color(0xFF88CEFF) : Colors.white24,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              );
            }).toList()),
            if (widget.footer != null) ...[
              const SizedBox(height: 24),
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: themeProvider.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: themeProvider.primaryColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.lightbulb_rounded,
                            color: themeProvider.primaryColor, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(widget.footer!,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            if (widget.questions.isNotEmpty) ...[
              const SizedBox(height: 24),
              if (!_showQuiz)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeProvider.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.quiz, color: Colors.white),
                    label: const Text('Test Your Understanding', style: TextStyle(color: Colors.white, fontSize: 15)),
                    onPressed: () => setState(() => _showQuiz = true),
                  ),
                )
              else
                _buildQuizSection(themeProvider),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }
}

class _PassageListScreen extends StatefulWidget {
  const _PassageListScreen();
  @override
  State<_PassageListScreen> createState() => _PassageListScreenState();
}

class _PassageListScreenState extends State<_PassageListScreen> {
  Difficulty? _filter;
  List<PassageItem> _passages = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await LibraryService.fetchPassages();
    if (mounted) {
      setState(() {
        _passages = data;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final items = _filter == null
        ? _passages
        : _passages.where((p) => p.difficulty == _filter).toList();

    if (_loading) return const Scaffold(
      backgroundColor: Color(0xFF131313),
      body: Center(child: CircularProgressIndicator()),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1F0D),
        foregroundColor: Colors.white,
        title: Text('Reading Passages',
            style: TextStyle(color: themeProvider.primaryColor)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _DifficultyFilter(
              selected: _filter,
              onChanged: (d) => setState(() => _filter = d)),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final p = items[i];
                return _ListItemCard(
                  title: p.title,
                  meta: p.topic,
                  badge: _difficultyBadge(p.difficulty),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => _ReaderScreen(
                            title: p.title,
                            subtitle: p.topic,
                            body: p.body,
                            badge: _difficultyBadge(p.difficulty),
                          ))),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StoryListScreen extends StatefulWidget {
  const _StoryListScreen();
  @override
  State<_StoryListScreen> createState() => _StoryListScreenState();
}

class _StoryListScreenState extends State<_StoryListScreen> {
  Difficulty? _filter;
  List<StoryItem> _stories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await LibraryService.fetchStories();
    if (mounted) {
      setState(() {
        _stories = data;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final items = _filter == null
        ? _stories
        : _stories.where((s) => s.difficulty == _filter).toList();

    if (_loading) return const Scaffold(
      backgroundColor: Color(0xFF131313),
      body: Center(child: CircularProgressIndicator()),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1F0D),
        foregroundColor: Colors.white,
        title: Text('Short Stories',
            style: TextStyle(color: themeProvider.primaryColor)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _DifficultyFilter(
              selected: _filter,
              onChanged: (d) => setState(() => _filter = d)),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final s = items[i];
                return _ListItemCard(
                  title: s.title,
                  meta: s.origin,
                  badge: _difficultyBadge(s.difficulty),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => _ReaderScreen(
                            title: s.title,
                            subtitle: s.origin,
                            body: s.body,
                            badge: _difficultyBadge(s.difficulty),
                            questions: s.questions,
                          ))),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ChildrenStoryListScreen extends StatefulWidget {
  const _ChildrenStoryListScreen();

  @override
  State<_ChildrenStoryListScreen> createState() => _ChildrenStoryListScreenState();
}

class _ChildrenStoryListScreenState extends State<_ChildrenStoryListScreen> {
  List<ChildrenStory> _stories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await LibraryService.fetchChildrenStories();
    if (mounted) {
      setState(() {
        _stories = data;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    if (_loading) return const Scaffold(
      backgroundColor: Color(0xFF131313),
      body: Center(child: CircularProgressIndicator()),
    );
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1F0D),
        foregroundColor: Colors.white,
        title: Text("Children's Stories",
            style: TextStyle(color: themeProvider.primaryColor)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _stories.length,
        itemBuilder: (_, i) {
          final s = _stories[i];
          return _ListItemCard(
            title: s.title,
            meta: s.origin,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => _ReaderScreen(
                      title: s.title,
                      subtitle: s.origin,
                      body: s.body,
                      footer: 'Moral: ${s.moral}',
                      questions: s.questions,
                    ))),
          );
        },
      ),
    );
  }
}

class _IdiomListScreen extends StatefulWidget {
  const _IdiomListScreen();
  @override
  State<_IdiomListScreen> createState() => _IdiomListScreenState();
}

class _IdiomListScreenState extends State<_IdiomListScreen> {
  String _search = '';
  String _selectedCategory = 'All';
  List<IdiomItem> _allIdioms = [];
  bool _loading = true;

  static const List<String> _categories = [
    'All', 'General', 'Work', 'Travel', 'School',
    'Food', 'Health', 'Sports', 'Shopping', 'Casual',
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await LibraryService.fetchIdioms();
    if (mounted) {
      setState(() {
        _allIdioms = data;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    if (_loading) return const Scaffold(
      backgroundColor: Color(0xFF131313),
      body: Center(child: CircularProgressIndicator()),
    );

    final allItems = _allIdioms;

    final filtered = allItems.where((item) {
      final matchesCategory = _selectedCategory == 'All' ||
          item.category == _selectedCategory;
      final matchesSearch = _search.isEmpty ||
          item.idiom.toLowerCase().contains(_search.toLowerCase()) ||
          item.meaning.toLowerCase().contains(_search.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1F0D),
        foregroundColor: Colors.white,
        title: Text('Idioms & Expressions',
            style: TextStyle(color: themeProvider.primaryColor)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: TextField(
                onChanged: (v) => setState(() => _search = v),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search idioms and expressions...',
                  hintStyle: const TextStyle(color: Color(0xFF888888)),
                  prefixIcon: Icon(Icons.search,
                      color: themeProvider.primaryColor, size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),

          // Category filter chips
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _categories.length,
              itemBuilder: (ctx, i) {
                final cat = _categories[i];
                final isSelected = _selectedCategory == cat;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? themeProvider.primaryColor
                          : Colors.white.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? themeProvider.primaryColor
                            : Colors.white24,
                      ),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white54,
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Count indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${filtered.length} expression${filtered.length == 1 ? '' : 's'}',
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ),
          ),

          // List
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text('No results found',
                        style: TextStyle(color: Colors.white38)))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final item = filtered[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.08)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(item.idiom,
                                            style: const TextStyle(
                                                color: Color(0xFFFFD700),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: themeProvider.primaryColor
                                              .withOpacity(0.15),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          item.category,
                                          style: TextStyle(
                                              color:
                                                  themeProvider.primaryColor,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(item.meaning,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 14)),
                                  const SizedBox(height: 6),
                                  Text(item.example,
                                      style: const TextStyle(
                                          color: Color(0xFFDDC1AE),
                                          fontSize: 13,
                                          fontStyle: FontStyle.italic)),
                                  if ((item.origin ?? '').isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Text('Origin: ${item.origin}',
                                        style: const TextStyle(
                                            color: Colors.white38,
                                            fontSize: 12)),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _GrammarListScreen extends StatefulWidget {
  const _GrammarListScreen();

  @override
  State<_GrammarListScreen> createState() => _GrammarListScreenState();
}

class _GrammarListScreenState extends State<_GrammarListScreen> {
  List<GrammarGuide> _guides = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await LibraryService.fetchGrammarGuides();
    if (mounted) {
      setState(() {
        _guides = data;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    if (_loading) return const Scaffold(
      backgroundColor: Color(0xFF131313),
      body: Center(child: CircularProgressIndicator()),
    );
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1F0D),
        foregroundColor: Colors.white,
        title: Text('Grammar Guides',
            style: TextStyle(color: themeProvider.primaryColor)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _guides.length,
        itemBuilder: (_, i) {
          final g = _guides[i];
          return _ListItemCard(
            title: g.title,
            meta: '${g.examples.length} examples',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(
                    builder: (_) => _GrammarDetailScreen(guide: g))),
          );
        },
      ),
    );
  }
}

class _GrammarDetailScreen extends StatelessWidget {
  final GrammarGuide guide;
  const _GrammarDetailScreen({required this.guide});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1F0D),
        foregroundColor: Colors.white,
        title: Text(guide.title,
            style: TextStyle(color: themeProvider.primaryColor, fontSize: 16)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(14),
                    border:
                        Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Text(guide.explanation,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 15, height: 1.6)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Examples',
                style: TextStyle(
                    color: themeProvider.primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...guide.examples.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.08)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_outline_rounded,
                                color: themeProvider.primaryColor, size: 16),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(e,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF8A00).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: const Color(0xFFFF8A00).withOpacity(0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: Color(0xFFFF8A00), size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Common Mistake',
                                style: TextStyle(
                                    color: Color(0xFFFF8A00),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13)),
                            const SizedBox(height: 4),
                            Text(guide.commonMistake,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultyFilter extends StatelessWidget {
  final Difficulty? selected;
  final ValueChanged<Difficulty?> onChanged;
  const _DifficultyFilter({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          _FilterChip(label: 'All', active: selected == null, color: themeProvider.primaryColor, onTap: () => onChanged(null)),
          const SizedBox(width: 8),
          _FilterChip(label: 'Beginner', active: selected == Difficulty.beginner, color: const Color(0xFF2ECC71), onTap: () => onChanged(Difficulty.beginner)),
          const SizedBox(width: 8),
          _FilterChip(label: 'Intermediate', active: selected == Difficulty.intermediate, color: const Color(0xFF88CEFF), onTap: () => onChanged(Difficulty.intermediate)),
          const SizedBox(width: 8),
          _FilterChip(label: 'Advanced', active: selected == Difficulty.advanced, color: const Color(0xFFFF8A00), onTap: () => onChanged(Difficulty.advanced)),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.active, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: active ? color.withOpacity(0.2) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? color : Colors.white.withOpacity(0.1), width: 1.2),
        ),
        child: Text(label,
            style: TextStyle(
                color: active ? color : const Color(0xFFDDC1AE),
                fontSize: 13,
                fontWeight: active ? FontWeight.bold : FontWeight.normal)),
      ),
    );
  }
}

class _ListItemCard extends StatelessWidget {
  final String title;
  final String? meta;
  final Widget? badge;
  final VoidCallback onTap;
  const _ListItemCard({required this.title, this.meta, this.badge, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (badge != null) ...[badge!, const SizedBox(height: 6)],
                        Text(title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600)),
                        if (meta != null) ...[
                          const SizedBox(height: 4),
                          Text(meta!,
                              style: const TextStyle(
                                  color: Color(0xFFDDC1AE), fontSize: 12)),
                        ],
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded,
                      color: Colors.white.withOpacity(0.3)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _tabText(String text, {bool active = false}) {
  return Padding(
    padding: const EdgeInsets.only(right: 18),
    child: Column(
      children: [
        Text(
          text,
          style: TextStyle(
            color: active ? const Color(0xFFFFB77F) : const Color(0xFFDDC1AE),
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        if (active)
          Container(
            height: 2,
            width: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFFFB77F),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
      ],
    ),
  );
}

Widget _quickStatCard({
  required String title,
  required String value,
  required String hint,
  required IconData icon,
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
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.16),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              hint,
              style: const TextStyle(
                color: Color(0xFFDDC1AE),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _aiFocusCard(ThemeProvider themeProvider) {
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: const Color(0xFFFF8A00),
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: themeProvider.primaryColor.withOpacity(0.25),
          blurRadius: 18,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.auto_awesome,
              color: Color(0xFF613100), size: 28),
        ),
        const SizedBox(height: 14),
        const Text(
          'AI Daily Focus',
          style: TextStyle(
            color: Color(0xFF2F1500),
            fontSize: 38,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.7,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Personalized target based on your recent study patterns.',
          style: TextStyle(
            color: Color(0xFF4E2600),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 18),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Daily Goal',
              style: TextStyle(
                color: Color(0xFF4E2600),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            Text(
              '75%',
              style: TextStyle(
                color: Color(0xFF4E2600),
                fontWeight: FontWeight.w800,
                fontSize: 24,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: 0.75,
            minHeight: 10,
            color: const Color(0xFF4E2600),
            backgroundColor: Colors.black.withOpacity(0.15),
          ),
        ),
      ],
    ),
  );
}

// Blurred version of stat card with "Coming Soon" overlay
Widget _blurredStatCard({
  required String title,
  required String value,
  required String hint,
  required IconData icon,
  required Color color,
}) {
  return Stack(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hint,
                  style: const TextStyle(
                    color: Color(0xFFDDC1AE),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Positioned.fill(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              color: Colors.black.withOpacity(0.28),
              alignment: Alignment.center,
              child: const Text(
                'Coming Soon',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

// Blurred version of AI Focus card with "Coming Soon" overlay
Widget _blurredAiFocusCard(ThemeProvider themeProvider) {
  return Stack(
    children: [
      Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFFF8A00),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: themeProvider.primaryColor.withOpacity(0.25),
              blurRadius: 18,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.auto_awesome,
                  color: Color(0xFF613100), size: 28),
            ),
            const SizedBox(height: 14),
            const Text(
              'AI Daily Focus',
              style: TextStyle(
                color: Color(0xFF2F1500),
                fontSize: 38,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.7,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Personalized target based on your recent study patterns.',
              style: TextStyle(
                color: Color(0xFF4E2600),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daily Goal',
                  style: TextStyle(
                    color: Color(0xFF4E2600),
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '75%',
                  style: TextStyle(
                    color: Color(0xFF4E2600),
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: 0.75,
                minHeight: 10,
                color: const Color(0xFF4E2600),
                backgroundColor: Colors.black.withOpacity(0.15),
              ),
            ),
          ],
        ),
      ),
      Positioned.fill(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              color: Colors.black.withOpacity(0.24),
              alignment: Alignment.center,
              child: const Text(
                'Coming Soon',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

// Action card for library practice exercises (matching home screen style)
Widget _buildLibraryActionCard(
  ThemeProvider themeProvider, {
  required IconData icon,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
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
                color: Colors.white.withOpacity(0.06),
              ),
              boxShadow: [
                BoxShadow(
                  color: themeProvider.primaryColor.withOpacity(0.04),
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
                              color: Color(0xFFDDC1AE),
                              fontWeight: FontWeight.w500,
                              fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward_rounded,
                    color: themeProvider.primaryColor.withOpacity(0.5), size: 20),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _PracticeMiniCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _PracticeMiniCard({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}