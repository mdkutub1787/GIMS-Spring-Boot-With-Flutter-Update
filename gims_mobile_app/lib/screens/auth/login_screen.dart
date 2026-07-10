import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../core/routing/app_router.dart';

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
      final role = ref.read(authViewModelProvider).role;
      if (role == 'ADMIN') {
        Navigator.pushReplacementNamed(context, AppRouter.home);
      } else {
        Navigator.pushReplacementNamed(context, AppRouter.localOffice);
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ref.read(authViewModelProvider).error ?? 'Login Failed'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                Icon(Icons.security, size: 80, color: theme.colorScheme.primary),
                const SizedBox(height: 30),
                Text('Insurance Manager', style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold)),
                Text('Sign in to your account', style: GoogleFonts.poppins(color: Colors.grey)),
                const SizedBox(height: 50),
                TextField(
                  controller: emailController,
                  style: GoogleFonts.poppins(fontSize: 14),
                  decoration: _inputDecoration('Username', Icons.person_outline),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  style: GoogleFonts.poppins(fontSize: 14),
                  decoration: _inputDecoration('Password', Icons.lock_outline).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility, size: 20),
                      onPressed: () => setState(() => obscurePassword = !obscurePassword),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pushNamed(context, AppRouter.forgotPassword),
                    child: Text('Forgot Password?', style: GoogleFonts.poppins(color: theme.colorScheme.primary, fontSize: 13)),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: authState.isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: authState.isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text('Sign In', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, AppRouter.registration),
                  child: Text('Don\'t have an account? Register', style: GoogleFonts.poppins(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      filled: true,
      fillColor: Colors.grey[50],
      labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    );
  }
}
