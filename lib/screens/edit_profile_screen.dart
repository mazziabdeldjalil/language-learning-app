import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/backend.dart';
import '../core/supabase_service.dart';
import '../providers/theme_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _usernameController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _savingUsername = false;
  bool _savingPassword = false;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    _usernameController.text = chatProvider.userId;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _saveUsername() async {
    final newUsername = _usernameController.text.trim();
    if (newUsername.isEmpty) return;
    setState(() => _savingUsername = true);
    final success = await SupabaseService.updateUsername(newUsername);
    if (success && mounted) {
      Provider.of<ChatProvider>(context, listen: false).setUsername(newUsername);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username updated successfully!'),
          backgroundColor: Color(0xFF2ECC71),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update username. Try again.'),
          backgroundColor: Color(0xFFEF5350),
        ),
      );
    }
    if (mounted) setState(() => _savingUsername = false);
  }

  Future<void> _savePassword() async {
    final newPass = _newPasswordController.text.trim();
    final confirmPass = _confirmPasswordController.text.trim();
    if (newPass.isEmpty || confirmPass.isEmpty) return;
    if (newPass != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match.'),
          backgroundColor: Color(0xFFEF5350),
        ),
      );
      return;
    }
    if (newPass.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters.'),
          backgroundColor: Color(0xFFEF5350),
        ),
      );
      return;
    }
    setState(() => _savingPassword = true);
    final success = await SupabaseService.updatePassword(newPass);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'Password updated successfully!'
              : 'Failed to update password. Try again.'),
          backgroundColor:
              success ? const Color(0xFF2ECC71) : const Color(0xFFEF5350),
        ),
      );
      if (success) {
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      }
      setState(() => _savingPassword = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/profile.png'),
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
                    const Text('Edit Profile',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Username section
                      Text('Username',
                          style: TextStyle(
                              color: themeProvider.primaryColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Column(
                          children: [
                            TextField(
                              controller: _usernameController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'New Username',
                                labelStyle: const TextStyle(
                                    color: Colors.white54),
                                prefixIcon: Icon(Icons.person_outline,
                                    color: themeProvider.primaryColor),
                                border: InputBorder.none,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      themeProvider.primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)),
                                ),
                                onPressed: _savingUsername
                                    ? null
                                    : _saveUsername,
                                child: _savingUsername
                                    ? const SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2))
                                    : const Text('Save Username',
                                        style: TextStyle(
                                            color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Password section
                      Text('Change Password',
                          style: TextStyle(
                              color: themeProvider.primaryColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Column(
                          children: [
                            TextField(
                              controller: _newPasswordController,
                              obscureText: _obscureNew,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'New Password',
                                labelStyle: const TextStyle(
                                    color: Colors.white54),
                                prefixIcon: Icon(Icons.lock_outline,
                                    color: themeProvider.primaryColor),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureNew
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.white38,
                                  ),
                                  onPressed: () => setState(
                                      () => _obscureNew = !_obscureNew),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                            const Divider(color: Colors.white12),
                            TextField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirm,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Confirm New Password',
                                labelStyle: const TextStyle(
                                    color: Colors.white54),
                                prefixIcon: Icon(Icons.lock_outline,
                                    color: themeProvider.primaryColor),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirm
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.white38,
                                  ),
                                  onPressed: () => setState(() =>
                                      _obscureConfirm = !_obscureConfirm),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: themeProvider.primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: _savingPassword ? null : _savePassword,
                                child: _savingPassword
                                    ? const SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2))
                                    : const Text('Update Password',
                                        style: TextStyle(
                                            color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
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