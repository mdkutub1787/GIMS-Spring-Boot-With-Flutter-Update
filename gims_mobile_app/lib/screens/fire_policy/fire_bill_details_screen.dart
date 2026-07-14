import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/fire/fire_bill.dart';
import '../../core/widgets/brand_app_bar.dart';
import '../../services/pdf_service.dart';

class FireBillDetailsScreen extends StatelessWidget {
  final FireBill bill;
  const FireBillDetailsScreen({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: BrandAppBar(
        title: Text('Bill Details', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: theme.colorScheme.onSurface)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.colorScheme.onSurface, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildAmountHeader(theme),
            const SizedBox(height: 24),
            _buildDetailCard('Client Information', Icons.person_rounded, [
              _detailRow('Policyholder', bill.policy?.policyholder ?? 'N/A', theme),
              _detailRow('Bank Name', bill.policy?.bank?.name ?? 'N/A', theme),
              _detailRow('Policy ID', '#${bill.policy?.id ?? 'N/A'}', theme),
              _detailRow('Date', bill.policy?.date != null ? DateFormat('dd MMM, yyyy').format(bill.policy!.date!) : 'N/A', theme),
            ], theme, isDark),
            const SizedBox(height: 20),
            _buildDetailCard('Premium Summary', Icons.analytics_rounded, [
              _detailRow('Fire Premium', 'TK ${NumberFormat('#,##,###').format(bill.fireAmount)} (${bill.fire}%)', theme),
              _detailRow('RSD Premium', 'TK ${NumberFormat('#,##,###').format(bill.rsdAmount)} (${bill.rsd}%)', theme),
              _detailRow('Net Premium', 'TK ${NumberFormat('#,##,###').format(bill.netPremium)}', theme),
              _detailRow('VAT (Tax)', 'TK ${NumberFormat('#,##,###').format(bill.taxAmount)} (${bill.tax}%)', theme),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(height: 1, thickness: 0.5)),
              _detailRow('Total Payable', 'TK ${NumberFormat('#,##,###').format(bill.grossPremium)}', theme, isBold: true, color: theme.colorScheme.primary),
            ], theme, isDark),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () => PdfService.generateFireBillPdf(bill),
                icon: const Icon(Icons.print_rounded),
                label: Text('Download Bill PDF', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.transparent : Colors.white,
                  foregroundColor: theme.colorScheme.primary,
                  side: BorderSide(color: theme.colorScheme.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountHeader(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [theme.colorScheme.primary, theme.colorScheme.secondary]),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: theme.colorScheme.primary.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          Text('TOTAL PREMIUM AMOUNT', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 8),
          Text('TK ${NumberFormat('#,##,###').format(bill.grossPremium)}', style: GoogleFonts.poppins(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
            child: Text('Bill ID: #${bill.id}', style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(String title, IconData icon, List<Widget> children, ThemeData theme, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, ThemeData theme, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500)),
          Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.w600, color: color ?? theme.colorScheme.onSurface)),
        ],
      ),
    );
  }
}
