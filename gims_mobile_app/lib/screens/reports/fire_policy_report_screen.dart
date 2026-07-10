import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/fire_policy_viewmodel.dart';

class FirePolicyReportScreen extends ConsumerStatefulWidget {
  const FirePolicyReportScreen({super.key});

  @override
  ConsumerState<FirePolicyReportScreen> createState() => _FirePolicyReportScreenState();
}

class _FirePolicyReportScreenState extends ConsumerState<FirePolicyReportScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(firePolicyViewModelProvider.notifier).fetchPolicies());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(firePolicyViewModelProvider);
    final theme = Theme.of(context);

    double totalSum = state.policies.fold(0, (sum, item) => sum + (item.sumInsured ?? 0));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Fire Policy Report', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildStatCard('Total Policies', state.policies.length.toString(), Icons.policy, Colors.blue),
                const SizedBox(width: 15),
                _buildStatCard('Sum Insured', 'TK ${totalSum.toStringAsFixed(0)}', Icons.monetization_on, Colors.green),
              ],
            ),
            const SizedBox(height: 30),
            Text('Policy List', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.policies.length,
              itemBuilder: (context, index) {
                final policy = state.policies[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      CircleAvatar(backgroundColor: Colors.blue.withOpacity(0.1), child: Text('#${policy.id}', style: const TextStyle(fontSize: 10))),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(policy.policyholder ?? 'N/A', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                            Text(policy.bank?.name ?? 'N/A', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      Text('TK ${policy.sumInsured}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.1))),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 10),
            Text(title, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
            Text(value, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
