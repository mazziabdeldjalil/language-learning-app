import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/backend.dart';
import '../core/supabase_service.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key});

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  List<ClassModel> _classes = [];
  ClassModel? _selectedClass;
  List<StudentSummary> _students = [];
  bool _loadingClasses = true;
  bool _loadingStudents = false;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    setState(() => _loadingClasses = true);
    _classes = await SupabaseService.getTeacherClasses();
    if (_classes.isNotEmpty && _selectedClass == null) {
      _selectedClass = _classes.first;
      await _loadStudents(_selectedClass!.id);
    }
    setState(() => _loadingClasses = false);
  }

  Future<void> _loadStudents(String classId) async {
    setState(() => _loadingStudents = true);
    _students = await SupabaseService.getClassStudents(classId);
    setState(() => _loadingStudents = false);
  }

  void _showCreateClassDialog() {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Create Class',
            style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Class Name',
                labelStyle: TextStyle(color: Colors.white54),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                labelStyle: TextStyle(color: Colors.white54),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty) return;
              final newClass = await SupabaseService.createClass(
                nameController.text.trim(),
                descController.text.trim().isEmpty
                    ? null
                    : descController.text.trim(),
              );
              Navigator.pop(ctx);
              if (newClass != null) {
                await _loadClasses();
                setState(() => _selectedClass = newClass);
                await _loadStudents(newClass.id);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showInviteCode(ClassModel cls) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Invite Code',
            style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Share this code with your students:',
                style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Colors.orange.withOpacity(0.4)),
              ),
              child: Text(
                cls.inviteCode,
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () {
                Clipboard.setData(
                    ClipboardData(text: cls.inviteCode));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Code copied to clipboard!')),
                );
              },
              icon: const Icon(Icons.copy, color: Colors.orange),
              label: const Text('Copy Code',
                  style: TextStyle(color: Colors.orange)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close',
                style: TextStyle(color: Colors.white54)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteClass(ClassModel cls) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Delete Class',
            style: TextStyle(color: Colors.white)),
        content: Text(
          'Delete "${cls.name}"? All students will be unenrolled.',
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
              await SupabaseService.deleteClass(cls.id);
              Navigator.pop(ctx);
              await _loadClasses();
              setState(() {
                _selectedClass =
                    _classes.isNotEmpty ? _classes.first : null;
                _students = [];
              });
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAssignScenariosSheet(ClassModel cls) async {
    final allScenarios = await SupabaseService.getAllScenarios();
    final classScenarios = await SupabaseService.getClassScenarios(cls.id);
    final assignedIds = classScenarios.map((s) => s.id).toSet();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Column(
          children: [
            const SizedBox(height: 16),
            const Text('Assign Scenarios to Class',
                style: TextStyle(color: Colors.white,
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Students will see assigned scenarios at the top of their list',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white38, fontSize: 12)),
            const Divider(color: Colors.white12),
            Expanded(
              child: ListView.builder(
                itemCount: allScenarios.length,
                itemBuilder: (ctx, index) {
                  final scenario = allScenarios[index];
                  final isAssigned = assignedIds.contains(scenario.id);
                  return ListTile(
                    leading: Icon(
                      isAssigned ? Icons.check_circle : Icons.circle_outlined,
                      color: isAssigned ? Colors.orange : Colors.white38,
                    ),
                    title: Text(scenario.title,
                        style: const TextStyle(color: Colors.white)),
                    subtitle: Text(scenario.description,
                        style: const TextStyle(color: Colors.white54, fontSize: 12)),
                    onTap: () async {
                      if (isAssigned) {
                        await SupabaseService.removeScenarioFromClass(
                            cls.id, scenario.id);
                        setModalState(() => assignedIds.remove(scenario.id));
                      } else {
                        await SupabaseService.assignScenarioToClass(
                            cls.id, scenario.id);
                        setModalState(() => assignedIds.add(scenario.id));
                      }
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Done'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
                    const Text('Teacher Dashboard',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline,
                          color: Colors.orange),
                      tooltip: 'Create Class',
                      onPressed: _showCreateClassDialog,
                    ),
                  ],
                ),
              ),

              if (_loadingClasses)
                const Expanded(
                    child: Center(
                        child: CircularProgressIndicator(
                            color: Colors.orange)))
              else if (_classes.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.school_outlined,
                            color: Colors.white38, size: 64),
                        const SizedBox(height: 16),
                        const Text('No classes yet',
                            style: TextStyle(
                                color: Colors.white54,
                                fontSize: 18)),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: _showCreateClassDialog,
                          icon: const Icon(Icons.add),
                          label: const Text('Create your first class'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: Column(
                    children: [
                      // Class selector
                      SizedBox(
                        height: 48,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16),
                          itemCount: _classes.length,
                          itemBuilder: (context, index) {
                            final cls = _classes[index];
                            final isSelected =
                                _selectedClass?.id == cls.id;
                            return GestureDetector(
                              onTap: () async {
                                setState(
                                    () => _selectedClass = cls);
                                await _loadStudents(cls.id);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                    right: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.orange
                                      : Colors.white
                                          .withOpacity(0.07),
                                  borderRadius:
                                      BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.orange
                                        : Colors.white24,
                                  ),
                                ),
                                child: Text(cls.name,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.white70,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    )),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Class actions row
                      if (_selectedClass != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Text(
                                  '${_students.length} student${_students.length == 1 ? '' : 's'}',
                                  style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 13),
                                ),
                                const SizedBox(width: 16),
                                TextButton.icon(
                                  onPressed: () => _showInviteCode(
                                      _selectedClass!),
                                  icon: const Icon(Icons.share,
                                      size: 16,
                                      color: Colors.orange),
                                  label: const Text('Invite Code',
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontSize: 13)),
                                ),
                                TextButton.icon(
                                  onPressed: () => _showAssignScenariosSheet(
                                      _selectedClass!),
                                  icon: const Icon(Icons.add_task,
                                      size: 16,
                                      color: Color(0xFF88CEFF)),
                                  label: const Text('Scenarios',
                                      style: TextStyle(
                                          color: Color(0xFF88CEFF),
                                          fontSize: 13)),
                                ),
                                TextButton.icon(
                                  onPressed: () =>
                                      _confirmDeleteClass(
                                          _selectedClass!),
                                  icon: const Icon(
                                      Icons.delete_outline,
                                      size: 16,
                                      color: Color(0xFFEF5350)),
                                  label: const Text('Delete',
                                      style: TextStyle(
                                          color: Color(0xFFEF5350),
                                          fontSize: 13)),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Students list
                      Expanded(
                        child: _loadingStudents
                            ? const Center(
                                child: CircularProgressIndicator(
                                    color: Colors.orange))
                            : _students.isEmpty
                                ? const Center(
                                    child: Text(
                                      'No students yet.\nShare the invite code to get started.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white38),
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.all(16),
                                    itemCount: _students.length,
                                    itemBuilder: (context, index) {
                                      final student =
                                          _students[index];
                                      return _buildStudentCard(
                                          student);
                                    },
                                  ),
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

  Widget _buildStudentCard(StudentSummary student) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/student-detail',
          arguments: student,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: Colors.orange.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      Colors.orange.withOpacity(0.2),
                  child: Text(
                    student.username[0].toUpperCase(),
                    style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(student.username,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        '${student.sessionCount} sessions • '
                        'G: ${student.avgGrammar?.toStringAsFixed(1) ?? '-'} '
                        'V: ${student.avgVocabulary?.toStringAsFixed(1) ?? '-'} '
                        'P: ${student.avgPronunciation?.toStringAsFixed(1) ?? '-'}',
                        style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right,
                    color: Colors.white38),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
