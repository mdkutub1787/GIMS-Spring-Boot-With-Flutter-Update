import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/marine/marine_policy.dart';

class MarinePolicyDetailsScreen extends StatelessWidget {
  final MarinePolicy policy;
  const MarinePolicyDetailsScreen({super.key, required this.policy});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Marine Policy Details', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildHeader(theme, isDark),
            const SizedBox(height: 25),
            _buildDetailCard([
              _detailRow('Policyholder', policy.policyholder ?? 'N/A', theme),
              _detailRow('Bank Name', policy.bank?.name ?? 'N/A', theme),
              _detailRow('Sum Insured', 'TK ${policy.sumInsured}', theme),
              _detailRow('Stock Item', policy.stockItem ?? 'N/A', theme),
              _detailRow('Voyage From', policy.voyageFrom ?? 'N/A', theme),
              _detailRow('Voyage To', policy.voyageTo ?? 'N/A', theme),
              _detailRow('Via', policy.via ?? 'N/A', theme),
              _detailRow('Coverage', policy.coverage ?? 'N/A', theme),
            ], theme, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(Icons.directions_boat_rounded, size: 50, color: theme.colorScheme.primary),
          const SizedBox(height: 10),
          Text('Marine Policy #${policy.id}', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
          Text('Created on: ${policy.date != null ? DateFormat('MMM dd, yyyy').format(policy.date!) : 'N/A'}',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildDetailCard(List<Widget> children, ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(children: children),
    );
  }

  Widget _detailRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey))),
          Expanded(child: Text(value, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface))),
        ],
      ),
    );
  }
}
