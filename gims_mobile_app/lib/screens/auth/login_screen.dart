import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../core/routing/app_router.dart';
import '../../viewmodels/settings_viewmodel.dart';
import '../../core/localization/app_localizations.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController(text: 'kutub');
  final passwordController = TextEditingController(text: '11111111');
  bool obscurePassword = true;

  void _handleLogin() async {
    final success = await ref.read(authViewModelProvider.notifier).login(
      emailController.text,
      passwordController.text,
    );

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, AppRouter.home);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ref.read(authViewModelProvider).error ?? 'Login Failed'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final settingsState = ref.watch(settingsViewModelProvider);
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Curvy Header with Language Selector
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 80, bottom: 60, left: 30, right: 30),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(loc.get('login_welcome'), style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 10),
                      Text(
                        loc.get('login_subtitle'),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.9), fontSize: 13, height: 1.5),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: settingsState.locale.languageCode,
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
                        isDense: true,
                        dropdownColor: theme.colorScheme.primary,
                        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            ref.read(settingsViewModelProvider.notifier).setLocale(Locale(newValue));
                          }
                        },
                        items: const [
                          DropdownMenuItem(value: 'en', child: Text('EN')),
                          DropdownMenuItem(value: 'bn', child: Text('BN')),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 30),

            // Login Form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  TextField(
                    controller: emailController,
                    style: GoogleFonts.poppins(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: loc.get('login_email_hint'),
                      prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF7C3AED)),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    style: GoogleFonts.poppins(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: loc.get('login_password_hint'),
                      prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF7C3AED)),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 1.5),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility, size: 20, color: Colors.grey),
                        onPressed: () => setState(() => obscurePassword = !obscurePassword),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(context, AppRouter.forgotPassword),
                      child: Text(loc.get('login_forgot_password'), style: GoogleFonts.poppins(color: theme.colorScheme.primary, fontSize: 13)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7C3AED).withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: authState.isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: authState.isLoading 
                        ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                        : Text(loc.get('login_button'), style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(loc.get('login_no_account'), style: GoogleFonts.poppins(color: Colors.grey)),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, AppRouter.registration),
                        child: Text(loc.get('login_signup'), style: GoogleFonts.poppins(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
