import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../core/routing/app_router.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  String selectedGender = 'male';
  final _formKey = GlobalKey<FormState>();
  bool obscurePassword = true;

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match'), backgroundColor: Colors.red));
        return;
      }

      final userData = {
        "firstname": firstNameController.text,
        "lastname": lastNameController.text,
        "username": usernameController.text,
        "gender": selectedGender,
        "email": emailController.text,
        "phone": phoneController.text,
        "password": passwordController.text,
      };

      final success = await ref.read(authViewModelProvider.notifier).register(userData);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ref.read(authViewModelProvider).message ?? 'Registration successful'), backgroundColor: Colors.green),
        );
        Navigator.pushReplacementNamed(
          context, 
          AppRouter.verifyOtp, 
          arguments: {'email': emailController.text, 'isForReset': false},
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ref.read(authViewModelProvider).error ?? 'Registration failed'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text('Create Account', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildTextField(firstNameController, 'First Name', Icons.person_outline)),
                    const SizedBox(width: 15),
                    Expanded(child: _buildTextField(lastNameController, 'Last Name', Icons.person_outline)),
                  ],
                ),
                const SizedBox(height: 15),
                _buildTextField(usernameController, 'Username', Icons.alternate_email),
                const SizedBox(height: 15),
                _buildTextField(emailController, 'Email Address', Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 15),
                _buildTextField(phoneController, 'Phone Number', Icons.phone_outlined, keyboardType: TextInputType.phone),
                const SizedBox(height: 15),
                
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  decoration: _inputDecoration('Gender', Icons.wc),
                  items: ['male', 'female', 'other'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value[0].toUpperCase() + value.substring(1), style: GoogleFonts.poppins(fontSize: 14)),
                    );
                  }).toList(),
                  onChanged: (newValue) => setState(() => selectedGender = newValue!),
                ),
                const SizedBox(height: 15),
                
                _buildTextField(passwordController, 'Password', Icons.lock_outline, obscureText: obscurePassword, 
                  suffixIcon: IconButton(
                    icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility, size: 20),
                    onPressed: () => setState(() => obscurePassword = !obscurePassword),
                  ),
                ),
                const SizedBox(height: 15),
                _buildTextField(confirmPasswordController, 'Confirm Password', Icons.lock_outline, obscureText: obscurePassword),
                
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: authState.isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: authState.isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text('Register', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscureText = false, Widget? suffixIcon, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: _inputDecoration(label, icon).copyWith(suffixIcon: suffixIcon),
      validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary.withOpacity(0.8)),
    );
  }
}
