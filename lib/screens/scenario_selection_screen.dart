import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:language_learning_app/core/backend.dart';
import 'package:language_learning_app/core/supabase_service.dart';
import '../providers/theme_provider.dart';
import '../widgets/help_dialog.dart';

class ScenarioSelectionScreen extends StatefulWidget {
  const ScenarioSelectionScreen({super.key});

  @override
  State<ScenarioSelectionScreen> createState() =>
      _ScenarioSelectionScreenState();
}

class _ScenarioSelectionScreenState extends State<ScenarioSelectionScreen> {
  List<ScenarioModel> _classScenarios = [];

  @override
  void initState() {
    super.initState();
    _loadClassScenarios();
  }

  Future<void> _loadClassScenarios() async {
    final scenarios = await SupabaseService.getStudentClassScenarios();
    if (mounted) setState(() => _classScenarios = scenarios);
  }

  IconData _getIcon(String iconName) {
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
      case 'music_note':
        return Icons.music_note_outlined;
      case 'shopping_cart':
        return Icons.shopping_cart_outlined;
      default:
        return Icons.chat_bubble_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);

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
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 4),
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
                    children: [
                      const Text(
                        'Choose a scenario to practice.',
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Pick a real-world situation, then jump into guided role-play with your AI mentor.',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFFDDC1AE),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _scenarioChip(themeProvider.primaryColor, 'Travel'),
                          _scenarioChip(const Color(0xFF88CEFF), 'Business'),
                          _scenarioChip(const Color(0xFFFF8A00), 'Daily Life'),
                        ],
                      ),
                    ],
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
                      'Popular scenarios',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                    Text(
                      'Swipe down for more',
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
                child: chatProvider.availableScenarios.isEmpty
                    ? Center(
                        child: CircularProgressIndicator(
                          color: themeProvider.primaryColor,
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          if (_classScenarios.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                              child: Row(
                                children: [
                                  const Icon(Icons.school, color: Colors.orange, size: 16),
                                  const SizedBox(width: 6),
                                  const Text('From Your Teacher',
                                      style: TextStyle(color: Colors.orange,
                                          fontSize: 13, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            ..._classScenarios.map(
                              (scenario) => _ScenarioCard(
                                scenario: scenario,
                                icon: _getIcon(scenario.iconName),
                              ),
                            ),
                            const Divider(color: Colors.white12, indent: 16, endIndent: 16),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                              child: const Text('All Scenarios',
                                  style: TextStyle(color: Colors.white38, fontSize: 13)),
                            ),
                          ],
                          ...chatProvider.availableScenarios.map(
                            (scenario) => _ScenarioCard(
                              scenario: scenario,
                              icon: _getIcon(scenario.iconName),
                            ),
                          ),
                          // Create My Own card
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: GestureDetector(
                              onTap: () => _showCustomScenarioSheet(context),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.orange.withOpacity(0.5), 
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.orange.withOpacity(0.05),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.edit, color: Colors.orange, size: 24),
                                    ),
                                    const SizedBox(width: 16),
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Create My Own',
                                              style: TextStyle(color: Colors.white, 
                                                  fontSize: 16, fontWeight: FontWeight.bold)),
                                          SizedBox(height: 4),
                                          Text('Design a custom scenario for your needs',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(color: Colors.white54, fontSize: 13)),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_ios, color: Colors.orange, size: 16),
                                  ],
                                ),
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
    );
  }
}

Widget _scenarioChip(Color color, String label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withOpacity(0.25)),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: color,
        fontSize: 11,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class _ScenarioCard extends StatelessWidget {
  final ScenarioModel scenario;
  final IconData icon;
  const _ScenarioCard({required this.scenario, required this.icon});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () {
          context.read<ChatProvider>().setScenarioModel(scenario);
          Navigator.pushNamed(context, '/difficulty');
        },
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
                  color: themeProvider.primaryColor.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: themeProvider.primaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      icon,
                      size: 32,
                      color: themeProvider.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scenario.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          scenario.description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFDDC1AE),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: themeProvider.primaryColor,
                    size: 16,
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

void _showCustomScenarioSheet(BuildContext context) async {
  final chatProvider = Provider.of<ChatProvider>(context, listen: false);
  
  // Check quota first
  final quota = await SupabaseService.getCustomScenarioQuota();
  final allowed = quota['allowed'] as bool;
  final used = quota['used'] as int;
  final limit = quota['limit'] as int;

  if (!allowed) {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text('Weekly Limit Reached', 
              style: TextStyle(color: Colors.white)),
          content: Text(
            'You have used $used/$limit custom scenarios this week. Your quota resets every 7 days.',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK', style: TextStyle(color: Colors.white54)),
            ),
          ],
        ),
      );
    }
    return;
  }

  final descController = TextEditingController();
  final goalController = TextEditingController();

  if (context.mounted) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.edit, color: Colors.orange),
                const SizedBox(width: 8),
                const Text('Create My Scenario',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                Text('$used/$limit used this week',
                    style: const TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Describe the situation', 
                style: TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 8),
            TextField(
              controller: descController,
              style: const TextStyle(color: Colors.white),
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'e.g. I am at a restaurant in Paris...',
                hintStyle: const TextStyle(color: Colors.white30),
                filled: true,
                fillColor: Colors.white.withOpacity(0.07),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('What is your goal?',
                style: TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 8),
            TextField(
              controller: goalController,
              style: const TextStyle(color: Colors.white),
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'e.g. I want to practice ordering food politely...',
                hintStyle: const TextStyle(color: Colors.white30),
                filled: true,
                fillColor: Colors.white.withOpacity(0.07),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  if (descController.text.trim().isEmpty || 
                      goalController.text.trim().isEmpty) return;
                  
                  chatProvider.setCustomScenario(
                    descController.text.trim(),
                    goalController.text.trim(),
                  );
                  await SupabaseService.incrementCustomScenarioUsed();
                  Navigator.pop(ctx);
                  Navigator.pushNamed(context, '/difficulty');
                },
                child: const Text('Start Conversation',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}






