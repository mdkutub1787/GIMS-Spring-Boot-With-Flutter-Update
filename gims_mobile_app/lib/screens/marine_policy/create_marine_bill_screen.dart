import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/marine/marine_bill.dart';
import '../../models/marine/marine_policy.dart';
import '../../viewmodels/marine_bill_viewmodel.dart';
import '../../viewmodels/marine_policy_viewmodel.dart';

class CreateMarineBillScreen extends ConsumerStatefulWidget {
  const CreateMarineBillScreen({super.key});

  @override
  ConsumerState<CreateMarineBillScreen> createState() => _CreateMarineBillScreenState();
}

class _CreateMarineBillScreenState extends ConsumerState<CreateMarineBillScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController marineRateController = TextEditingController();
  final TextEditingController warSrccRateController = TextEditingController();
  final TextEditingController netPremiumController = TextEditingController();
  final TextEditingController taxController = TextEditingController();
  final TextEditingController stampDutyController = TextEditingController();
  final TextEditingController grossPremiumController = TextEditingController();

  MarinePolicy? selectedPolicy;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(marinePolicyViewModelProvider.notifier).fetchPolicies());
    marineRateController.addListener(_updateCalculatedFields);
    warSrccRateController.addListener(_updateCalculatedFields);
    stampDutyController.addListener(_updateCalculatedFields);
  }

  void _updateCalculatedFields() {
    if (selectedPolicy == null) return;
    double sumInsured = selectedPolicy!.sumInsured ?? 0.0;
    double marineRate = double.tryParse(marineRateController.text) ?? 0.0;
    double warSrccRate = double.tryParse(warSrccRateController.text) ?? 0.0;
    double stampDuty = double.tryParse(stampDutyController.text) ?? 0.0;
    const double taxRate = 15.0;

    double netPremium = (sumInsured * (marineRate + warSrccRate)) / 100;
    double tax = (netPremium * taxRate) / 100;
    double grossPremium = netPremium + tax + stampDuty;

    netPremium = (netPremium + 0.5).toInt().toDouble();
    tax = (tax + 0.5).toInt().toDouble();
    grossPremium = (grossPremium + 0.5).toInt().toDouble();

    setState(() {
      netPremiumController.text = netPremium.toStringAsFixed(0);
      taxController.text = "${taxRate.toStringAsFixed(0)}%";
      grossPremiumController.text = grossPremium.toStringAsFixed(0);
    });
  }

  void _submit() async {
    if (_formKey.currentState!.validate() && selectedPolicy != null) {
      final bill = MarineBill(
        marineRate: double.parse(marineRateController.text),
        warSrccRate: double.parse(warSrccRateController.text),
        netPremium: double.parse(netPremiumController.text),
        tax: 15.0,
        stampDuty: double.parse(stampDutyController.text),
        grossPremium: double.parse(grossPremiumController.text),
        marineDetails: selectedPolicy!,
      );

      final success = await ref.read(marineBillViewModelProvider.notifier).saveBill(bill);
      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Marine Bill Created Successfully!'), backgroundColor: Colors.green),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final policyState = ref.watch(marinePolicyViewModelProvider);
    final billState = ref.watch(marineBillViewModelProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Create Marine Bill', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
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
              DropdownButtonFormField<MarinePolicy>(
                value: selectedPolicy,
                isExpanded: true,
                decoration: _inputDecoration('Select Policy', Icons.person_outline),
                items: policyState.policies.map((p) => DropdownMenuItem<MarinePolicy>(value: p, child: Text(p.policyholder ?? 'N/A'))).toList(),
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
                Text('Bank: ${selectedPolicy!.bank?.name ?? 'N/A'}', style: GoogleFonts.poppins(fontSize: 12, color: Colors.blue)),
                Text('Sum Insured: TK ${selectedPolicy!.sumInsured}', style: GoogleFonts.poppins(fontSize: 12, color: Colors.green)),
              ],
              const SizedBox(height: 30),
              Text('Rates & Duties', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
              const SizedBox(height: 15),
              _buildField(marineRateController, 'Marine Rate (%)', Icons.percent),
              const SizedBox(height: 15),
              _buildField(warSrccRateController, 'War/SRCC Rate (%)', Icons.percent),
              const SizedBox(height: 15),
              _buildField(stampDutyController, 'Stamp Duty (TK)', Icons.receipt),
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
                    : Text('Create Marine Bill', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
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
      prefixIcon: Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary.withOpacity(0.8)),
    );
  }
}
