import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/marine_receipt_viewmodel.dart';
import '../../core/routing/app_router.dart';

class ViewMarineMoneyReceiptScreen extends ConsumerStatefulWidget {
  const ViewMarineMoneyReceiptScreen({super.key});

  @override
  ConsumerState<ViewMarineMoneyReceiptScreen> createState() => _ViewMarineMoneyReceiptScreenState();
}

class _ViewMarineMoneyReceiptScreenState extends ConsumerState<ViewMarineMoneyReceiptScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(marineReceiptViewModelProvider.notifier).fetchReceipts());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(marineReceiptViewModelProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Marine MR List', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
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
                hintText: 'Search MR or Policyholder...',
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
                : state.receipts.isEmpty
                    ? Center(child: Text('No receipts found', style: GoogleFonts.poppins()))
                    : ListView.builder(
                        padding: const EdgeInsets.all(15),
                        itemCount: state.receipts.length,
                        itemBuilder: (context, index) {
                          final receipt = state.receipts[index];
                          return _buildReceiptCard(receipt, theme);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRouter.viewMarineMoneyReceipt), // Update to create route
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildReceiptCard(dynamic receipt, ThemeData theme) {
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
                Text('MR ID: #${receipt.id}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.indigo)),
                Text(receipt.date != null ? DateFormat('yyyy-MM-dd').format(receipt.date!) : 'N/A', 
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 10),
            Text(receipt.marinebill?.marineDetails.policyholder ?? 'N/A', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Bank: ${receipt.marinebill?.marineDetails.bankName ?? 'N/A'}', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600])),
            const Divider(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Premium Value', style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                    Text('TK ${receipt.marinebill?.grossPremium ?? 0}', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
                Row(
                  children: [
                    IconButton(icon: const Icon(Icons.print_rounded, color: Colors.blue), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.delete_outline_rounded, color: Colors.red), 
                      onPressed: () => ref.read(marineReceiptViewModelProvider.notifier).deleteReceipt(receipt.id!)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
