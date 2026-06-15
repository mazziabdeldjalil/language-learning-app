import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/supabase_config.dart';
import '../providers/theme_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/help_dialog.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreedToTerms = false;
  String? _error;

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;
    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      setState(() => _error = 'Please fill all fields');
      return;
    }
    if (password.length < 6) {
      setState(() => _error = 'Password must be at least 6 characters');
      return;
    }
    if (password != confirm) {
      setState(() => _error = 'Passwords do not match');
      return;
    }
    setState(() { _isLoading = true; _error = null; });
    try {
      await SupabaseConfig.client.auth.signUp(email: email, password: password);
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text('Registration successful',
              style: TextStyle(color: Colors.white)),
          content: const Text('Check your email to confirm your account',
              style: TextStyle(color: Color(0xFFDDC1AE))),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('AuthException: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

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
          child: Stack(
            children: [
              // Top bar with logo and help
              Positioned(
                top: 16,
                left: 24,
                right: 24,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'FluentlyDZ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: themeProvider.primaryColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    TextButton(
                      onPressed: () => showHelpDialog(context),
                      child: const Text(
                        'HELP',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Main content
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 80),

                      const Text('Start learning',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800,
                            color: Colors.white, letterSpacing: -0.5)),
                      const SizedBox(height: 8),
                      const Text('Create your account and unlock personalized learning',
                        style: TextStyle(fontSize: 14, color: Color(0xFFDDC1AE)),
                        textAlign: TextAlign.center),
                      const SizedBox(height: 36),

                      // Glass card
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E1E).withOpacity(0.85),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                  color: themeProvider.primaryColor.withOpacity(0.3)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Full Name field
                                const Text('FULL NAME',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                                      color: Colors.white, letterSpacing: 0.5)),
                                const SizedBox(height: 8),
                                _buildField(
                                  controller: _nameController,
                                  hint: 'John Doe',
                                  icon: Icons.person_outline,
                                  themeProvider: themeProvider,
                                  keyboardType: TextInputType.name,
                                ),
                                const SizedBox(height: 16),

                                // Email
                                const Text('EMAIL ADDRESS',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                                      color: Colors.white, letterSpacing: 0.5)),
                                const SizedBox(height: 8),
                                _buildField(
                                  controller: _emailController,
                                  hint: 'name@example.com',
                                  icon: Icons.email_outlined,
                                  themeProvider: themeProvider,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 16),

                                // Password
                                const Text('PASSWORD',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                                      color: Colors.white, letterSpacing: 0.5)),
                                const SizedBox(height: 8),
                                _buildField(
                                  controller: _passwordController,
                                  hint: 'Min 6 characters',
                                  icon: Icons.lock_outline,
                                  themeProvider: themeProvider,
                                  obscure: _obscurePassword,
                                  onToggleObscure: () => setState(
                                      () => _obscurePassword = !_obscurePassword),
                                ),
                                const SizedBox(height: 16),

                                // Confirm Password
                                const Text('CONFIRM PASSWORD',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                                      color: Colors.white, letterSpacing: 0.5)),
                                const SizedBox(height: 8),
                                _buildField(
                                  controller: _confirmPasswordController,
                                  hint: 'Confirm password',
                                  icon: Icons.lock_outline,
                                  themeProvider: themeProvider,
                                  obscure: _obscureConfirm,
                                  onToggleObscure: () => setState(
                                      () => _obscureConfirm = !_obscureConfirm),
                                  onSubmitted: (_) => _register(),
                                ),

                                // Terms Checkbox
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _agreedToTerms,
                                      onChanged: (val) {
                                        setState(() => _agreedToTerms = val ?? false);
                                      },
                                      fillColor: WidgetStatePropertyAll(
                                        _agreedToTerms ? themeProvider.primaryColor : Colors.transparent,
                                      ),
                                      side: BorderSide(
                                        color: themeProvider.primaryColor,
                                        width: 1.5,
                                      ),
                                    ),
                                    const Expanded(
                                      child: Text(
                                        'I agree to the Terms of Service and Privacy Policy',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // Error
                                if (_error != null) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEF5350).withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: const Color(0xFFEF5350).withOpacity(0.5)),
                                    ),
                                    child: Text(_error!,
                                        style: const TextStyle(
                                            color: Color(0xFFEF5350), fontSize: 13)),
                                  ),
                                ],
                                const SizedBox(height: 24),

                                // Create Account Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _isLoading || !_agreedToTerms ? null : _register,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: themeProvider.primaryColor,
                                      foregroundColor: const Color(0xFF613100),
                                      disabledBackgroundColor: Colors.grey,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 20, height: 20,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2, color: Colors.white),
                                          )
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              Text('Create Account',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600)),
                                              SizedBox(width: 8),
                                              Icon(Icons.arrow_forward, size: 16),
                                            ],
                                          ),
                                  ),
                                ),


                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Sign In link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account? ',
                              style: TextStyle(fontSize: 13, color: Color(0xFFDDC1AE))),
                          GestureDetector(
                            onTap: _isLoading
                                ? null
                                : () => Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (_) => const LoginScreen()),
                                    ),
                            child: Text('Sign In',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: themeProvider.primaryColor)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              // AI MENTOR badge
              Positioned(
                bottom: 24,
                right: 24,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: themeProvider.primaryColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: themeProvider.primaryColor,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'A',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: themeProvider.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('AI MENTOR ONLINE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                              letterSpacing: 0.5,
                            )),
                          Text('Ready to help',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: themeProvider.primaryColor,
                            )),
                        ],
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

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required ThemeProvider themeProvider,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    VoidCallback? onToggleObscure,
    ValueChanged<String>? onSubmitted,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF888888), fontSize: 13),
          prefixIcon: Icon(icon, color: themeProvider.primaryColor, size: 20),
          suffixIcon: onToggleObscure != null
              ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xFF888888), size: 18,
                  ),
                  onPressed: onToggleObscure,
                  padding: EdgeInsets.zero,
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
