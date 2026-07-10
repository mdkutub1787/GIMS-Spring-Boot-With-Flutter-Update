import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/bill_model.dart';
import '../../models/policy_model.dart';
import '../../viewmodels/fire_bill_viewmodel.dart';
import '../../viewmodels/fire_policy_viewmodel.dart';

class CreateFireBillScreen extends ConsumerStatefulWidget {
  const CreateFireBillScreen({super.key});

  @override
  ConsumerState<CreateFireBillScreen> createState() => _CreateFireBillScreenState();
}

class _CreateFireBillScreenState extends ConsumerState<CreateFireBillScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController fireController = TextEditingController();
  final TextEditingController rsdController = TextEditingController();
  final TextEditingController netPremiumController = TextEditingController();
  final TextEditingController taxController = TextEditingController();
  final TextEditingController grossPremiumController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  PolicyModel? selectedPolicy;
  List<PolicyModel> filteredPolicies = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(firePolicyViewModelProvider.notifier).fetchPolicies());
    fireController.addListener(_updateCalculatedFields);
    rsdController.addListener(_updateCalculatedFields);
  }

  void _updateCalculatedFields() {
    if (selectedPolicy == null) return;
    double sumInsured = selectedPolicy!.sumInsured ?? 0.0;
    double fire = double.tryParse(fireController.text) ?? 0.0;
    double rsd = double.tryParse(rsdController.text) ?? 0.0;
    const double taxRate = 15.0;

    double netPremium = (sumInsured * (fire + rsd)) / 100;
    double grossPremium = netPremium + (netPremium * taxRate) / 100;

    netPremium = (netPremium + 0.5).toInt().toDouble();
    grossPremium = (grossPremium + 0.5).toInt().toDouble();

    setState(() {
      netPremiumController.text = netPremium.toStringAsFixed(0);
      taxController.text = taxRate.toStringAsFixed(0) + "%";
      grossPremiumController.text = grossPremium.toStringAsFixed(0);
    });
  }

  void _submit() async {
    if (_formKey.currentState!.validate() && selectedPolicy != null) {
      final bill = BillModel(
        fire: double.parse(fireController.text),
        rsd: double.parse(rsdController.text),
        netPremium: double.parse(netPremiumController.text),
        tax: 15.0,
        grossPremium: double.parse(grossPremiumController.text),
        policy: selectedPolicy!,
      );

      final success = await ref.read(fireBillViewModelProvider.notifier).saveBill(bill);
      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bill Created Successfully!'), backgroundColor: Colors.green),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final policyState = ref.watch(firePolicyViewModelProvider);
    final billState = ref.watch(fireBillViewModelProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Create Fire Bill', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Policy Selection', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
              const SizedBox(height: 15),
              DropdownButtonFormField<PolicyModel>(
                value: selectedPolicy,
                decoration: _inputDecoration('Select Policy', Icons.person_outline),
                items: policyState.policies.map((p) => DropdownMenuItem(value: p, child: Text(p.policyholder ?? 'N/A'))).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedPolicy = val;
                    _updateCalculatedFields();
                  });
                },
                validator: (val) => val == null ? 'Required' : null,
              ),
              if (selectedPolicy != null) ...[
                const SizedBox(height: 10),
                Text('Bank: ${selectedPolicy!.bankName}', style: GoogleFonts.poppins(fontSize: 12, color: Colors.blue)),
                Text('Sum Insured: TK ${selectedPolicy!.sumInsured}', style: GoogleFonts.poppins(fontSize: 12, color: Colors.green)),
              ],
              const SizedBox(height: 30),
              Text('Rates', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
              const SizedBox(height: 15),
              _buildField(fireController, 'Fire Rate (%)', Icons.percent),
              const SizedBox(height: 15),
              _buildField(rsdController, 'RSD Rate (%)', Icons.percent),
              const SizedBox(height: 30),
              Text('Calculated Premiums', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
              const SizedBox(height: 15),
              _buildField(netPremiumController, 'Net Premium', Icons.monetization_on_outlined, readOnly: true),
              const SizedBox(height: 15),
              _buildField(taxController, 'Tax Rate', Icons.receipt_long_outlined, readOnly: true),
              const SizedBox(height: 15),
              _buildField(grossPremiumController, 'Gross Premium', Icons.account_balance_wallet_outlined, readOnly: true),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: billState.isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: billState.isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('Create Bill', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, IconData icon, {bool readOnly = false}) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: TextInputType.number,
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: _inputDecoration(label, icon),
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
