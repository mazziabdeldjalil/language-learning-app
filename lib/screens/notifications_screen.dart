import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/supabase_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> _notifications = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await SupabaseService.getNotifications();
    await SupabaseService.markAllNotificationsRead();
    if (mounted) setState(() { _notifications = data; _loading = false; });
  }

  IconData _iconFor(String type) {
    switch (type) {
      case 'like': return Icons.favorite;
      case 'comment': return Icons.chat_bubble;
      case 'reminder': return Icons.alarm;
      default: return Icons.notifications;
    }
  }

  Color _colorFor(String type) {
    switch (type) {
      case 'like': return Colors.redAccent;
      case 'comment': return const Color(0xFF88CEFF);
      case 'reminder': return Colors.orange;
      default: return Colors.white38;
    }
  }

  String _timeAgo(String createdAt) {
    final dt = DateTime.tryParse(createdAt)?.toLocal();
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text('Notifications',
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 18)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.notifications_off_outlined,
                          color: Colors.white38, size: 64),
                      const SizedBox(height: 16),
                      Text('No notifications yet',
                          style: GoogleFonts.poppins(
                              color: Colors.white38, fontSize: 16)),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _notifications.length,
                  separatorBuilder: (_, __) => const Divider(
                      color: Colors.white10, height: 1),
                  itemBuilder: (context, i) {
                    final n = _notifications[i];
                    final type = n['type'] ?? 'general';
                    final isRead = n['is_read'] ?? true;
                    return Container(
                      decoration: BoxDecoration(
                        color: isRead
                            ? Colors.transparent
                            : Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              _colorFor(type).withOpacity(0.15),
                          child: Icon(_iconFor(type),
                              color: _colorFor(type), size: 20),
                        ),
                        title: Text(n['message'] ?? '',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: isRead
                                    ? FontWeight.normal
                                    : FontWeight.w600)),
                        subtitle: Text(
                            _timeAgo(n['created_at'] ?? ''),
                            style: GoogleFonts.poppins(
                                color: Colors.white38, fontSize: 12)),
                        trailing: !isRead
                            ? Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF88CEFF),
                                  shape: BoxShape.circle,
                                ),
                              )
                            : null,
                      ),
                    );
                  },
                ),
    );
  }
}
