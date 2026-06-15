import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/backend.dart';
import '../services/gcp_tts_service.dart';
import '../providers/theme_provider.dart';
import '../widgets/help_dialog.dart';

class PronunciationScreen extends StatefulWidget {
  const PronunciationScreen({super.key});

  @override
  State<PronunciationScreen> createState() => _PronunciationScreenState();
}

class _PronunciationScreenState extends State<PronunciationScreen> {
  static const List<Map<String, String>> _wordEntries = [
    {'word': 'knight',       'phonetic': '/naɪt/',           'tip': 'The K is silent. Sounds like "night"',              'category': 'Silent Letters'},
    {'word': 'knife',        'phonetic': '/naɪf/',           'tip': 'The K is silent. Sounds like "nife"',               'category': 'Silent Letters'},
    {'word': 'know',         'phonetic': '/noʊ/',            'tip': 'The K is silent. Sounds like "no"',                 'category': 'Silent Letters'},
    {'word': 'kneel',        'phonetic': '/niːl/',           'tip': 'The K is silent. Sounds like "neel"',               'category': 'Silent Letters'},
    {'word': 'knock',        'phonetic': '/nɒk/',            'tip': 'The K is silent. Sounds like "nock"',               'category': 'Silent Letters'},
    {'word': 'island',       'phonetic': '/ˈaɪlənd/',        'tip': 'The S is silent. Sounds like "iland"',              'category': 'Silent Letters'},
    {'word': 'debt',         'phonetic': '/dɛt/',            'tip': 'The B is silent. Sounds like "det"',                'category': 'Silent Letters'},
    {'word': 'doubt',        'phonetic': '/daʊt/',           'tip': 'The B is silent. Sounds like "dowt"',               'category': 'Silent Letters'},
    {'word': 'lamb',         'phonetic': '/læm/',            'tip': 'The B is silent. Sounds like "lam"',                'category': 'Silent Letters'},
    {'word': 'bomb',         'phonetic': '/bɒm/',            'tip': 'The B is silent. Sounds like "bom"',                'category': 'Silent Letters'},
    {'word': 'thumb',        'phonetic': '/θʌm/',            'tip': 'The B is silent. Sounds like "thum"',               'category': 'Silent Letters'},
    {'word': 'wrap',         'phonetic': '/ræp/',            'tip': 'The W is silent. Sounds like "rap"',                'category': 'Silent Letters'},
    {'word': 'write',        'phonetic': '/raɪt/',           'tip': 'The W is silent. Sounds like "rite"',               'category': 'Silent Letters'},
    {'word': 'wrong',        'phonetic': '/rɒŋ/',            'tip': 'The W is silent. Sounds like "rong"',               'category': 'Silent Letters'},
    {'word': 'hour',         'phonetic': '/aʊər/',           'tip': 'The H is silent. Sounds like "our"',                'category': 'Silent Letters'},
    {'word': 'honest',       'phonetic': '/ˈɒnɪst/',         'tip': 'The H is silent. Sounds like "onest"',              'category': 'Silent Letters'},
    {'word': 'psychology',   'phonetic': '/saɪˈkɒlədʒi/',   'tip': 'The P is silent. Starts with "sy"',                 'category': 'Silent Letters'},
    {'word': 'receipt',      'phonetic': '/rɪˈsiːt/',        'tip': 'The P is silent. Sounds like "reseet"',             'category': 'Silent Letters'},
    {'word': 'salmon',       'phonetic': '/ˈsæmən/',         'tip': 'The L is silent. Sounds like "samen"',              'category': 'Silent Letters'},
    {'word': 'psalm',        'phonetic': '/sɑːm/',           'tip': 'The P is silent. Sounds like "sahm"',               'category': 'Silent Letters'},
    {'word': 'wreck',        'phonetic': '/rɛk/',            'tip': 'The W is silent. Sounds like "reck"',               'category': 'Silent Letters'},
    {'word': 'pronunciation','phonetic': '/prəˌnʌnsiˈeɪʃən/','tip': 'Not "pro-noun-ciation" — no "noun" in it',         'category': 'Commonly Mispronounced'},
    {'word': 'february',     'phonetic': '/ˈfebrueri/',      'tip': 'The first R is often skipped: "Feb-roo-ary"',       'category': 'Commonly Mispronounced'},
    {'word': 'wednesday',    'phonetic': '/ˈwɛnzdeɪ/',       'tip': 'The D is silent. "Wenz-day"',                       'category': 'Commonly Mispronounced'},
    {'word': 'comfortable',  'phonetic': '/ˈkʌmftəbl/',      'tip': 'Often said as "comf-ter-ble", 3 syllables',         'category': 'Commonly Mispronounced'},
    {'word': 'vegetable',    'phonetic': '/ˈvɛdʒtəbl/',      'tip': 'Often said as "vej-ta-ble", 3 syllables',           'category': 'Commonly Mispronounced'},
    {'word': 'temperature',  'phonetic': '/ˈtɛmprətʃər/',    'tip': 'Often said as "temp-ra-ture", 3 syllables',         'category': 'Commonly Mispronounced'},
    {'word': 'library',      'phonetic': '/ˈlaɪbrəri/',      'tip': 'Both R sounds matter: "lie-brer-ee"',               'category': 'Commonly Mispronounced'},
    {'word': 'particularly', 'phonetic': '/pəˈtɪkjʊləli/',   'tip': 'All 5 syllables: "par-tic-u-lar-ly"',               'category': 'Commonly Mispronounced'},
    {'word': 'literally',    'phonetic': '/ˈlɪtərəli/',      'tip': 'All 4 syllables: "lit-er-al-ly"',                   'category': 'Commonly Mispronounced'},
    {'word': 'especially',   'phonetic': '/ɪˈspɛʃəli/',      'tip': 'Starts with "es", not "ex"',                        'category': 'Commonly Mispronounced'},
    {'word': 'espresso',     'phonetic': '/ɛˈsprɛsoʊ/',      'tip': 'No X — not "expresso"',                             'category': 'Commonly Mispronounced'},
    {'word': 'etc',          'phonetic': '/ɛt ˈsɛtərə/',     'tip': '"Et cetera" — not "ex cetera"',                     'category': 'Commonly Mispronounced'},
    {'word': 'nuclear',      'phonetic': '/ˈnjuːkliər/',     'tip': '"Noo-klee-er" not "noo-cyu-lar"',                   'category': 'Commonly Mispronounced'},
    {'word': 'athlete',      'phonetic': '/ˈæθliːt/',        'tip': '2 syllables: "ath-leet", not "ath-a-leet"',         'category': 'Commonly Mispronounced'},
    {'word': 'mischievous',  'phonetic': '/ˈmɪstʃɪvəs/',     'tip': '3 syllables: "mis-chuh-vus", not "mis-cheev-ee-us"','category': 'Commonly Mispronounced'},
    {'word': 'colonel',      'phonetic': '/ˈkɜːnəl/',        'tip': 'Sounds like "kernel", not "col-o-nel"',             'category': 'Commonly Mispronounced'},
  ];

  final GcpTtsService _ttsService = GcpTtsService();
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    _ttsService.dispose();
    super.dispose();
  }

  List<Map<String, String>> get _filteredEntries {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _wordEntries;
    return _wordEntries
        .where((e) => (e['word'] ?? '').toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final grouped = <String, List<Map<String, String>>>{
      'Silent Letters': [],
      'Commonly Mispronounced': [],
    };
    for (final entry in _filteredEntries) {
      final cat = entry['category'] ?? '';
      if (grouped.containsKey(cat)) grouped[cat]!.add(entry);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/onboarding_bg.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.75),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Top bar ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'FluentlyDZ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: themeProvider.primaryColor,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.help_outline, color: Colors.white),
                      onPressed: () => showHelpDialog(context),
                    ),
                  ],
                ),
              ),

              // ── Scrollable body ───────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Progress dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          4,
                          (i) => Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: i == 2
                                  ? themeProvider.primaryColor
                                  : Colors.grey.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // ── Pronunciation Guide header ──────────────────────
                      const Text(
                        'Pronunciation Guide',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Tap a word to hear it and master tricky silent letters and common mispronunciations.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFDDC1AE),
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Search bar ──────────────────────────────────────
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.1)),
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                          onChanged: (v) => setState(() => _query = v),
                          decoration: InputDecoration(
                            hintText: 'Search a word...',
                            hintStyle:
                                const TextStyle(color: Color(0xFF888888)),
                            prefixIcon: Icon(Icons.search,
                                color: themeProvider.primaryColor, size: 20),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Word list ───────────────────────────────────────
                      Builder(
                        builder: (context) {
                          final listChildren = <Widget>[];

                          for (final category in grouped.keys) {
                            final entries = grouped[category]!;
                            if (entries.isEmpty) continue;

                            // Category header
                            listChildren.add(
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 12, bottom: 8),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 3,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        color: themeProvider.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      category,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: themeProvider.primaryColor,
                                        fontSize: 13,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );

                            // Word cards
                            for (final entry in entries) {
                              final word = entry['word'] ?? '';
                              final phonetic = entry['phonetic'] ?? '';
                              final tip = entry['tip'] ?? '';

                              listChildren.add(
                                Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 12, sigmaY: 12),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        decoration: BoxDecoration(
                                          color:
                                              Colors.white.withOpacity(0.05),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          border: Border.all(
                                              color: Colors.white
                                                  .withOpacity(0.08)),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    word,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    phonetic,
                                                    style: TextStyle(
                                                      color: themeProvider
                                                          .primaryColor,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    tip,
                                                    style: const TextStyle(
                                                      color:
                                                          Color(0xFFDDC1AE),
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.volume_up,
                                                color: themeProvider
                                                    .primaryColor,
                                              ),
                                              onPressed: () =>
                                                  _ttsService.speak(word),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          }

                          if (listChildren.isEmpty) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 32),
                                child: Text(
                                  'No words found.',
                                  style:
                                      TextStyle(color: Color(0xFFDDC1AE)),
                                ),
                              ),
                            );
                          }

                          return Column(children: listChildren);
                        },
                      ),

                      const SizedBox(height: 32),
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
}