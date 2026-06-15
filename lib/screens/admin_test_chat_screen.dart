import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/backend.dart';
import '../core/supabase_service.dart';

class AdminTestChatScreen extends StatefulWidget {
  final ScenarioModel scenario;

  const AdminTestChatScreen({super.key, required this.scenario});

  @override
  State<AdminTestChatScreen> createState() => _AdminTestChatScreenState();
}

class _AdminTestChatScreenState extends State<AdminTestChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];
  bool _loading = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initTest();
  }

  Future<void> _initTest() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // No need to touch ChatProvider at all — test chat is self-contained
      setState(() => _initialized = true);
    });
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _loading) return;
    _controller.clear();

    setState(() {
      _messages.add(Message(role: 'user', content: text));
      _loading = true;
    });
    _scrollToBottom();

    try {
      final username = await SupabaseService.getProfile()
          .then((p) => p?['username'] ?? 'admin');

      final response = await ApiService().sendMessage(
        userId: username,
        message: text,
        scenario: 'casual',
        difficulty: 'intermediate',
        history: _messages,
        customPrompt: widget.scenario.characterPrompt,
      );

      if (mounted) {
        setState(() {
          _messages.add(Message(role: 'assistant', content: response.response));
          _loading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(Message(role: 'assistant', content: '⚠️ Error: ${e.toString()}'));
          _loading = false;
        });
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.scenario.title,
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            Row(
              children: [
                const Icon(Icons.science, color: Colors.orange, size: 12),
                const SizedBox(width: 4),
                Text(
                  'Test Mode — not saved',
                  style: GoogleFonts.poppins(
                      color: Colors.orange, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.exit_to_app, color: Colors.redAccent),
            label: Text('Exit Test',
                style: GoogleFonts.poppins(color: Colors.redAccent)),
          ),
        ],
      ),
      body: !_initialized
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Test mode banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16),
                  color: Colors.orange.withOpacity(0.15),
                  child: Row(
                    children: [
                      const Icon(Icons.science,
                          color: Colors.orange, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Testing "${widget.scenario.title}" — this session will not be saved or counted',
                          style: GoogleFonts.poppins(
                              color: Colors.orange, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                // Messages
                Expanded(
                  child: _messages.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.science,
                                  color: Colors.white24, size: 48),
                              const SizedBox(height: 12),
                              Text(
                                'Start testing the scenario\nby sending a message',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    color: Colors.white38, fontSize: 14),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final msg = _messages[index];
                            final isUser = msg.role == 'user';
                            return Align(
                              alignment: isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin:
                                    const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width *
                                          0.75,
                                ),
                                decoration: BoxDecoration(
                                  color: isUser
                                      ? const Color(0xFF88CEFF)
                                          .withOpacity(0.2)
                                      : const Color(0xFF1E1E1E),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isUser
                                        ? const Color(0xFF88CEFF)
                                            .withOpacity(0.3)
                                        : Colors.white12,
                                  ),
                                ),
                                child: Text(
                                  msg.content,
                                  style: GoogleFonts.poppins(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                // Loading indicator
                if (_loading)
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                // Input
                Container(
                  padding: const EdgeInsets.all(12),
                  color: const Color(0xFF1E1E1E),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Type a message to test...',
                            hintStyle:
                                const TextStyle(color: Colors.white38),
                            filled: true,
                            fillColor: const Color(0xFF131313),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: const Color(0xFF88CEFF),
                        child: IconButton(
                          icon: const Icon(Icons.send,
                              color: Colors.black, size: 18),
                          onPressed: _sendMessage,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
