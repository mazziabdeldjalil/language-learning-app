import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/backend.dart';
import '../core/supabase_service.dart';

class MyClassScreen extends StatefulWidget {
  const MyClassScreen({super.key});

  @override
  State<MyClassScreen> createState() => _MyClassScreenState();
}

class _MyClassScreenState extends State<MyClassScreen> {
  ClassModel? _currentClass;
  List<ScenarioModel> _assignedScenarios = [];
  bool _loading = true;
  final _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadClassData();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _loadClassData() async {
    setState(() => _loading = true);
    _currentClass = await SupabaseService.getStudentClass();
    if (_currentClass != null) {
      _assignedScenarios =
          await SupabaseService.getClassScenarios(_currentClass!.id);
    }
    setState(() => _loading = false);
  }

  Future<void> _joinClass() async {
    if (_codeController.text.trim().length < 6) return;
    final success =
        await SupabaseService.joinClassByCode(_codeController.text.trim());
    if (success) {
      _codeController.clear();
      await _loadClassData();
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'Successfully joined the class!'
              : 'Invalid code. Please try again.'),
          backgroundColor:
              success ? const Color(0xFF2ECC71) : const Color(0xFFEF5350),
        ),
      );
    }
  }

  void _confirmLeaveClass() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Leave Class',
            style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to leave "${_currentClass!.name}"?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF5350)),
            onPressed: () async {
              await SupabaseService.leaveClass();
              Navigator.pop(ctx);
              await _loadClassData();
            },
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  void _startScenario(ScenarioModel scenario) {
    final chatProvider =
        Provider.of<ChatProvider>(context, listen: false);
    chatProvider.setScenarioModel(scenario);
    Navigator.pushNamed(context, '/difficulty');
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
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/dashboard.png'),
            fit: BoxFit.cover,
            colorFilter:
                ColorFilter.mode(Color(0xCC000000), BlendMode.darken),
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
                    const Text('My Class',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              if (_loading)
                const Expanded(
                    child: Center(
                        child: CircularProgressIndicator(
                            color: Colors.orange)))
              else if (_currentClass == null)
                _buildJoinView()
              else
                _buildClassView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJoinView() {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.group_outlined,
                  color: Colors.white38, size: 64),
            ),
            const SizedBox(height: 24),
            const Text("You're not in a class yet",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              'Ask your teacher for an invite code\nand enter it below to join',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _codeController,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  letterSpacing: 8,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              textCapitalization: TextCapitalization.characters,
              maxLength: 6,
              decoration: InputDecoration(
                hintText: 'XXXXXX',
                hintStyle: const TextStyle(color: Colors.white24),
                filled: true,
                fillColor: Colors.white.withOpacity(0.07),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                counterStyle:
                    const TextStyle(color: Colors.white38),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _joinClass,
                child: const Text('Join Class',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassView() {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Class info card
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.school,
                              color: Colors.orange, size: 20),
                          const SizedBox(width: 8),
                          const Text('Enrolled Class',
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _currentClass!.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      if (_currentClass!.description != null &&
                          _currentClass!.description!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(_currentClass!.description!,
                            style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 14)),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Assigned scenarios
            if (_assignedScenarios.isNotEmpty) ...[
              const Row(
                children: [
                  Icon(Icons.assignment, color: Colors.orange, size: 18),
                  SizedBox(width: 8),
                  Text('Assigned by Teacher',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              ..._assignedScenarios.map((scenario) =>
                  _buildScenarioCard(scenario)),
              const SizedBox(height: 24),
            ] else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Colors.white38, size: 18),
                    SizedBox(width: 10),
                    Text('No scenarios assigned yet',
                        style: TextStyle(color: Colors.white38)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Leave class button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFEF5350)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.exit_to_app,
                    color: Color(0xFFEF5350)),
                label: const Text('Leave Class',
                    style: TextStyle(
                        color: Color(0xFFEF5350), fontSize: 16)),
                onPressed: _confirmLeaveClass,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScenarioCard(ScenarioModel scenario) {
    return GestureDetector(
      onTap: () => _startScenario(scenario),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border:
              Border.all(color: Colors.orange.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_getIcon(scenario.iconName),
                  color: Colors.orange, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(scenario.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(scenario.description,
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.play_circle_outline,
                color: Colors.orange, size: 28),
          ],
        ),
      ),
    );
  }
}
