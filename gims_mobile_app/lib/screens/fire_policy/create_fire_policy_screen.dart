import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/fire/fire_policy.dart';
import '../../viewmodels/fire_policy_viewmodel.dart';
import '../../viewmodels/utility_viewmodel.dart';
import '../../core/widgets/brand_app_bar.dart';

class CreateFirePolicyScreen extends ConsumerStatefulWidget {
  const CreateFirePolicyScreen({super.key});

  @override
  ConsumerState<CreateFirePolicyScreen> createState() => _CreateFirePolicyScreenState();
}

class _CreateFirePolicyScreenState extends ConsumerState<CreateFirePolicyScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController policyholderController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController stockInsuredController = TextEditingController();
  final TextEditingController sumInsuredController = TextEditingController();
  final TextEditingController interestInsuredController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController periodFromController = TextEditingController();
  final TextEditingController periodToController = TextEditingController();

  String? selectedCompany;
  String? selectedBank;
  String? selectedBranch;
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

    Future.microtask(() {
      ref.read(utilityViewModelProvider.notifier).fetchBanks();
      ref.read(utilityViewModelProvider.notifier).fetchInsuranceCompanies();
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final utilityState = ref.read(utilityViewModelProvider);
      
      final company = utilityState.insuranceCompanies.firstWhere((e) => e.name == selectedCompany);
      final bank = utilityState.banks.firstWhere((e) => e.name == selectedBank);
      final branch = selectedBranch != null 
          ? utilityState.branches.firstWhere((e) => e.name == selectedBranch)
          : null;

      final policy = FirePolicy(
        date: DateTime.now(),
        company: company,
        bank: bank,
        branch: branch,
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
      if (mounted) {
        if (success) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Policy Created Successfully!'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating),
          );
        } else {
          final error = ref.read(firePolicyViewModelProvider).error;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error ?? 'Failed to create policy'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final fireState = ref.watch(firePolicyViewModelProvider);
    final utilityState = ref.watch(utilityViewModelProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BrandAppBar(
        title: Text('New Fire Policy', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Client & Company', Icons.business_rounded),
              const SizedBox(height: 20),
              
              _buildDropdownField(
                label: 'Insurance Company',
                icon: Icons.store_rounded,
                items: utilityState.insuranceCompanies.map((e) => e.name).where((e) => e != null).cast<String>().toSet().toList(),
                value: selectedCompany,
                onChanged: (val) => setState(() => selectedCompany = val),
              ),
              const SizedBox(height: 16),

              _buildDropdownField(
                label: 'Select Bank',
                icon: Icons.account_balance_rounded,
                items: utilityState.banks.map((e) => e.name).where((e) => e != null).cast<String>().toSet().toList(),
                value: selectedBank,
                onChanged: (val) {
                  setState(() {
                    selectedBank = val;
                    selectedBranch = null;
                  });
                  final bank = utilityState.banks.firstWhere((e) => e.name == val);
                  ref.read(utilityViewModelProvider.notifier).fetchBranches(bank.id);
                },
              ),
              const SizedBox(height: 16),

              _buildDropdownField(
                label: 'Select Branch',
                icon: Icons.account_tree_rounded,
                items: utilityState.branches.map((e) => e.name).where((e) => e != null).cast<String>().toSet().toList(),
                value: selectedBranch,
                onChanged: (val) => setState(() => selectedBranch = val),
              ),
              const SizedBox(height: 16),

              _buildTextField(policyholderController, 'Policyholder Name', Icons.person_rounded),
              const SizedBox(height: 16),
              _buildTextField(addressController, 'Full Address', Icons.location_on_rounded, maxLines: 2),
              
              const SizedBox(height: 32),
              _buildSectionTitle('Policy Assets', Icons.inventory_2_rounded),
              const SizedBox(height: 20),
              
              _buildTextField(stockInsuredController, 'Stock Description', Icons.label_important_rounded),
              const SizedBox(height: 16),
              _buildTextField(sumInsuredController, 'Sum Insured (TK)', Icons.monetization_on_rounded, keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              _buildTextField(interestInsuredController, 'Interest Insured', Icons.info_outline_rounded),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(child: _buildDropdownField(label: 'Construction', icon: Icons.build_rounded, items: constructionTypes, value: selectedConstruction, onChanged: (v) => setState(() => selectedConstruction = v))),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDropdownField(label: 'Usage', icon: Icons.work_rounded, items: usageTypes, value: selectedUsage, onChanged: (v) => setState(() => selectedUsage = v))),
                ],
              ),
              
              const SizedBox(height: 32),
              _buildSectionTitle('Validity Period', Icons.calendar_today_rounded),
              const SizedBox(height: 20),
              
              Row(
                children: [
                  Expanded(child: _buildDateField(periodFromController, 'Period From')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDateField(periodToController, 'Period To')),
                ],
              ),
              
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: fireState.isLoading || utilityState.isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    shadowColor: theme.colorScheme.primary.withOpacity(0.3),
                  ),
                  child: (fireState.isLoading || utilityState.isLoading)
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('Generate Policy', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        const SizedBox(width: 10),
        Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType? keyboardType, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: _inputDecoration(label, icon),
      validator: (v) => (v == null || v.isEmpty) ? 'Field required' : null,
    );
  }

  Widget _buildDateField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: _inputDecoration(label, Icons.calendar_month_rounded),
      onTap: () async {
        final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
        if (date != null) setState(() => controller.text = DateFormat('yyyy-MM-dd').format(date));
      },
    );
  }

  Widget _buildDropdownField({required String label, required IconData icon, required List<String> items, String? value, required Function(String?) onChanged}) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
      style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
      decoration: _inputDecoration(label, icon),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(),
      onChanged: onChanged,
      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary.withOpacity(0.8)),
    );
  }
}
