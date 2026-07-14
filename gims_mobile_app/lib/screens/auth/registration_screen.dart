import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../core/routing/app_router.dart';
import '../../viewmodels/utility_viewmodel.dart';
import '../../viewmodels/issue_office_viewmodel.dart';
import '../../models/utility_models.dart';
import '../../models/utility/issue_office.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  // Issue Office Controllers
  final officeNameController = TextEditingController();
  final officeAddressController = TextEditingController();
  final officePhoneController = TextEditingController();
  final officeMobileController = TextEditingController();
  final officeFaxController = TextEditingController();
  final officeEmailController = TextEditingController();
  final officeWebsiteController = TextEditingController();
  
  final _formKey = GlobalKey<FormState>();
  final _accountFormKey = GlobalKey<FormState>();
  final _companyFormKey = GlobalKey<FormState>();
  final _officeFormKey = GlobalKey<FormState>();

  bool obscurePassword = true;
  int currentStep = 0;
  int? selectedCompanyId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(utilityViewModelProvider.notifier).fetchInsuranceCompanies();
    });
  }

  void _handleRegister() async {
      final userData = {
        "username": usernameController.text,
        "email": emailController.text,
        "phone": phoneController.text,
        "password": passwordController.text,
        "companyId": selectedCompanyId,
        "officeName": officeNameController.text,
        "officeAddress": officeAddressController.text,
        "officePhone": officePhoneController.text,
        "officeMobile": officeMobileController.text,
        "officeFax": officeFaxController.text,
        "officeEmail": officeEmailController.text,
        "officeWebsite": officeWebsiteController.text,
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

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final utilityState = ref.watch(utilityViewModelProvider);
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
        child: Stepper(
          type: StepperType.vertical,
          currentStep: currentStep,
          onStepContinue: () {
            if (currentStep == 0) {
              if (_accountFormKey.currentState!.validate()) {
                if (passwordController.text != confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match'), backgroundColor: Colors.red));
                  return;
                }
                setState(() => currentStep += 1);
              }
            } else if (currentStep == 1) {
              if (_companyFormKey.currentState!.validate()) {
                setState(() => currentStep += 1);
              }
            } else if (currentStep == 2) {
              if (_officeFormKey.currentState!.validate()) {
                _handleRegister();
              }
            }
          },
          onStepCancel: () {
            if (currentStep > 0) {
              setState(() => currentStep -= 1);
            } else {
              Navigator.pop(context);
            }
          },
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: authState.isLoading ? null : details.onStepContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: authState.isLoading && currentStep == 2
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(currentStep == 2 ? 'Complete Registration' : 'Continue', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  if (currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: details.onStepCancel,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text('Back', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                      ),
                    ),
                ],
              ),
            );
          },
          steps: [
            Step(
              title: Text('Account Setup', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              content: Form(
                key: _accountFormKey,
                child: Column(
                  children: [
                    _buildTextField(usernameController, 'Username', Icons.alternate_email),
                    const SizedBox(height: 15),
                    _buildTextField(emailController, 'Email Address', Icons.email_outlined, keyboardType: TextInputType.emailAddress, isEmail: true),
                    const SizedBox(height: 15),
                    _buildTextField(phoneController, 'Phone Number', Icons.phone_outlined, keyboardType: TextInputType.phone, isPhone: true),
                    const SizedBox(height: 15),
                    _buildTextField(passwordController, 'Password', Icons.lock_outline, obscureText: obscurePassword, 
                      isPassword: true,
                      suffixIcon: IconButton(
                        icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility, size: 20),
                        onPressed: () => setState(() => obscurePassword = !obscurePassword),
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(confirmPasswordController, 'Confirm Password', Icons.lock_outline, obscureText: obscurePassword),
                  ],
                ),
              ),
              isActive: currentStep >= 0,
              state: currentStep > 0 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: Text('Company Selection', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              content: Form(
                key: _companyFormKey,
                child: DropdownButtonFormField<int>(
                  value: selectedCompanyId,
                  decoration: _inputDecoration('Select Company', Icons.business),
                  items: utilityState.insuranceCompanies.map((InsuranceCompany company) {
                    return DropdownMenuItem<int>(
                      value: company.id,
                      child: Text(company.name ?? 'Unknown', style: GoogleFonts.poppins(fontSize: 14)),
                    );
                  }).toList(),
                  onChanged: (newValue) => setState(() => selectedCompanyId = newValue),
                  validator: (value) => value == null ? 'Please select a company' : null,
                ),
              ),
              isActive: currentStep >= 1,
              state: currentStep > 1 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: Text('Office Details', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              content: Form(
                key: _officeFormKey,
                child: Column(
                  children: [
                    _buildTextField(officeNameController, 'Office Name', Icons.store_mall_directory),
                    const SizedBox(height: 15),
                    _buildTextField(officeAddressController, 'Office Address', Icons.location_on),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(officePhoneController, 'Phone', Icons.phone, keyboardType: TextInputType.phone)),
                        const SizedBox(width: 15),
                        Expanded(child: _buildTextField(officeMobileController, 'Mobile', Icons.phone_android, keyboardType: TextInputType.phone)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(officeFaxController, 'Fax (Optional)', Icons.fax, isOptional: true)),
                        const SizedBox(width: 15),
                        Expanded(child: _buildTextField(officeEmailController, 'Office Email', Icons.email, keyboardType: TextInputType.emailAddress, isEmail: true)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(officeWebsiteController, 'Website (Optional)', Icons.language, isOptional: true),
                  ],
                ),
              ),
              isActive: currentStep >= 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscureText = false, Widget? suffixIcon, TextInputType? keyboardType, bool isOptional = false, bool isEmail = false, bool isPassword = false, bool isPhone = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: _inputDecoration(label, icon).copyWith(suffixIcon: suffixIcon),
      validator: (value) {
        if (!isOptional && (value == null || value.isEmpty)) return 'Required';
        if (value != null && value.isNotEmpty) {
          if (isEmail && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Invalid email format';
          }
          if (isPassword && value.length < 6) {
            return 'Min 6 characters';
          }
          if (isPhone && !RegExp(r'^\d+$').hasMatch(value.replaceAll(RegExp(r'[\s\-\+]'), ''))) {
            return 'Invalid phone number';
          }
        }
        return null;
      },
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary.withOpacity(0.8)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
