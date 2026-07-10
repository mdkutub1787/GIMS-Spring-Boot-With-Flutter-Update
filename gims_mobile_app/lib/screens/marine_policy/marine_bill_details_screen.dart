import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/marine/marine_bill.dart';

class MarineBillDetailsScreen extends StatelessWidget {
  final MarineBill bill;
  const MarineBillDetailsScreen({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Marine Bill Details', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildAmountHeader(theme),
            const SizedBox(height: 25),
            _buildDetailCard('Vessel & Voyage', [
              _detailRow('Voyage From', bill.marineDetails?.voyageFrom ?? 'N/A'),
              _detailRow('Voyage To', bill.marineDetails?.voyageTo ?? 'N/A'),
              _detailRow('Via', bill.marineDetails?.via ?? 'N/A'),
            ]),
            const SizedBox(height: 20),
            _buildDetailCard('Premium Calculation', [
              _detailRow('Marine Rate', '${bill.marineRate}%'),
              _detailRow('War/SRCC Rate', '${bill.warSrccRate}%'),
              _detailRow('Net Premium', 'TK ${bill.netPremium}'),
              _detailRow('Tax (15%)', 'TK ${bill.tax}'),
              _detailRow('Stamp Duty', 'TK ${bill.stampDuty}'),
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
        gradient: LinearGradient(colors: [Colors.indigo.shade400, Colors.indigo.shade700]),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Text('Marine Insurance Bill', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
          Text('TK ${bill.grossPremium}', style: GoogleFonts.poppins(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text('Policy: ${bill.marineDetails?.policyholder ?? 'N/A'}', style: GoogleFonts.poppins(color: Colors.white, fontSize: 14)),
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
          Text(title, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.indigo)),
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
