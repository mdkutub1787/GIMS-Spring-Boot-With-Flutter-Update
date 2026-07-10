import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/marine_policy_viewmodel.dart';

class MarinePolicyReportScreen extends ConsumerStatefulWidget {
  const MarinePolicyReportScreen({super.key});

  @override
  ConsumerState<MarinePolicyReportScreen> createState() => _MarinePolicyReportScreenState();
}

class _MarinePolicyReportScreenState extends ConsumerState<MarinePolicyReportScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(marinePolicyViewModelProvider.notifier).fetchPolicies());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(marinePolicyViewModelProvider);
    final theme = Theme.of(context);

    double totalTk = state.policies.fold(0, (sum, item) => sum + (item.sumInsured ?? 0));
    double totalUsd = state.policies.fold(0, (sum, item) => sum + (item.sumInsuredUsd ?? 0));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Marine Policy Report', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: state.isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummarySection(state.policies.length, totalTk, totalUsd, theme),
                const SizedBox(height: 30),
                Text('Policy Listing', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.policies.length,
                  itemBuilder: (context, index) {
                    final policy = state.policies[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: Colors.indigo.withOpacity(0.1), shape: BoxShape.circle),
                            child: const Icon(Icons.directions_boat_filled_rounded, color: Colors.indigo, size: 20),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(policy.policyholder ?? 'N/A', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
                                Text(policy.bank?.name ?? 'N/A', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('TK ${policy.sumInsured?.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.green)),
                              Text('\$${policy.sumInsuredUsd?.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
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

  Widget _buildSummarySection(int count, double tk, double usd, ThemeData theme) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.indigo.shade400, Colors.indigo.shade700]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text('Total Sum Insured (TK)', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
              Text('TK ${tk.toStringAsFixed(0)}', style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const Divider(height: 30, color: Colors.white24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _miniStat('Policies', count.toString()),
                  _miniStat('Total USD', '\$${usd.toStringAsFixed(0)}'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _miniStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: GoogleFonts.poppins(color: Colors.white60, fontSize: 11)),
        Text(value, style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
