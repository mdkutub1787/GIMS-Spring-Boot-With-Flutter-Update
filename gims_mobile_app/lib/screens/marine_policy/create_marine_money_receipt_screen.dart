import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/marine/marine_bill.dart';
import '../../models/marine/marine_money_receipt.dart';
import '../../viewmodels/marine_bill_viewmodel.dart';
import '../../viewmodels/marine_receipt_viewmodel.dart';

class CreateMarineMoneyReceiptScreen extends ConsumerStatefulWidget {
  final MarineMoneyReceipt? receipt;
  const CreateMarineMoneyReceiptScreen({super.key, this.receipt});

  @override
  ConsumerState<CreateMarineMoneyReceiptScreen> createState() => _CreateMarineMoneyReceiptScreenState();
}

class _CreateMarineMoneyReceiptScreenState extends ConsumerState<CreateMarineMoneyReceiptScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController issuingOfficeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController issuedAgainstController = TextEditingController();

  MarineBill? selectedBill;
  String? selectedClassOfInsurance;
  String? selectedModeOfPayment;

  final List<String> classOfInsuranceOptions = ['Marine Cargo', 'Marine Hull', 'Marine Liability'];
  final List<String> modeOfPaymentOptions = ['Cash', 'Cheque', 'Pay Order', 'Bank Transfer', 'Credit Card'];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(marineBillViewModelProvider.notifier).fetchBills());
    
    if (widget.receipt != null) {
      issuingOfficeController.text = widget.receipt!.issuingOffice ?? '';
      dateController.text = widget.receipt!.date != null ? DateFormat('yyyy-MM-dd').format(widget.receipt!.date!) : DateFormat('yyyy-MM-dd').format(DateTime.now());
      issuedAgainstController.text = widget.receipt!.issuedAgainst ?? '';
      selectedClassOfInsurance = widget.receipt!.classOfInsurance;
      selectedModeOfPayment = widget.receipt!.modeOfPayment;
      selectedBill = widget.receipt!.marinebill;
    } else {
      dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate() && selectedBill != null) {
      final receipt = MarineMoneyReceipt(
        id: widget.receipt?.id,
        issuingOffice: issuingOfficeController.text,
        classOfInsurance: selectedClassOfInsurance!,
        modeOfPayment: selectedModeOfPayment!,
        date: DateTime.parse(dateController.text),
        issuedAgainst: issuedAgainstController.text,
        marinebill: selectedBill!,
      );

      bool success;
      if (widget.receipt == null) {
        success = await ref.read(marineReceiptViewModelProvider.notifier).saveReceipt(receipt);
      } else {
        success = await ref.read(marineReceiptViewModelProvider.notifier).updateReceipt(widget.receipt!.id!, receipt);
      }

      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.receipt == null ? 'Marine Receipt Created Successfully!' : 'Marine Receipt Updated Successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else if (selectedBill == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a Marine Bill'), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final billState = ref.watch(marineBillViewModelProvider);
    final receiptState = ref.watch(marineReceiptViewModelProvider);
    final isEditing = widget.receipt != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Marine Receipt' : 'New Marine Receipt', 
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFFF59E0B),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bill Selection', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFFD97706))),
              const SizedBox(height: 15),
              DropdownButtonFormField<MarineBill>(
                value: selectedBill,
                isExpanded: true,
                decoration: _inputDecoration('Select Marine Bill', Icons.receipt_long_outlined),
                items: billState.bills.map((b) => DropdownMenuItem<MarineBill>(
                  value: b, 
                  child: Text('${b.marineDetails?.policyholder ?? 'N/A'} (#${b.id})', overflow: TextOverflow.ellipsis)
                )).toList(),
                onChanged: (val) => setState(() => selectedBill = val),
                validator: (val) => val == null ? 'Required' : null,
              ),
              const SizedBox(height: 30),
              Text('Receipt Details', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFFD97706))),
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
                    backgroundColor: const Color(0xFFF59E0B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 2,
                  ),
                  child: receiptState.isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(isEditing ? 'Update Receipt' : 'Create Receipt', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
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
        final date = await showDatePicker(
          context: context, 
          initialDate: DateTime.now(), 
          firstDate: DateTime(2000), 
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color(0xFFF59E0B),
                  onPrimary: Colors.white,
                  onSurface: Colors.black87,
                ),
              ),
              child: child!,
            );
          },
        );
        if (date != null) setState(() => controller.text = DateFormat('yyyy-MM-dd').format(date));
      },
    );
  }

  Widget _buildDropdown(String label, IconData icon, List<String> items, String? value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
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
