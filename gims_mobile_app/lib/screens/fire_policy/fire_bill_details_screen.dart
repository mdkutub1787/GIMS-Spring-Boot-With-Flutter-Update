import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/fire/fire_bill.dart';

class FireBillDetailsScreen extends StatelessWidget {
  final FireBill bill;
  const FireBillDetailsScreen({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Bill Details', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildAmountHeader(theme),
            const SizedBox(height: 25),
            _buildDetailCard('Client Information', [
              _detailRow('Policyholder', bill.policy.policyholder ?? 'N/A'),
              _detailRow('Bank Name', bill.policy.bankName ?? 'N/A'),
              _detailRow('Policy ID', '#${bill.policy.id}'),
            ]),
            const SizedBox(height: 20),
            _buildDetailCard('Bill Summary', [
              _detailRow('Fire Rate', '${bill.fire}%'),
              _detailRow('RSD Rate', '${bill.rsd}%'),
              _detailRow('Net Premium', 'TK ${bill.netPremium}'),
              _detailRow('Tax (15%)', 'TK ${bill.tax}'),
              const Divider(height: 30),
              _detailRow('Gross Total', 'TK ${bill.grossPremium}', isBold: true),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountHeader(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [theme.colorScheme.primary, theme.colorScheme.primary.withOpacity(0.8)]),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: theme.colorScheme.primary.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          Text('Total Bill Amount', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
          Text('TK ${bill.grossPremium}', style: GoogleFonts.poppins(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
            child: Text('Bill ID: #${bill.id}', style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue)),
          const SizedBox(height: 15),
          ...children,
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600])),
          Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.w500)),
        ],
      ),
    );
  }
}
