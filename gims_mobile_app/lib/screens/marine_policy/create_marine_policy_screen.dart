import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/marine/marine_policy.dart';
import '../../viewmodels/marine_policy_viewmodel.dart';
import '../../viewmodels/utility_viewmodel.dart';

class CreateMarinePolicyScreen extends ConsumerStatefulWidget {
  final MarinePolicy? policy;
  
  const CreateMarinePolicyScreen({super.key, this.policy});

  @override
  ConsumerState<CreateMarinePolicyScreen> createState() => _CreateMarinePolicyScreenState();
}

class _CreateMarinePolicyScreenState extends ConsumerState<CreateMarinePolicyScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController policyholderController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController voyageFromController = TextEditingController();
  final TextEditingController voyageToController = TextEditingController();
  final TextEditingController viaController = TextEditingController();
  final TextEditingController stockItemController = TextEditingController();
  final TextEditingController sumInsuredUsdController = TextEditingController();
  final TextEditingController usdRateController = TextEditingController();
  final TextEditingController sumInsuredController = TextEditingController();
  final TextEditingController coverageController = TextEditingController();

  String? selectedBank;
  String? selectedBranch;

  @override
  void initState() {
    super.initState();
    usdRateController.addListener(_calculateTk);
    sumInsuredUsdController.addListener(_calculateTk);
    
    if (widget.policy != null) {
      final p = widget.policy!;
      policyholderController.text = p.policyholder ?? '';
      addressController.text = p.address ?? '';
      voyageFromController.text = p.voyageFrom ?? '';
      voyageToController.text = p.voyageTo ?? '';
      viaController.text = p.via ?? '';
      stockItemController.text = p.stockItem ?? '';
      sumInsuredUsdController.text = p.sumInsuredUsd?.toString() ?? '';
      usdRateController.text = p.usdRate?.toString() ?? '';
      sumInsuredController.text = p.sumInsured?.toString() ?? '';
      coverageController.text = p.coverage ?? '';
      selectedBank = p.bank?.name;
      selectedBranch = p.branch?.name;
    }

    Future.microtask(() {
      ref.read(utilityViewModelProvider.notifier).fetchBanks();
      ref.read(utilityViewModelProvider.notifier).fetchCurrencyRate();
      if (widget.policy?.bank?.id != null) {
        ref.read(utilityViewModelProvider.notifier).fetchBranches(widget.policy!.bank!.id!);
      }
    });
  }

  void _calculateTk() {
    double usd = double.tryParse(sumInsuredUsdController.text) ?? 0;
    double rate = double.tryParse(usdRateController.text) ?? 0;
    sumInsuredController.text = (usd * rate).toStringAsFixed(0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen to currency rate changes if not editing an existing policy
    if (widget.policy == null) {
      final utilityState = ref.watch(utilityViewModelProvider);
      if (utilityState.currencyRate > 0 && usdRateController.text.isEmpty) {
        usdRateController.text = utilityState.currencyRate.toString();
        _calculateTk();
      }
    }
  }


  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final utilityState = ref.read(utilityViewModelProvider);
      final bank = utilityState.banks.firstWhere(
        (e) => e.name == selectedBank, 
        orElse: () => widget.policy!.bank!
      );
      final branch = utilityState.branches.firstWhere(
        (e) => e.name == selectedBranch, 
        orElse: () => widget.policy!.branch!
      );

      final policy = MarinePolicy(
        date: DateTime.now(),
        bank: bank,
        branch: branch,
        policyholder: policyholderController.text,
        address: addressController.text,
        voyageFrom: voyageFromController.text,
        voyageTo: voyageToController.text,
        via: viaController.text,
        stockItem: stockItemController.text,
        sumInsuredUsd: double.tryParse(sumInsuredUsdController.text) ?? 0,
        usdRate: double.tryParse(usdRateController.text) ?? 0,
        sumInsured: double.tryParse(sumInsuredController.text) ?? 0,
        coverage: coverageController.text,
      );

      bool success;
      if (widget.policy != null) {
        success = await ref.read(marinePolicyViewModelProvider.notifier).updatePolicy(widget.policy!.id!, policy);
      } else {
        success = await ref.read(marinePolicyViewModelProvider.notifier).savePolicy(policy);
      }
      
      if (mounted) {
        if (success) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(widget.policy != null ? 'Marine Policy Updated Successfully!' : 'Marine Policy Created Successfully!'), backgroundColor: Colors.green),
          );
        } else {
          final error = ref.read(marinePolicyViewModelProvider).error;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error ?? (widget.policy != null ? 'Failed to update marine policy. Please try again.' : 'Failed to create marine policy. Please try again.')),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(marinePolicyViewModelProvider);
    final utilityState = ref.watch(utilityViewModelProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.policy != null ? 'Edit Marine Policy' : 'New Marine Policy', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Client & Bank', theme),
              const SizedBox(height: 15),
              _buildDropdownField(
                label: 'Select Bank',
                icon: Icons.account_balance_rounded,
                items: utilityState.banks.map((e) => e.name).where((e) => e != null).cast<String>().toSet().toList(),
                value: selectedBank,
                onChanged: (val) {
                  setState(() {
                    selectedBank = val;
                    selectedBranch = null; // reset branch
                  });
                  if (val != null) {
                    final bank = utilityState.banks.firstWhere((e) => e.name == val);
                    if (bank.id != null) {
                      ref.read(utilityViewModelProvider.notifier).fetchBranches(bank.id!);
                    }
                  }
                },
              ),
              const SizedBox(height: 15),
              _buildDropdownField(
                label: 'Select Branch',
                icon: Icons.account_tree_rounded,
                items: utilityState.branches.map((e) => e.name).where((e) => e != null).cast<String>().toSet().toList(),
                value: selectedBranch,
                onChanged: (val) => setState(() => selectedBranch = val),
              ),
              const SizedBox(height: 15),
              _buildField(policyholderController, 'Policyholder', Icons.person_outline),
              const SizedBox(height: 15),
              _buildField(addressController, 'Address', Icons.location_on_outlined),
              
              const SizedBox(height: 30),
              _buildSectionTitle('Voyage Details', theme),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: _buildField(voyageFromController, 'From', Icons.map_outlined)),
                  const SizedBox(width: 15),
                  Expanded(child: _buildField(voyageToController, 'To', Icons.location_searching)),
                ],
              ),
              const SizedBox(height: 15),
              _buildField(viaController, 'Via', Icons.directions_boat_outlined),
              
              const SizedBox(height: 30),
              _buildSectionTitle('Currency & Insured Value', theme),
              const SizedBox(height: 15),
              _buildField(stockItemController, 'Stock Item', Icons.inventory_2_outlined),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: _buildField(sumInsuredUsdController, 'Sum (USD)', Icons.attach_money, keyboardType: TextInputType.number)),
                  const SizedBox(width: 15),
                  Expanded(child: _buildField(usdRateController, 'USD Rate', Icons.trending_up, keyboardType: TextInputType.number, readOnly: true)),
                ],
              ),
              const SizedBox(height: 15),
              _buildField(sumInsuredController, 'Sum Insured (TK)', Icons.monetization_on_outlined, readOnly: true),
              const SizedBox(height: 15),
              _buildField(coverageController, 'Coverage', Icons.security_outlined),
              
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)], // Marine Blue gradient
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: state.isLoading || utilityState.isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: (state.isLoading || utilityState.isLoading)
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                    : Text(widget.policy != null ? 'Update Marine Policy' : 'Create Marine Policy', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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
    return Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo));
  }

  Widget _buildField(TextEditingController controller, String label, IconData icon, {bool readOnly = false, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: _inputDecoration(label, icon),
      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
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
      labelStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
      prefixIcon: Icon(icon, size: 20, color: const Color(0xFF3B82F6)), // Marine Blue
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
