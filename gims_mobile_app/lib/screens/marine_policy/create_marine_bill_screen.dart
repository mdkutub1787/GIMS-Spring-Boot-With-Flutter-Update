import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/marine/marine_bill.dart';
import '../../models/marine/marine_policy.dart';
import '../../viewmodels/marine_bill_viewmodel.dart';
import '../../viewmodels/marine_policy_viewmodel.dart';

class CreateMarineBillScreen extends ConsumerStatefulWidget {
  final MarineBill? bill;
  
  const CreateMarineBillScreen({super.key, this.bill});

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
  Timer? _debounce;

  MarinePolicy? selectedPolicy;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(marinePolicyViewModelProvider.notifier).fetchPolicies());
    
    if (widget.bill != null) {
      final b = widget.bill!;
      marineRateController.text = b.marineRate?.toString() ?? '';
      warSrccRateController.text = b.warSrccRate?.toString() ?? '';
      netPremiumController.text = b.netPremium?.toString() ?? '';
      taxController.text = "${b.tax?.toStringAsFixed(0) ?? '15'}%";
      stampDutyController.text = b.stampDuty?.toString() ?? '';
      grossPremiumController.text = b.grossPremium?.toString() ?? '';
      selectedPolicy = b.marineDetails;
    }

    marineRateController.addListener(_updateCalculatedFields);
    warSrccRateController.addListener(_updateCalculatedFields);
    stampDutyController.addListener(_updateCalculatedFields);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    marineRateController.dispose();
    warSrccRateController.dispose();
    stampDutyController.dispose();
    super.dispose();
  }

  void _updateCalculatedFields() {
    if (selectedPolicy == null) return;
    
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final tempBill = MarineBill(
        marineRate: double.tryParse(marineRateController.text) ?? 0.0,
        warSrccRate: double.tryParse(warSrccRateController.text) ?? 0.0,
        stampDuty: double.tryParse(stampDutyController.text) ?? 0.0,
        netPremium: 0,
        tax: 15,
        grossPremium: 0,
        marineDetails: selectedPolicy!,
      );

      final calculatedBill = await ref.read(marineBillViewModelProvider.notifier).calculateBill(tempBill);
      if (calculatedBill != null && mounted) {
        setState(() {
          netPremiumController.text = calculatedBill.netPremium?.toStringAsFixed(0) ?? '0';
          taxController.text = "${calculatedBill.tax?.toStringAsFixed(0) ?? '15'}%";
          grossPremiumController.text = calculatedBill.grossPremium?.toStringAsFixed(0) ?? '0';
        });
      }
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

      bool success;
      if (widget.bill != null) {
        success = await ref.read(marineBillViewModelProvider.notifier).updateBill(widget.bill!.id!, bill);
      } else {
        success = await ref.read(marineBillViewModelProvider.notifier).saveBill(bill);
      }
      
      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.bill != null ? 'Marine Bill Updated Successfully!' : 'Marine Bill Created Successfully!'), backgroundColor: Colors.green),
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
        title: Text(widget.bill != null ? 'Edit Marine Bill' : 'Create Marine Bill', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
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
                value: selectedPolicy != null && policyState.policies.any((p) => p.id == selectedPolicy!.id)
                       ? policyState.policies.firstWhere((p) => p.id == selectedPolicy!.id)
                       : (policyState.policies.isNotEmpty && selectedPolicy != null ? selectedPolicy : null),
                isExpanded: true,
                decoration: _inputDecoration('Select Policy', Icons.person_outline),
                items: [
                  if (selectedPolicy != null && !policyState.policies.any((p) => p.id == selectedPolicy!.id))
                    DropdownMenuItem<MarinePolicy>(value: selectedPolicy, child: Text(selectedPolicy!.policyholder ?? 'N/A')),
                  ...policyState.policies.map((p) => DropdownMenuItem<MarinePolicy>(value: p, child: Text(p.policyholder ?? 'N/A')))
                ],
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
                Text('Bank: ${selectedPolicy!.bank?.name ?? 'N/A'}', style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF7C3AED))),
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
                    : Text(widget.bill != null ? 'Update Marine Bill' : 'Create Marine Bill', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
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
