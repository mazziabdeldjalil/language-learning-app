import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/learn_content.dart';
import '../providers/theme_provider.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

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
                        Text('LinguistAI',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                                color: themeProvider.primaryColor)),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
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
                children: List.generate(
                  4,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == 3
                          ? themeProvider.primaryColor
                          : Colors.white.withOpacity(0.25),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Your learning library',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
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
                    _blurredStatCard(
                      title: 'Words Learned',
                      value: '${LearnContent.idioms.length + LearnContent.grammarGuides.length * 20}',
                      hint: 'Active vocabulary growth',
                      icon: Icons.school_rounded,
                      color: themeProvider.primaryColor,
                    ),
                    const SizedBox(height: 10),
                    _blurredAiFocusCard(themeProvider),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        const Text(
                          'Recommended for You',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.6,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'VIEW ALL',
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
                      subtitle: '${LearnContent.passages.length} passages · Beginner to Advanced',
                      color: const Color(0xFF88CEFF),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _PassageListScreen())),
                    ),
                    _CategoryCard(
                      icon: Icons.auto_stories_rounded,
                      label: 'Short Stories',
                      subtitle: '${LearnContent.stories.length} stories · Beginner to Advanced',
                      color: const Color(0xFF2ECC71),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _StoryListScreen())),
                    ),
                    _CategoryCard(
                      icon: Icons.child_care_rounded,
                      label: "Children's Stories",
                      subtitle: '${LearnContent.childrenStories.length} fables · Beginner friendly',
                      color: const Color(0xFFFF8A00),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _ChildrenStoryListScreen())),
                    ),
                    _CategoryCard(
                      icon: Icons.format_quote_rounded,
                      label: 'English Idioms',
                      subtitle: '${LearnContent.idioms.length} idioms with meaning & examples',
                      color: const Color(0xFFFFD700),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _IdiomListScreen())),
                    ),
                    _CategoryCard(
                      icon: Icons.rule_rounded,
                      label: 'Grammar Guides',
                      subtitle: '${LearnContent.grammarGuides.length} guides · Common rules explained',
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
                      icon: Icons.menu_book_rounded,
                      title: 'Grammar',
                      subtitle: 'Master grammatical concepts',
                      onTap: () {},
                    ),
                    _buildLibraryActionCard(
                      themeProvider,
                      icon: Icons.translate_rounded,
                      title: 'Vocabulary',
                      subtitle: 'Expand your word bank',
                      onTap: () {},
                    ),
                    _buildLibraryActionCard(
                      themeProvider,
                      icon: Icons.record_voice_over_rounded,
                      title: 'Speaking',
                      subtitle: 'Improve pronunciation & fluency',
                      onTap: () {},
                    ),
                    _buildLibraryActionCard(
                      themeProvider,
                      icon: Icons.history_rounded,
                      title: 'Review',
                      subtitle: 'Revisit previous lessons',
                      onTap: () {},
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
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

class _ReaderScreen extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String body;
  final Widget? badge;
  final String? footer;

  const _ReaderScreen({
    required this.title,
    this.subtitle,
    required this.body,
    this.badge,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1F0D),
        foregroundColor: Colors.white,
        title: Text(title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: themeProvider.primaryColor, fontSize: 16)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (badge != null) ...[badge!, const SizedBox(height: 12)],
            if (subtitle != null) ...[
              Text(subtitle!,
                  style: const TextStyle(
                      color: Color(0xFFDDC1AE),
                      fontSize: 13,
                      fontStyle: FontStyle.italic)),
              const SizedBox(height: 16),
            ],
            Text(body,
                style: const TextStyle(
                    color: Colors.white, fontSize: 16, height: 1.8)),
            if (footer != null) ...[
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
                          child: Text(footer!,
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final items = _filter == null
        ? LearnContent.passages
        : LearnContent.passages.where((p) => p.difficulty == _filter).toList();

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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final items = _filter == null
        ? LearnContent.stories
        : LearnContent.stories.where((s) => s.difficulty == _filter).toList();

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

class _ChildrenStoryListScreen extends StatelessWidget {
  const _ChildrenStoryListScreen();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
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
        itemCount: LearnContent.childrenStories.length,
        itemBuilder: (_, i) {
          final s = LearnContent.childrenStories[i];
          return _ListItemCard(
            title: s.title,
            meta: s.origin,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => _ReaderScreen(
                      title: s.title,
                      subtitle: s.origin,
                      body: s.body,
                      footer: 'Moral: ${s.moral}',
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final items = _search.isEmpty
        ? LearnContent.idioms
        : LearnContent.idioms
            .where((i) =>
                i.idiom.toLowerCase().contains(_search.toLowerCase()) ||
                i.meaning.toLowerCase().contains(_search.toLowerCase()))
            .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1F0D),
        foregroundColor: Colors.white,
        title: Text('English Idioms',
            style: TextStyle(color: themeProvider.primaryColor)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
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
                  hintText: 'Search idioms...',
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
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final item = items[i];
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
                            Text(item.idiom,
                                style: const TextStyle(
                                    color: Color(0xFFFFD700),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
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
                            if (item.origin != null) ...[
                              const SizedBox(height: 6),
                              Text('Origin: ${item.origin}',
                                  style: const TextStyle(
                                      color: Colors.white38, fontSize: 12)),
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

class _GrammarListScreen extends StatelessWidget {
  const _GrammarListScreen();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
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
        itemCount: LearnContent.grammarGuides.length,
        itemBuilder: (_, i) {
          final g = LearnContent.grammarGuides[i];
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
      // Blur overlay with "Coming Soon"
      ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
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
      // Blur overlay with "Coming Soon"
      Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(18),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              color: Colors.transparent,
              child: const Center(
                child: Text(
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