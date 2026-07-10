import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/marine_bill_viewmodel.dart';
import '../../models/marine/marine_bill.dart';
import 'marine_bill_details_screen.dart';

class ViewMarineBillScreen extends ConsumerStatefulWidget {
  const ViewMarineBillScreen({super.key});

  @override
  ConsumerState<ViewMarineBillScreen> createState() => _ViewMarineBillScreenState();
}

class _ViewMarineBillScreenState extends ConsumerState<ViewMarineBillScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(marineBillViewModelProvider.notifier).fetchBills());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(marineBillViewModelProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Marine Bill List', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
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
                hintText: 'Search by policyholder or ID...',
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
                : state.bills.isEmpty
                    ? Center(child: Text('No bills found', style: GoogleFonts.poppins()))
                    : ListView.builder(
                        padding: const EdgeInsets.all(15),
                        itemCount: state.bills.length,
                        itemBuilder: (context, index) {
                          final bill = state.bills[index];
                          return _buildBillCard(bill, theme);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillCard(MarineBill bill, ThemeData theme) {
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
                Text('Bill ID: #${bill.id}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.indigo)),
                Text(bill.marineDetails.date != null ? DateFormat('yyyy-MM-dd').format(DateTime.parse(bill.marineDetails.date.toString())) : 'N/A', 
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 10),
            Text(bill.marineDetails.policyholder ?? 'N/A', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(bill.marineDetails.bankName ?? 'N/A', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600])),
            const Divider(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gross Premium', style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                    Text('TK ${bill.grossPremium}', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility_rounded, color: Colors.blue), 
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MarineBillDetailsScreen(bill: bill)))),
                    IconButton(icon: const Icon(Icons.delete_outline_rounded, color: Colors.red), 
                      onPressed: () => ref.read(marineBillViewModelProvider.notifier).deleteBill(bill.id!)),
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
