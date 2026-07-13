import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/fire/fire_bill.dart';
import '../../models/fire/fire_money_receipt.dart';
import '../../viewmodels/fire_bill_viewmodel.dart';
import '../../viewmodels/fire_receipt_viewmodel.dart';

class CreateFireMoneyReceiptScreen extends ConsumerStatefulWidget {
  final FireMoneyReceipt? receipt;
  
  const CreateFireMoneyReceiptScreen({super.key, this.receipt});

  @override
  ConsumerState<CreateFireMoneyReceiptScreen> createState() => _CreateFireMoneyReceiptScreenState();
}

class _CreateFireMoneyReceiptScreenState extends ConsumerState<CreateFireMoneyReceiptScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController issuingOfficeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController issuedAgainstController = TextEditingController();

  FireBill? selectedBill;
  String? selectedClassOfInsurance;
  String? selectedModeOfPayment;

  final List<String> classOfInsuranceOptions = ['Fire Insurance', 'Marine Insurance', 'Motor Insurance'];
  final List<String> modeOfPaymentOptions = ['Cash', 'Credit Card', 'Bank Transfer', 'Cheque'];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(fireBillViewModelProvider.notifier).fetchBills());
    
    if (widget.receipt != null) {
      final r = widget.receipt!;
      issuingOfficeController.text = r.issuingOffice ?? '';
      selectedClassOfInsurance = r.classOfInsurance;
      selectedModeOfPayment = r.modeOfPayment;
      dateController.text = r.date != null ? DateFormat('yyyy-MM-dd').format(r.date!) : DateFormat('yyyy-MM-dd').format(DateTime.now());
      issuedAgainstController.text = r.issuedAgainst ?? '';
      selectedBill = r.bill;
    } else {
      dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate() && selectedBill != null) {
      final receipt = FireMoneyReceipt(
        issuingOffice: issuingOfficeController.text,
        classOfInsurance: selectedClassOfInsurance!,
        modeOfPayment: selectedModeOfPayment!,
        date: DateTime.parse(dateController.text),
        issuedAgainst: issuedAgainstController.text,
        bill: selectedBill!,
      );

      bool success;
      if (widget.receipt != null) {
        success = await ref.read(fireReceiptViewModelProvider.notifier).updateReceipt(widget.receipt!.id!, receipt);
      } else {
        success = await ref.read(fireReceiptViewModelProvider.notifier).saveReceipt(receipt);
      }
      
      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.receipt != null ? 'Receipt Updated Successfully!' : 'Receipt Created Successfully!'), backgroundColor: Colors.green),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final billState = ref.watch(fireBillViewModelProvider);
    final receiptState = ref.watch(fireReceiptViewModelProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.receipt != null ? 'Edit Money Receipt' : 'New Money Receipt', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bill Selection', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
              const SizedBox(height: 15),
              DropdownButtonFormField<FireBill>(
                value: selectedBill != null && billState.bills.any((b) => b.id == selectedBill!.id)
                       ? billState.bills.firstWhere((b) => b.id == selectedBill!.id)
                       : (billState.bills.isNotEmpty && selectedBill != null ? selectedBill : null),
                isExpanded: true,
                decoration: _inputDecoration('Select Bill', Icons.receipt_long_outlined),
                items: [
                  if (selectedBill != null && !billState.bills.any((b) => b.id == selectedBill!.id))
                    DropdownMenuItem<FireBill>(value: selectedBill, child: Text('${selectedBill!.policy?.policyholder ?? 'N/A'} (#${selectedBill!.id})')),
                  ...billState.bills.map((b) => DropdownMenuItem<FireBill>(value: b, child: Text('${b.policy?.policyholder ?? 'N/A'} (#${b.id})')))
                ],
                onChanged: (val) => setState(() => selectedBill = val),
                validator: (val) => val == null ? 'Required' : null,
              ),
              const SizedBox(height: 30),
              Text('Receipt Details', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
              const SizedBox(height: 15),
              _buildField(issuingOfficeController, 'Issuing Office', Icons.business_outlined),
              const SizedBox(height: 15),
              _buildDropdown('Class of Insurance', Icons.category_outlined, classOfInsuranceOptions, selectedClassOfInsurance, (val) => setState(() => selectedClassOfInsurance = val)),
              const SizedBox(height: 15),
              _buildDateField(dateController, 'Receipt Date'),
              const SizedBox(height: 15),
              _buildDropdown('Mode of Payment', Icons.payments_outlined, modeOfPaymentOptions, selectedModeOfPayment, (val) => setState(() => selectedModeOfPayment = val)),
              const SizedBox(height: 15),
              _buildField(issuedAgainstController, 'Issued Against', Icons.description_outlined),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: receiptState.isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: receiptState.isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(widget.receipt != null ? 'Update Receipt' : 'Create Receipt', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
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
    final validValue = (value != null && items.contains(value)) ? value : null;
    return DropdownButtonFormField<String>(
      value: validValue,
      isExpanded: true,
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
      prefixIcon: Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary.withOpacity(0.8)),
    );
  }
}
