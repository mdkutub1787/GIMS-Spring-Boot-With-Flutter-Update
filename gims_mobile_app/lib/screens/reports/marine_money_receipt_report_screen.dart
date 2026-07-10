import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../viewmodels/marine_receipt_viewmodel.dart';

class MarineMoneyReceiptReportScreen extends ConsumerStatefulWidget {
  const MarineMoneyReceiptReportScreen({super.key});

  @override
  ConsumerState<MarineMoneyReceiptReportScreen> createState() => _MarineMoneyReceiptReportScreenState();
}

class _MarineMoneyReceiptReportScreenState extends ConsumerState<MarineMoneyReceiptReportScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(marineReceiptViewModelProvider.notifier).fetchReceipts());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(marineReceiptViewModelProvider);
    
    double totalGross = state.receipts.fold(0, (sum, item) => sum + (item.marinebill?.grossPremium ?? 0));
    double totalTax = state.receipts.fold(0, (sum, item) => sum + (item.marinebill?.tax ?? 0));

    Map<String, double> dataMap = {
      "Tax Component": totalTax,
      "Base Premium": totalGross - totalTax,
    };

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Marine MR Report', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: state.isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryGrid(state.receipts.length, totalGross),
                const SizedBox(height: 30),
                Text('Tax vs Premium', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: PieChart(
                    dataMap: dataMap,
                    chartType: ChartType.ring,
                    ringStrokeWidth: 32,
                    colorList: [Colors.red.shade300, Colors.indigo.shade300],
                    legendOptions: LegendOptions(legendPosition: LegendPosition.bottom, legendTextStyle: GoogleFonts.poppins()),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildSummaryGrid(int count, double total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.indigo.shade300, Colors.indigo.shade600]),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Text('Total Marine MR Value', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
          Text('TK ${total.toStringAsFixed(0)}', style: GoogleFonts.poppins(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
          const Divider(height: 30, color: Colors.white24),
          Text('Total Receipts: $count', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
