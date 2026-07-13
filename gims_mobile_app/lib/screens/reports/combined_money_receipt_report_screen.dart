import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../viewmodels/fire_receipt_viewmodel.dart';
import '../../viewmodels/marine_receipt_viewmodel.dart';

class CombinedMoneyReceiptReportScreen extends ConsumerStatefulWidget {
  const CombinedMoneyReceiptReportScreen({super.key});

  @override
  ConsumerState<CombinedMoneyReceiptReportScreen> createState() => _CombinedMoneyReceiptReportScreenState();
}

class _CombinedMoneyReceiptReportScreenState extends ConsumerState<CombinedMoneyReceiptReportScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(fireReceiptViewModelProvider.notifier).fetchReceipts();
      ref.read(marineReceiptViewModelProvider.notifier).fetchReceipts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final fireState = ref.watch(fireReceiptViewModelProvider);
    final marineState = ref.watch(marineReceiptViewModelProvider);

    double fireTotal = fireState.receipts.fold(0, (sum, item) => sum + (item.bill?.grossPremium ?? 0));
    double marineTotal = marineState.receipts.fold(0, (sum, item) => sum + (item.marinebill?.grossPremium ?? 0));

    Map<String, double> dataMap = {
      "Fire Receipts": fireTotal,
      "Marine Receipts": marineTotal,
    };

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Combined MR Report', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: (fireState.isLoading || marineState.isLoading)
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummary(fireTotal + marineTotal, fireState.receipts.length + marineState.receipts.length),
                const SizedBox(height: 30),
                Text('Volume Analysis', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: PieChart(
                    dataMap: dataMap,
                    chartType: ChartType.ring,
                    ringStrokeWidth: 32,
                    colorList: [Colors.orange.shade400, Colors.teal.shade400],
                    legendOptions: LegendOptions(legendPosition: LegendPosition.bottom, legendTextStyle: GoogleFonts.poppins()),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildSummary(double total, int count) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Text('Grand Total Collection', style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13)),
          Text('TK ${total.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: const Color(0xFF7C3AED))),
          const SizedBox(height: 10),
          Text('Total MR: $count', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[700])),
        ],
      ),
    );
  }
}
