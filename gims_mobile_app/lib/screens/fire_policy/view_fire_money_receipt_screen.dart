import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/fire_receipt_viewmodel.dart';
import '../../models/fire/fire_money_receipt.dart';
import '../../core/routing/app_router.dart';

class ViewFireMoneyReceiptScreen extends ConsumerStatefulWidget {
  const ViewFireMoneyReceiptScreen({super.key});

  @override
  ConsumerState<ViewFireMoneyReceiptScreen> createState() => _ViewFireMoneyReceiptScreenState();
}

class _ViewFireMoneyReceiptScreenState extends ConsumerState<ViewFireMoneyReceiptScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(fireReceiptViewModelProvider.notifier).fetchReceipts());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fireReceiptViewModelProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Fire MR List', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
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
        onPressed: () => Navigator.pushNamed(context, AppRouter.createFireMoneyReceipt),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildReceiptCard(FireMoneyReceipt receipt, ThemeData theme) {
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
                Text('MR ID: #${receipt.id}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.orange[700])),
                Text(receipt.date != null ? DateFormat('yyyy-MM-dd').format(receipt.date!) : 'N/A', 
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 10),
            Text(receipt.bill?.policy.policyholder ?? 'N/A', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Against: ${receipt.issuedAgainst ?? 'N/A'}', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600])),
            const Divider(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Payment Mode', style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                    Text(receipt.modeOfPayment ?? 'N/A', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    IconButton(icon: const Icon(Icons.print_rounded, color: Colors.blue), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.delete_outline_rounded, color: Colors.red), 
                      onPressed: () => ref.read(fireReceiptViewModelProvider.notifier).deleteReceipt(receipt.id!)),
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
