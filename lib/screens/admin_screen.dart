import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/supabase_service.dart';
import '../core/backend.dart';
import '../data/learn_content.dart';
import '../providers/theme_provider.dart';
import 'admin_test_chat_screen.dart';
import '../services/library_service.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _posts = [];
  Map<String, dynamic> _stats = {};
  bool _loadingUsers = true;
  bool _loadingPosts = true;
  bool _loadingStats = true;
  List<ScenarioModel> _scenarios = [];
  bool _scenariosLoading = false;
  int _weeklyLimit = 2;
  String _libraryCategory = 'short_story';
  List<Map<String, dynamic>> _libraryItems = [];
  bool _libraryLoading = false;

  static const Map<String, String> _categoryLabels = {
    'short_story': 'Short Stories',
    'children_story': 'Children\'s Stories',
    'reading_passage': 'Reading Passages',
    'idiom': 'Idioms',
    'grammar_guide': 'Grammar Guides',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 3 && !_tabController.indexIsChanging) {
        if (_libraryItems.isEmpty) _loadLibraryItems();
      }
    });
    _loadAll();
    _loadAdminScenarios();
  }

  Future<void> _loadAll() async {
    _loadUsers();
    _loadPosts();
    _loadStats();
  }

  Future<void> _loadUsers() async {
    setState(() => _loadingUsers = true);
    final users = await SupabaseService.getAllUsers();
    if (mounted) setState(() { _users = users; _loadingUsers = false; });
  }

  Future<void> _loadPosts() async {
    setState(() => _loadingPosts = true);
    final posts = await SupabaseService.getAllPosts();
    if (mounted) setState(() { _posts = posts; _loadingPosts = false; });
  }

  Future<void> _loadStats() async {
    setState(() => _loadingStats = true);
    final stats = await SupabaseService.getAppStats();
    if (mounted) setState(() { _stats = stats; _loadingStats = false; });
  }

  Future<void> _loadAdminScenarios() async {
    setState(() => _scenariosLoading = true);
    _scenarios = await SupabaseService.getAllScenarios();
    // load quota setting
    try {
      final limitStr = await SupabaseService.getAppSetting('custom_scenario_weekly_limit');
      _weeklyLimit = int.tryParse(limitStr ?? '2') ?? 2;
    } catch (_) {}
    if (mounted) setState(() => _scenariosLoading = false);
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) { return dateStr; }
  }

  String _timeAgo(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 1) return 'just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    } catch (_) { return ''; }
  }

  Future<void> _updateRole(String userId, String newRole) async {
    await SupabaseService.client.from('profiles').update({'role': newRole}).eq('id', userId);
    _loadUsers();
  }

  Future<void> _deleteUser(String userId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Delete User', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure? This cannot be undone.', style: TextStyle(color: Color(0xFFDDC1AE))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Color(0xFFEF5350))),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await SupabaseService.client.from('profiles').delete().eq('id', userId);
      _loadUsers();
    }
  }

  Future<void> _deletePost(String postId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Delete Post', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to delete this post?', style: TextStyle(color: Color(0xFFDDC1AE))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Color(0xFFEF5350))),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await SupabaseService.adminDeletePost(postId);
      _loadPosts();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      appBar: AppBar(
        backgroundColor: const Color(0xFF131313),
        elevation: 0,
        toolbarHeight: 70,
        titleSpacing: 12,
        iconTheme: IconThemeData(color: themeProvider.primaryColor),
        title: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            'FluentlyDZ',
            style: TextStyle(
              color: themeProvider.primaryColor,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: themeProvider.primaryColor),
            onPressed: _loadAll,
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: themeProvider.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
              tabs: const [
                Tab(icon: Icon(Icons.people, size: 18), text: 'Users'),
                Tab(icon: Icon(Icons.article, size: 18), text: 'Posts'),
                Tab(icon: Icon(Icons.gamepad, size: 18), text: 'Scenarios'),
                Tab(icon: Icon(Icons.library_books, size: 18), text: 'Library'),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF131313),
              themeProvider.primaryColor.withOpacity(0.03),
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Admin panel',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.6,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Manage users, posts, and app health',
                        style: TextStyle(
                          color: Color(0xFFDDC1AE),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: themeProvider.primaryColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: themeProvider.primaryColor.withOpacity(0.25),
                      ),
                    ),
                    child: Text(
                      'Live',
                      style: TextStyle(
                        color: themeProvider.primaryColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildUsersTab(themeProvider),
                  _buildPostsTab(themeProvider),
                  _buildScenariosTab(),
                  _buildLibraryTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersTab(ThemeProvider themeProvider) {
    if (_loadingUsers) {
      return Center(child: CircularProgressIndicator(color: themeProvider.primaryColor));
    }
    return RefreshIndicator(
      onRefresh: _loadUsers,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: themeProvider.primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: themeProvider.primaryColor.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statPill('👥', '${_users.length}', 'Users', themeProvider),
                _statPill('💬', '${_stats['total_sessions'] ?? 0}', 'Sessions', themeProvider),
                _statPill('📝', '${_stats['total_posts'] ?? 0}', 'Posts', themeProvider),
                _statPill('🗨️', '${_stats['total_comments'] ?? 0}', 'Comments', themeProvider),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                final role = user['role'] ?? 'user';
                final isAdmin = role == 'admin';
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isAdmin
                          ? themeProvider.primaryColor.withOpacity(0.3)
                          : Colors.white.withOpacity(0.08),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42, height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: themeProvider.primaryColor.withOpacity(0.15),
                        ),
                        child: Center(
                          child: Text(
                            (user['username'] ?? user['email'] ?? 'U')[0].toUpperCase(),
                            style: TextStyle(color: themeProvider.primaryColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user['username'] ?? 'No username yet',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
                            Text(user['email'] ?? '',
                                style: const TextStyle(color: Color(0xFFDDC1AE), fontSize: 12)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isAdmin
                                        ? const Color(0xFF2ECC71).withOpacity(0.2)
                                        : role == 'teacher'
                                            ? Colors.orange.withOpacity(0.2)
                                            : Colors.white.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(role,
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: isAdmin
                                              ? const Color(0xFF2ECC71)
                                              : role == 'teacher'
                                                  ? Colors.orange
                                                  : const Color(0xFFDDC1AE))),
                                ),
                                const SizedBox(width: 8),
                                Text('Joined: ${_formatDate(user['created_at'])}',
                                    style: const TextStyle(fontSize: 10, color: Colors.white38)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.white38),
                        color: const Color(0xFF1E1E1E),
                        onSelected: (value) {
                          if (value == 'make_admin') {
                            _updateRole(user['id'], 'admin');
                          } else if (value == 'remove_admin') {
                            _updateRole(user['id'], 'user');
                          } else if (value == 'make_teacher') {
                            _updateRole(user['id'], 'teacher');
                          } else if (value == 'remove_teacher') {
                            _updateRole(user['id'], 'user');
                          } else if (value == 'delete') {
                            _deleteUser(user['id']);
                          }
                        },
                        itemBuilder: (_) => [
                          if (role == 'user')
                            const PopupMenuItem(value: 'make_admin',
                                child: Text('Make Admin', style: TextStyle(color: Colors.white))),
                          if (role == 'admin')
                            const PopupMenuItem(value: 'remove_admin',
                                child: Text('Remove Admin', style: TextStyle(color: Colors.white))),
                          if (role == 'user')
                            const PopupMenuItem(value: 'make_teacher',
                                child: Text('Make Teacher', style: TextStyle(color: Colors.white))),
                          if (role == 'teacher')
                            const PopupMenuItem(value: 'remove_teacher',
                                child: Text('Remove Teacher', style: TextStyle(color: Colors.white))),
                          const PopupMenuItem(value: 'delete',
                              child: Text('Delete User', style: TextStyle(color: Color(0xFFEF5350)))),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsTab(ThemeProvider themeProvider) {
    if (_loadingPosts) {
      return Center(child: CircularProgressIndicator(color: themeProvider.primaryColor));
    }
    return RefreshIndicator(
      onRefresh: _loadPosts,
      child: _posts.isEmpty
          ? const Center(child: Text('No posts yet', style: TextStyle(color: Color(0xFFDDC1AE))))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38, height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: themeProvider.primaryColor.withOpacity(0.15),
                        ),
                        child: Center(
                          child: Text(
                            (post['username'] ?? 'U')[0].toUpperCase(),
                            style: TextStyle(color: themeProvider.primaryColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(post['username'] ?? 'unknown',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13)),
                            const SizedBox(height: 4),
                            Text(post['content'] ?? '',
                                style: const TextStyle(color: Color(0xFFDDC1AE), fontSize: 13),
                                maxLines: 2, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.favorite, size: 13, color: Color(0xFFEF5350)),
                                const SizedBox(width: 4),
                                Text('${post['likes'] ?? 0}',
                                    style: const TextStyle(fontSize: 11, color: Colors.white38)),
                                const SizedBox(width: 12),
                                const Icon(Icons.access_time, size: 13, color: Colors.white38),
                                const SizedBox(width: 4),
                                Text(_timeAgo(post['created_at']),
                                    style: const TextStyle(fontSize: 11, color: Colors.white38)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Color(0xFFFFB4AB), size: 20),
                        onPressed: () => _deletePost(post['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildStatsTab(ThemeProvider themeProvider) {
    if (_loadingStats) {
      return Center(child: CircularProgressIndicator(color: themeProvider.primaryColor));
    }
    final statItems = [
      {'icon': Icons.people, 'color': themeProvider.primaryColor, 'value': '${_stats['total_users'] ?? 0}', 'label': 'Total Users'},
      {'icon': Icons.chat_bubble, 'color': const Color(0xFF2ECC71), 'value': '${_stats['total_sessions'] ?? 0}', 'label': 'Total Sessions'},
      {'icon': Icons.article, 'color': const Color(0xFF88CEFF), 'value': '${_stats['total_posts'] ?? 0}', 'label': 'Total Posts'},
      {'icon': Icons.comment, 'color': const Color(0xFFC0C1FF), 'value': '${_stats['total_comments'] ?? 0}', 'label': 'Total Comments'},
      {'icon': Icons.spellcheck, 'color': const Color(0xFF4ECDC4), 'value': '${(_stats['avg_grammar'] as double? ?? 0).toStringAsFixed(1)}/10', 'label': 'Avg Grammar'},
      {'icon': Icons.book, 'color': const Color(0xFFFFD700), 'value': '${(_stats['avg_vocab'] as double? ?? 0).toStringAsFixed(1)}/10', 'label': 'Avg Vocabulary'},
      {'icon': Icons.mic, 'color': const Color(0xFFFF8A00), 'value': '${(_stats['avg_pronunciation'] as double? ?? 0).toStringAsFixed(1)}/10', 'label': 'Avg Pronunciation'},
    ];

    return RefreshIndicator(
      onRefresh: _loadStats,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 16,
          mainAxisSpacing: 16, childAspectRatio: 1.2,
        ),
        itemCount: statItems.length,
        itemBuilder: (context, index) {
          final item = statItems[index];
          final color = item['color'] as Color;
          return Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
                  child: Icon(item['icon'] as IconData, color: color, size: 26),
                ),
                const SizedBox(height: 8),
                Text(item['value'] as String,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
                const SizedBox(height: 4),
                Text(item['label'] as String,
                    style: const TextStyle(fontSize: 11, color: Color(0xFFDDC1AE)),
                    textAlign: TextAlign.center),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statPill(String emoji, String value, String label, ThemeProvider themeProvider) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        Text(value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: themeProvider.primaryColor)),
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFFDDC1AE))),
      ],
    );
  }

  Widget _buildScenariosTab() {
    if (_scenariosLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.tune, color: Colors.orange, size: 20),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('Custom Scenarios / Week',
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, color: Colors.white54),
                  onPressed: _weeklyLimit <= 0 ? null : () async {
                    final newLimit = _weeklyLimit - 1;
                    await SupabaseService.updateAppSetting(
                        'custom_scenario_weekly_limit', newLimit.toString());
                    setState(() => _weeklyLimit = newLimit);
                  },
                ),
                Text('$_weeklyLimit',
                    style: const TextStyle(color: Colors.white,
                        fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Colors.orange),
                  onPressed: () async {
                    final newLimit = _weeklyLimit + 1;
                    await SupabaseService.updateAppSetting(
                        'custom_scenario_weekly_limit', newLimit.toString());
                    setState(() => _weeklyLimit = newLimit);
                  },
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: _showAddScenarioDialog,
            icon: const Icon(Icons.add),
            label: const Text('Add Scenario'),
          ),
        ),
        Expanded(
          child: _scenarios.isEmpty
              ? const Center(child: Text('No scenarios yet', style: TextStyle(color: Colors.white54)))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  itemCount: _scenarios.length,
                  itemBuilder: (context, index) {
                    final scenario = _scenarios[index];
                    return Card(
                      color: Colors.white.withOpacity(0.07),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: Icon(
                          scenario.isActive ? Icons.check_circle : Icons.cancel,
                          color: scenario.isActive ? Color(0xFF2ECC71) : Colors.white38,
                        ),
                        title: Text(scenario.title, style: const TextStyle(color: Colors.white)),
                        subtitle: Text(scenario.description, style: const TextStyle(color: Colors.white54)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Switch(
                              value: scenario.isActive,
                              onChanged: (val) async {
                                await SupabaseService.updateScenarioStatus(scenario.id, val);
                                _loadAdminScenarios();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.science, color: Colors.orange),
                              tooltip: 'Test this scenario',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AdminTestChatScreen(scenario: scenario),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_note, color: Color(0xFF88CEFF)),
                              onPressed: () => _showEditScenarioDialog(scenario),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Color(0xFFEF5350)),
                              onPressed: () => _confirmDeleteScenario(scenario),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Future<void> _loadLibraryItems() async {
    if (mounted) setState(() => _libraryLoading = true);
    final items = await LibraryService.fetchAllContent(_libraryCategory);
    if (mounted) setState(() {
      _libraryItems = items;
      _libraryLoading = false;
    });
  }

  Widget _buildLibraryTab() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      children: [
        Container(
          height: 48,
          color: const Color(0xFF1E1E1E),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            children: _categoryLabels.entries.map((entry) {
              final selected = _libraryCategory == entry.key;
              return GestureDetector(
                onTap: () {
                  setState(() => _libraryCategory = entry.key);
                  _loadLibraryItems();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: selected ? themeProvider.primaryColor : Colors.white10,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    entry.value,
                    style: TextStyle(
                      color: selected ? Colors.black : Colors.white70,
                      fontSize: 12,
                      fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeProvider.primaryColor,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.add),
              label: Text('Add ${_categoryLabels[_libraryCategory] ?? 'Item'}'),
              onPressed: () => _showAddLibraryItemDialog(),
            ),
          ),
        ),
        Expanded(
          child: _libraryLoading
              ? const Center(child: CircularProgressIndicator())
              : _libraryItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.library_books,
                              color: Colors.white24, size: 48),
                          const SizedBox(height: 12),
                          Text(
                            'No ${_categoryLabels[_libraryCategory]} yet',
                            style: const TextStyle(
                                color: Colors.white38, fontSize: 14),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: _libraryItems.length,
                      itemBuilder: (context, index) {
                        final item = _libraryItems[index];
                        final isActive = item['is_active'] ?? true;
                        return Card(
                          color: const Color(0xFF1E1E1E),
                          margin: const EdgeInsets.only(bottom: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  themeProvider.primaryColor.withOpacity(0.15),
                              child: Icon(Icons.library_books,
                                  color: themeProvider.primaryColor, size: 18),
                            ),
                            title: Text(
                              item['title'] ?? '',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                            subtitle: Text(
                              item['difficulty'] ?? '',
                              style: const TextStyle(
                                  color: Colors.white38, fontSize: 12),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Switch(
                                  value: isActive,
                                  onChanged: (val) async {
                                    await LibraryService.toggleActive(
                                        item['id'], val);
                                    _loadLibraryItems();
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit_note,
                                      color: Color(0xFF88CEFF)),
                                  onPressed: () =>
                                      _showEditLibraryItemDialog(item),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline,
                                      color: Color(0xFFEF5350)),
                                  onPressed: () =>
                                      _confirmDeleteLibraryItem(item),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  void _showAddLibraryItemDialog() {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();
    final extraCtrl = TextEditingController();
    String difficulty = 'beginner';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: Text(
            'Add ${_categoryLabels[_libraryCategory] ?? 'Item'}',
            style: const TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: Colors.white54),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24)),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: difficulty,
                  dropdownColor: const Color(0xFF1E1E1E),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Difficulty',
                    labelStyle: TextStyle(color: Colors.white54),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24)),
                  ),
                  items: ['beginner', 'intermediate', 'advanced']
                      .map((d) => DropdownMenuItem(
                            value: d,
                            child: Text(d,
                                style: const TextStyle(color: Colors.white)),
                          ))
                      .toList(),
                  onChanged: (v) => setS(() => difficulty = v!),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: bodyCtrl,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 6,
                  decoration: InputDecoration(
                    labelText: _libraryCategory == 'idiom'
                        ? 'Meaning'
                        : _libraryCategory == 'grammar_guide'
                            ? 'Explanation'
                            : 'Body / Content',
                    labelStyle: const TextStyle(color: Colors.white54),
                    enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: extraCtrl,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: _libraryCategory == 'idiom'
                        ? 'Example sentence'
                        : _libraryCategory == 'grammar_guide'
                            ? 'Common mistake'
                            : _libraryCategory == 'children_story'
                                ? 'Moral of the story'
                                : _libraryCategory == 'reading_passage'
                                    ? 'Topic (e.g. Technology)'
                                    : 'Origin / Author',
                    labelStyle: const TextStyle(color: Colors.white54),
                    enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.white38)),
            ),
            TextButton(
              onPressed: () async {
                if (titleCtrl.text.trim().isEmpty ||
                    bodyCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Title and main content are required')),
                  );
                  return;
                }
                final id =
                    '${_libraryCategory.substring(0, 1)}${DateTime.now().millisecondsSinceEpoch}';
                final content = _buildContentMap(
                  category: _libraryCategory,
                  body: bodyCtrl.text.trim(),
                  extra: extraCtrl.text.trim(),
                );
                final ok = await LibraryService.createContent(
                  id: id,
                  category: _libraryCategory,
                  title: titleCtrl.text.trim(),
                  difficulty: difficulty,
                  sortOrder: _libraryItems.length + 1,
                  content: content,
                );
                if (ok && ctx.mounted) {
                  Navigator.pop(ctx);
                  _loadLibraryItems();
                }
              },
              child: const Text('Add',
                  style: TextStyle(color: Color(0xFF88CEFF))),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditLibraryItemDialog(Map<String, dynamic> item) {
    final c = Map<String, dynamic>.from(item['content'] ?? {});
    final titleCtrl = TextEditingController(text: item['title'] ?? '');
    final bodyCtrl = TextEditingController(
      text: c['body'] ?? c['meaning'] ?? c['explanation'] ?? '',
    );
    final extraCtrl = TextEditingController(
      text: c['example'] ?? c['moral'] ?? c['topic'] ??
          c['origin'] ?? c['commonMistake'] ?? '',
    );
    String difficulty = item['difficulty'] ?? 'beginner';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text('Edit Item',
              style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: Colors.white54),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24)),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: difficulty,
                  dropdownColor: const Color(0xFF1E1E1E),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Difficulty',
                    labelStyle: TextStyle(color: Colors.white54),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24)),
                  ),
                  items: ['beginner', 'intermediate', 'advanced']
                      .map((d) => DropdownMenuItem(
                            value: d,
                            child: Text(d,
                                style:
                                    const TextStyle(color: Colors.white)),
                          ))
                      .toList(),
                  onChanged: (v) => setS(() => difficulty = v!),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: bodyCtrl,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 6,
                  decoration: InputDecoration(
                    labelText: _libraryCategory == 'idiom'
                        ? 'Meaning'
                        : _libraryCategory == 'grammar_guide'
                            ? 'Explanation'
                            : 'Body / Content',
                    labelStyle: const TextStyle(color: Colors.white54),
                    enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: extraCtrl,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: _libraryCategory == 'idiom'
                        ? 'Example sentence'
                        : _libraryCategory == 'grammar_guide'
                            ? 'Common mistake'
                            : _libraryCategory == 'children_story'
                                ? 'Moral of the story'
                                : _libraryCategory == 'reading_passage'
                                    ? 'Topic'
                                    : 'Origin / Author',
                    labelStyle: const TextStyle(color: Colors.white54),
                    enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.white38)),
            ),
            TextButton(
              onPressed: () async {
                final content = _buildContentMap(
                  category: _libraryCategory,
                  body: bodyCtrl.text.trim(),
                  extra: extraCtrl.text.trim(),
                  existing: c,
                );
                final ok = await LibraryService.updateContent(
                  id: item['id'],
                  title: titleCtrl.text.trim(),
                  difficulty: difficulty,
                  content: content,
                );
                if (ok && ctx.mounted) {
                  Navigator.pop(ctx);
                  _loadLibraryItems();
                }
              },
              child: const Text('Save',
                  style: TextStyle(color: Color(0xFF88CEFF))),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _buildContentMap({
    required String category,
    required String body,
    required String extra,
    Map<String, dynamic>? existing,
  }) {
    switch (category) {
      case 'idiom':
        return {
          'meaning': body,
          'example': extra,
          'category': existing?['category'] ?? 'General',
          if (existing?['origin'] != null) 'origin': existing!['origin'],
        };
      case 'grammar_guide':
        return {
          'explanation': body,
          'commonMistake': extra,
          'examples': existing?['examples'] ?? [],
        };
      case 'children_story':
        return {
          'body': body,
          'moral': extra,
          'origin': existing?['origin'] ?? '',
          'questions': existing?['questions'] ?? [],
        };
      case 'reading_passage':
        return {
          'body': body,
          'topic': extra,
        };
      case 'short_story':
      default:
        return {
          'body': body,
          'origin': extra,
          'questions': existing?['questions'] ?? [],
        };
    }
  }

  Future<void> _confirmDeleteLibraryItem(Map<String, dynamic> item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Delete Item',
            style: TextStyle(color: Colors.white)),
        content: Text(
          'Delete "${item['title']}"? This cannot be undone.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.white38)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete',
                style: TextStyle(color: Color(0xFFEF5350))),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await LibraryService.deleteContent(item['id']);
      _loadLibraryItems();
    }
  }

  void _showAddScenarioDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final promptController = TextEditingController();
    String selectedIcon = 'chat_bubble';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Add Scenario', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.white54),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.white54),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedIcon,
                dropdownColor: const Color(0xFF1E1E1E),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Icon',
                  labelStyle: TextStyle(color: Colors.white54),
                ),
                items: const [
                  DropdownMenuItem(value: 'chat_bubble', child: Text('Chat')),
                  DropdownMenuItem(value: 'work', child: Text('Work')),
                  DropdownMenuItem(value: 'flight', child: Text('Travel')),
                  DropdownMenuItem(value: 'school', child: Text('School')),
                  DropdownMenuItem(value: 'restaurant', child: Text('Restaurant')),
                  DropdownMenuItem(value: 'local_hospital', child: Text('Medical')),
                  DropdownMenuItem(value: 'sports', child: Text('Sports')),
                  DropdownMenuItem(value: 'shopping_cart', child: Text('Shopping')),
                ],
                onChanged: (val) => selectedIcon = val ?? 'chat_bubble',
              ),
              const SizedBox(height: 8),
              TextField(
                controller: promptController,
                style: const TextStyle(color: Colors.white),
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Character Prompt',
                  labelStyle: TextStyle(color: Colors.white54),
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isEmpty || promptController.text.isEmpty) return;
              final scenario = ScenarioModel(
                id: '',
                title: titleController.text.trim(),
                description: descController.text.trim(),
                iconName: selectedIcon,
                characterPrompt: promptController.text.trim(),
                isActive: true,
                createdAt: DateTime.now(),
              );
              await SupabaseService.createScenario(scenario);
              Navigator.pop(ctx);
              _loadAdminScenarios();
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showEditScenarioDialog(ScenarioModel scenario) {
    final titleController = TextEditingController(text: scenario.title);
    final descController = TextEditingController(text: scenario.description);
    final promptController = TextEditingController(text: scenario.characterPrompt);
    String selectedIcon = scenario.iconName;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Edit Scenario', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.white54),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.white54),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedIcon,
                dropdownColor: const Color(0xFF1E1E1E),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Icon',
                  labelStyle: TextStyle(color: Colors.white54),
                ),
                items: const [
                  DropdownMenuItem(value: 'chat_bubble', child: Text('Chat')),
                  DropdownMenuItem(value: 'work', child: Text('Work')),
                  DropdownMenuItem(value: 'flight', child: Text('Travel')),
                  DropdownMenuItem(value: 'school', child: Text('School')),
                  DropdownMenuItem(value: 'restaurant', child: Text('Restaurant')),
                  DropdownMenuItem(value: 'local_hospital', child: Text('Medical')),
                  DropdownMenuItem(value: 'sports', child: Text('Sports')),
                  DropdownMenuItem(value: 'shopping_cart', child: Text('Shopping')),
                ],
                onChanged: (val) => selectedIcon = val ?? scenario.iconName,
              ),
              const SizedBox(height: 12),
              const Text('Character Prompt',
                  style: TextStyle(color: Colors.white54, fontSize: 12)),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white12),
                ),
                child: TextField(
                  controller: promptController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  maxLines: 10,
                  decoration: const InputDecoration(
                    hintText: 'Enter the full character prompt...',
                    hintStyle: TextStyle(color: Colors.white24),
                    contentPadding: EdgeInsets.all(12),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.trim().isEmpty ||
                  promptController.text.trim().isEmpty) return;
              await SupabaseService.updateScenario(
                scenario.id,
                title: titleController.text.trim(),
                description: descController.text.trim(),
                iconName: selectedIcon,
                characterPrompt: promptController.text.trim(),
              );
              Navigator.pop(ctx);
              _loadAdminScenarios();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteScenario(ScenarioModel scenario) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Delete Scenario', style: TextStyle(color: Colors.white)),
        content: Text(
          'Delete "${scenario.title}"? This cannot be undone.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFEF5350)),
            onPressed: () async {
              await SupabaseService.deleteScenario(scenario.id);
              Navigator.pop(ctx);
              _loadAdminScenarios();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}






