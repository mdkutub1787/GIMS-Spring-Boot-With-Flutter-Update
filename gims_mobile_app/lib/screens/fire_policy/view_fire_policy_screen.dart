import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/routing/app_router.dart';
import '../../viewmodels/fire_policy_viewmodel.dart';
import '../../models/fire/fire_policy.dart';

class ViewFirePolicyScreen extends ConsumerStatefulWidget {
  const ViewFirePolicyScreen({super.key});

  @override
  ConsumerState<ViewFirePolicyScreen> createState() => _ViewFirePolicyScreenState();
}

class _ViewFirePolicyScreenState extends ConsumerState<ViewFirePolicyScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(firePolicyViewModelProvider.notifier).fetchPolicies());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(firePolicyViewModelProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Fire Policies', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => Navigator.pop(context)),
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
        onPressed: () => Navigator.pushNamed(context, AppRouter.createFirePolicy),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildPolicyCard(FirePolicy policy, ThemeData theme) {
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
                Text(
                  policy.sysNumber != null ? 'Sys No: ${policy.sysNumber}' : 'ID: #${policy.id}',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                ),
                Text(policy.date != null ? DateFormat('yyyy-MM-dd').format(policy.date!) : 'N/A', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.business, size: 16, color: Colors.blueGrey),
                const SizedBox(width: 5),
                Text(policy.company ?? 'N/A', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blueGrey)),
              ],
            ),
            const SizedBox(height: 5),
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
            ref.read(firePolicyViewModelProvider.notifier).deletePolicy(id);
          }, child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}
