import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/policy_model.dart';

class FirePolicyDetailsScreen extends StatelessWidget {
  final PolicyModel policy;
  const FirePolicyDetailsScreen({super.key, required this.policy});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Policy Details', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildHeader(theme),
            const SizedBox(height: 25),
            _buildDetailCard([
              _detailRow('System No', policy.sysNumber ?? 'N/A'),
              _detailRow('Company', policy.company ?? 'N/A'),
              _detailRow('Policyholder', policy.policyholder ?? 'N/A'),
              _detailRow('Bank Name', policy.bankName ?? 'N/A'),
              _detailRow('Branch Name', policy.branchName ?? 'N/A'),
              _detailRow('Sum Insured', 'TK ${policy.sumInsured}'),
              _detailRow('Stock Insured', policy.stockInsured ?? 'N/A'),
              _detailRow('Location', policy.location ?? 'N/A'),
              _detailRow('Construction', policy.construction ?? 'N/A'),
              _detailRow('Usage', policy.usedAs ?? 'N/A'),
            ]),
            const SizedBox(height: 20),
            _buildDetailCard([
              _detailRow('Period From', policy.periodFrom != null ? DateFormat('yyyy-MM-dd').format(policy.periodFrom!) : 'N/A'),
              _detailRow('Period To', policy.periodTo != null ? DateFormat('yyyy-MM-dd').format(policy.periodTo!) : 'N/A'),
              _detailRow('Coverage', policy.coverage ?? 'N/A'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(Icons.security_rounded, size: 50, color: Colors.blue),
          const SizedBox(height: 10),
          Text(policy.sysNumber ?? 'Policy #${policy.id}', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(policy.company ?? 'N/A', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.blueGrey)),
          Text('Created on: ${policy.date != null ? DateFormat('MMM dd, yyyy').format(policy.date!) : 'N/A'}',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildDetailCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(children: children),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]))),
          Expanded(child: Text(value, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}
