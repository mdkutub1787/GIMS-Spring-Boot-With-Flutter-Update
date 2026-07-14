import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/fire/fire_bill.dart';
import '../../models/fire/fire_policy.dart';
import '../../viewmodels/fire_bill_viewmodel.dart';
import '../../viewmodels/fire_policy_viewmodel.dart';

class CreateFireBillScreen extends ConsumerStatefulWidget {
  final FireBill? bill;
  
  const CreateFireBillScreen({super.key, this.bill});

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
  Timer? _debounce;

  FirePolicy? selectedPolicy;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(firePolicyViewModelProvider.notifier).fetchPolicies());
    
    if (widget.bill != null) {
      final b = widget.bill!;
      fireController.text = b.fire?.toString() ?? '';
      rsdController.text = b.rsd?.toString() ?? '';
      netPremiumController.text = b.netPremium?.toString() ?? '';
      taxController.text = "${b.tax?.toStringAsFixed(0) ?? '15'}%";
      grossPremiumController.text = b.grossPremium?.toString() ?? '';
      selectedPolicy = b.policy;
    }

    fireController.addListener(_updateCalculatedFields);
    rsdController.addListener(_updateCalculatedFields);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    fireController.dispose();
    rsdController.dispose();
    super.dispose();
  }

  void _updateCalculatedFields() {
    if (selectedPolicy == null) return;
    
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final tempBill = FireBill(
        fire: double.tryParse(fireController.text) ?? 0.0,
        rsd: double.tryParse(rsdController.text) ?? 0.0,
        netPremium: 0,
        tax: 15.0,
        grossPremium: 0,
        policy: selectedPolicy!,
      );

      final calculatedBill = await ref.read(fireBillViewModelProvider.notifier).calculateBill(tempBill);
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
      final bill = FireBill(
        fire: double.parse(fireController.text),
        rsd: double.parse(rsdController.text),
        netPremium: double.parse(netPremiumController.text),
        tax: 15.0,
        grossPremium: double.parse(grossPremiumController.text),
        policy: selectedPolicy!,
      );

      bool success;
      if (widget.bill != null) {
        success = await ref.read(fireBillViewModelProvider.notifier).updateBill(widget.bill!.id!, bill);
      } else {
        success = await ref.read(fireBillViewModelProvider.notifier).saveBill(bill);
      }
      
      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.bill != null ? 'Bill Updated Successfully!' : 'Bill Created Successfully!'), backgroundColor: Colors.green),
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
        title: Text(widget.bill != null ? 'Edit Fire Bill' : 'Create Fire Bill', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
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
              DropdownButtonFormField<FirePolicy>(
                value: selectedPolicy != null && policyState.policies.any((p) => p.id == selectedPolicy!.id) 
                       ? policyState.policies.firstWhere((p) => p.id == selectedPolicy!.id) 
                       : (policyState.policies.isNotEmpty && selectedPolicy != null ? selectedPolicy : null),
                isExpanded: true,
                decoration: _inputDecoration('Select Policy', Icons.person_outline),
                items: [
                  if (selectedPolicy != null && !policyState.policies.any((p) => p.id == selectedPolicy!.id))
                    DropdownMenuItem<FirePolicy>(value: selectedPolicy, child: Text(selectedPolicy!.policyholder ?? 'N/A')),
                  ...policyState.policies.map((p) => DropdownMenuItem<FirePolicy>(value: p, child: Text(p.policyholder ?? 'N/A')))
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
              Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C3AED).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: billState.isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: billState.isLoading 
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                    : Text(widget.bill != null ? 'Update Bill' : 'Create Bill', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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
      labelStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
      prefixIcon: Icon(icon, size: 20, color: const Color(0xFF10B981)),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF10B981), width: 1.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
