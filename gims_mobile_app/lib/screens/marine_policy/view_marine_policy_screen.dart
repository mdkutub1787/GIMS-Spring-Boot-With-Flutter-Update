import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/marine_policy_viewmodel.dart';
import '../../models/marine/marine_policy.dart';
import '../../core/routing/app_router.dart';
import 'marine_policy_details_screen.dart';

class ViewMarinePolicyScreen extends ConsumerStatefulWidget {
  const ViewMarinePolicyScreen({super.key});

  @override
  ConsumerState<ViewMarinePolicyScreen> createState() => _ViewMarinePolicyScreenState();
}

class _ViewMarinePolicyScreenState extends ConsumerState<ViewMarinePolicyScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(marinePolicyViewModelProvider.notifier).fetchPolicies());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(marinePolicyViewModelProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Marine Policies', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            color: Colors.white,
            child: TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search by policyholder or bank...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.policies.isEmpty
                    ? Center(child: Text('No policies found', style: GoogleFonts.poppins()))
                    : ListView.builder(
                        padding: const EdgeInsets.all(15),
                        itemCount: state.policies.length,
                        itemBuilder: (context, index) {
                          final policy = state.policies[index];
                          if (searchController.text.isNotEmpty && 
                              !policy.policyholder!.toLowerCase().contains(searchController.text.toLowerCase())) {
                            return const SizedBox.shrink();
                          }
                          return _buildPolicyCard(policy, theme);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRouter.viewMarinePolicy), // This should be create route
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildPolicyCard(MarinePolicy policy, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ID: #${policy.id}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                Text(policy.date != null ? DateFormat('yyyy-MM-dd').format(policy.date!) : 'N/A', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 10),
            Text(policy.bankName ?? 'N/A', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(policy.policyholder ?? 'N/A', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700])),
            const Divider(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sum Insured', style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                    Text('TK ${policy.sumInsured}', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility_rounded, color: Colors.blue), 
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MarinePolicyDetailsScreen(policy: policy)))),
                    IconButton(icon: const Icon(Icons.edit_rounded, color: Colors.cyan), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.delete_outline_rounded, color: Colors.red), onPressed: () => _confirmDelete(policy.id!)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete?'),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(onPressed: () {
            Navigator.pop(context);
            ref.read(marinePolicyViewModelProvider.notifier).deletePolicy(id);
          }, child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}
