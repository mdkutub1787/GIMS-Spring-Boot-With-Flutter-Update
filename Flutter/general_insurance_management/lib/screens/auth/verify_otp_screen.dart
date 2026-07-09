import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../core/routing/app_router.dart';

class VerifyOtpScreen extends ConsumerStatefulWidget {
  final String? email;
  final bool isForReset;
  const VerifyOtpScreen({super.key, this.email, this.isForReset = true});

  @override
  ConsumerState<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends ConsumerState<VerifyOtpScreen> {
  final codeController = TextEditingController();

  void _handleVerify() async {
    if (codeController.text.isEmpty) return;

    bool success;
    if (widget.isForReset) {
      success = await ref.read(authViewModelProvider.notifier).verifyResetCode(codeController.text);
    } else {
      success = await ref.read(authViewModelProvider.notifier).verifyOtp(codeController.text);
    }

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ref.read(authViewModelProvider).message ?? 'Verification Successful'), backgroundColor: Colors.green),
      );
      if (widget.isForReset) {
        Navigator.pushNamed(context, AppRouter.resetPassword, arguments: widget.email);
      } else {
        Navigator.pushReplacementNamed(context, AppRouter.login);
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ref.read(authViewModelProvider).error ?? 'Verification Failed'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Verify Code', style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('Enter the 6-digit code sent to ${widget.email ?? 'your email'}', style: GoogleFonts.poppins(color: Colors.grey)),
              const SizedBox(height: 50),
              TextField(
                controller: codeController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 10),
                decoration: InputDecoration(
                  hintText: '000000',
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: authState.isLoading ? null : _handleVerify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: authState.isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('Verify Code', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
