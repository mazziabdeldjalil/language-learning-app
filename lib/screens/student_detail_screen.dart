import 'package:flutter/material.dart';
import '../core/backend.dart';
import '../core/supabase_service.dart';

class StudentDetailScreen extends StatefulWidget {
  final StudentSummary student;

  const StudentDetailScreen({super.key, required this.student});

  @override
  State<StudentDetailScreen> createState() =>
      _StudentDetailScreenState();
}

class _StudentDetailScreenState
    extends State<StudentDetailScreen> {
  List<Map<String, dynamic>> _sessions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    _sessions =
        await SupabaseService.getStudentSessions(widget.student.id);
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/progress.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Color(0xCC000000), BlendMode.darken),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor:
                          Colors.orange.withOpacity(0.2),
                      child: Text(
                        widget.student.username[0].toUpperCase(),
                        style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(widget.student.username,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        Text(
                          '${widget.student.sessionCount} sessions total',
                          style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Average scores card
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: Colors.orange.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround,
                    children: [
                      _scoreChip('Grammar',
                          widget.student.avgGrammar),
                      _scoreChip('Vocabulary',
                          widget.student.avgVocabulary),
                      _scoreChip('Pronunciation',
                          widget.student.avgPronunciation),
                    ],
                  ),
                ),
              ),

              // Sessions list
              Expanded(
                child: _loading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: Colors.orange))
                    : _sessions.isEmpty
                        ? const Center(
                            child: Text('No sessions yet',
                                style: TextStyle(
                                    color: Colors.white38)))
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _sessions.length,
                            itemBuilder: (context, index) {
                              return _buildSessionCard(
                                  _sessions[index]);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scoreChip(String label, double? value) {
    return Column(
      children: [
        Text(
          value != null
              ? value.toStringAsFixed(1)
              : '-',
          style: TextStyle(
            color: value != null
                ? Colors.orange
                : Colors.white38,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label,
            style: const TextStyle(
                color: Colors.white54, fontSize: 11)),
      ],
    );
  }

  Widget _buildSessionCard(Map<String, dynamic> session) {
    final date = session['created_at'] != null
        ? DateTime.parse(session['created_at'] as String)
        : DateTime.now();
    final grammar =
        (session['grammar_score'] as num?)?.toDouble();
    final vocabulary =
        (session['vocabulary_score'] as num?)?.toDouble();
    final pronunciation =
        (session['pronunciation_score'] as num?)?.toDouble();
    final feedback = session['ai_feedback'] as String?;
    final scenario = session['scenario'] as String?;
    final difficulty = session['difficulty'] as String?;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${date.day}/${date.month}/${date.year}',
                style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              if (scenario != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(scenario,
                      style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 11)),
                ),
              if (difficulty != null) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(difficulty,
                      style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 11)),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround,
            children: [
              _miniScore('G', grammar),
              _miniScore('V', vocabulary),
              _miniScore('P', pronunciation),
            ],
          ),
          if (feedback != null &&
              feedback.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Divider(color: Colors.white12),
            const SizedBox(height: 6),
            Text(feedback,
                style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                    height: 1.4)),
          ],
        ],
      ),
    );
  }

  Widget _miniScore(String label, double? value) {
    final color = value == null
        ? Colors.white38
        : value >= 7
            ? const Color(0xFF2ECC71)
            : value >= 4
                ? Colors.orange
                : const Color(0xFFEF5350);
    return Column(
      children: [
        Text(
          value != null
              ? '${value.toStringAsFixed(1)}/10'
              : '-',
          style: TextStyle(
              color: color, fontWeight: FontWeight.bold),
        ),
        Text(label,
            style: const TextStyle(
                color: Colors.white38, fontSize: 11)),
      ],
    );
  }
}
