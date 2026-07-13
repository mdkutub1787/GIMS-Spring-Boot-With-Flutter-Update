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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Curvy Header
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
                  Text('Welcome Back!', style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 10),
                  Text(
                    'Login to your account by entering your\nusername and password below, we are really\nhappy to see you come back!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.9), fontSize: 13, height: 1.5),
                  ),
                ],
              ),
            ),
            
            // Biometric / Fingerprint Card (overlapping)
            Transform.translate(
              offset: const Offset(0, -30),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: theme.colorScheme.primary.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8)),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.fingerprint, color: Colors.white, size: 30),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('New! Fingerprint', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                          Text('Fast-Login', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        elevation: 0,
                      ),
                      child: Text('Set Up', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12)),
                    )
                  ],
                ),
              ),
            ),

            // Login Form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  TextField(
                    controller: emailController,
                    style: GoogleFonts.poppins(fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'Enter your username',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    style: GoogleFonts.poppins(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Confirm your password',
                      prefixIcon: const Icon(Icons.lock_outline),
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
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: authState.isLoading ? null : _handleLogin,
                      child: authState.isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text('Login', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Doesn\'t have an account yet? ', style: GoogleFonts.poppins(color: Colors.grey)),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, AppRouter.registration),
                        child: Text('Sign Up', style: GoogleFonts.poppins(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
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
