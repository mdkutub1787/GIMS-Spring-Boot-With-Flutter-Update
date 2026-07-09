import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/policy_model.dart';
import '../../viewmodels/fire_policy_viewmodel.dart';

class CreateFirePolicyScreen extends ConsumerStatefulWidget {
  const CreateFirePolicyScreen({super.key});

  @override
  ConsumerState<CreateFirePolicyScreen> createState() => _CreateFirePolicyScreenState();
}

class _CreateFirePolicyScreenState extends ConsumerState<CreateFirePolicyScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController policyholderController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController stockInsuredController = TextEditingController();
  final TextEditingController sumInsuredController = TextEditingController();
  final TextEditingController interestInsuredController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController periodFromController = TextEditingController();
  final TextEditingController periodToController = TextEditingController();

  String? selectedConstruction;
  String? selectedUsage;

  final List<String> constructionTypes = ['1st Class', '2nd Class', '3rd Class'];
  final List<String> usageTypes = ['Shop Only', 'Godown Only', 'Shop-Cum-Godown only'];

  @override
  void initState() {
    super.initState();
    periodFromController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    DateTime nextYear = DateTime.now().add(const Duration(days: 365));
    periodToController.text = DateFormat('yyyy-MM-dd').format(nextYear);
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final policy = PolicyModel(
        date: DateTime.now(),
        bankName: bankNameController.text,
        policyholder: policyholderController.text,
        address: addressController.text,
        stockInsured: stockInsuredController.text,
        sumInsured: double.tryParse(sumInsuredController.text) ?? 0,
        interestInsured: interestInsuredController.text,
        coverage: "Fire &/or Lightning only",
        location: locationController.text,
        construction: selectedConstruction ?? '',
        owner: "The Insured",
        usedAs: selectedUsage ?? '',
        periodFrom: DateTime.parse(periodFromController.text),
        periodTo: DateTime.parse(periodToController.text),
      );

      final success = await ref.read(firePolicyViewModelProvider.notifier).savePolicy(policy);
      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Policy Created Successfully!'), backgroundColor: Colors.green),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(firePolicyViewModelProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('New Fire Policy', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Client Information', theme),
              const SizedBox(height: 15),
              _buildField(bankNameController, 'Bank Name', Icons.account_balance_outlined),
              const SizedBox(height: 15),
              _buildField(policyholderController, 'Policyholder', Icons.person_outline),
              const SizedBox(height: 15),
              _buildField(addressController, 'Address', Icons.location_on_outlined),
              
              const SizedBox(height: 30),
              _buildSectionTitle('Policy Details', theme),
              const SizedBox(height: 15),
              _buildField(stockInsuredController, 'Stock Insured', Icons.inventory_2_outlined),
              const SizedBox(height: 15),
              _buildField(sumInsuredController, 'Sum Insured (TK)', Icons.monetization_on_outlined, keyboardType: TextInputType.number),
              const SizedBox(height: 15),
              _buildField(interestInsuredController, 'Interest Insured', Icons.info_outline),
              const SizedBox(height: 15),
              _buildDropdown('Construction', Icons.build_outlined, constructionTypes, selectedConstruction, (val) => setState(() => selectedConstruction = val)),
              const SizedBox(height: 15),
              _buildDropdown('Usage', Icons.business_outlined, usageTypes, selectedUsage, (val) => setState(() => selectedUsage = val)),
              
              const SizedBox(height: 30),
              _buildSectionTitle('Validity', theme),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: _buildDateField(periodFromController, 'From')),
                  const SizedBox(width: 15),
                  Expanded(child: _buildDateField(periodToController, 'To')),
                ],
              ),
              
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: state.isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: state.isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('Create Policy', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.primary));
  }

  Widget _buildField(TextEditingController controller, String label, IconData icon, {TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: _inputDecoration(label, icon),
      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
    );
  }

  Widget _buildDateField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: _inputDecoration(label, Icons.calendar_today_outlined),
      onTap: () async {
        final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
        if (date != null) setState(() => controller.text = DateFormat('yyyy-MM-dd').format(date));
      },
    );
  }

  Widget _buildDropdown(String label, IconData icon, List<String> items, String? value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
      decoration: _inputDecoration(label, icon),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
