import 'package:flutter/material.dart';

void showHelpDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.help_outline, color: Colors.orange, size: 24),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'How to use FluentlyDZ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white38),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const Divider(color: Colors.white12),
            const SizedBox(height: 8),
            _helpSection(
              icon: Icons.chat_bubble_outline,
              title: 'Start a Conversation',
              body: 'Go to the dashboard and tap "Start Conversation". Pick a scenario and difficulty level, then chat with an AI character to practice your English. Tap "End Session" when you\'re done to get your scores.',
            ),
            _helpSection(
              icon: Icons.edit_outlined,
              title: 'Create Your Own Scenario',
              body: 'On the scenario selection screen, scroll down and tap "Create My Own". Describe your situation and your goal - the AI will adapt to your custom scenario. You can create up to a limited number per week.',
            ),
            _helpSection(
              icon: Icons.fitness_center_outlined,
              title: 'Practice Exercises',
              body: 'Tap "Practice Exercises" on the dashboard. Choose exercise types (grammar, vocabulary, fill in the blank, word order) and your difficulty. Complete the exercises to strengthen your English skills.',
            ),
            _helpSection(
              icon: Icons.school_outlined,
              title: 'Join a Class',
              body: 'If your teacher gave you an invite code, tap "Join a Class" on the dashboard. Enter the 6-character code to enroll. Your teacher can assign specific scenarios and track your progress.',
            ),
            _helpSection(
              icon: Icons.record_voice_over_outlined,
              title: 'Voice Input',
              body: 'In the chat screen, tap the microphone button to speak your message. Tap it again when you\'re done speaking, then tap send. Make sure microphone permission is enabled.',
            ),
            _helpSection(
              icon: Icons.bar_chart_outlined,
              title: 'Track Your Progress',
              body: 'Visit the Progress tab to see your scores over time. Each session is scored on grammar, vocabulary, and pronunciation out of 10. The AI also gives you personalized feedback and tips.',
            ),
            _helpSection(
              icon: Icons.people_outline,
              title: 'Community',
              body: 'Visit the Community tab to share posts, like and comment on others\' posts, and see the leaderboard of most active learners.',
            ),
            const SizedBox(height: 8),
            const Divider(color: Colors.white12),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'FluentlyDZ - Practice English. Speak with confidence.',
                style: TextStyle(color: Colors.white38, fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _helpSection({
  required IconData icon,
  required String title,
  required String body,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.orange, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              const SizedBox(height: 4),
              Text(body,
                  style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                      height: 1.4)),
            ],
          ),
        ),
      ],
    ),
  );
}