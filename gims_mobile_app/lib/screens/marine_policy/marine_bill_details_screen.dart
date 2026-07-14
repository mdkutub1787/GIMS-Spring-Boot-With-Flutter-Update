import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/marine/marine_bill.dart';

class MarineBillDetailsScreen extends StatelessWidget {
  final MarineBill bill;
  const MarineBillDetailsScreen({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Marine Bill Details', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildAmountHeader(theme),
            const SizedBox(height: 25),
            _buildDetailCard('Vessel & Voyage', [
              _detailRow('Voyage From', bill.marineDetails?.voyageFrom ?? 'N/A', theme),
              _detailRow('Voyage To', bill.marineDetails?.voyageTo ?? 'N/A', theme),
              _detailRow('Via', bill.marineDetails?.via ?? 'N/A', theme),
            ], theme, isDark),
            const SizedBox(height: 20),
            _buildDetailCard('Premium Calculation', [
              _detailRow('Marine Rate', '${bill.marineRate}%', theme),
              _detailRow('War/SRCC Rate', '${bill.warSrccRate}%', theme),
              _detailRow('Net Premium', 'TK ${bill.netPremium}', theme),
              _detailRow('Tax (15%)', 'TK ${bill.tax}', theme),
              _detailRow('Stamp Duty', 'TK ${bill.stampDuty}', theme),
              const Divider(height: 30),
              _detailRow('Gross Total', 'TK ${bill.grossPremium}', theme, isBold: true),
            ], theme, isDark),
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
        gradient: LinearGradient(colors: [theme.colorScheme.primary, theme.colorScheme.secondary]),
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

  Widget _buildDetailCard(String title, List<Widget> children, ThemeData theme, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
          const SizedBox(height: 15),
          ...children,
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, ThemeData theme, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey)),
          Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.w500, color: theme.colorScheme.onSurface)),
        ],
      ),
    );
  }
}
