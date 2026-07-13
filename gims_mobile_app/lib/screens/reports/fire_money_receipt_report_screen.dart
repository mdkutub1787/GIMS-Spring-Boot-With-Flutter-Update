import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../viewmodels/fire_receipt_viewmodel.dart';

class FireMoneyReceiptReportScreen extends ConsumerStatefulWidget {
  const FireMoneyReceiptReportScreen({super.key});

  @override
  ConsumerState<FireMoneyReceiptReportScreen> createState() => _FireMoneyReceiptReportScreenState();
}

class _FireMoneyReceiptReportScreenState extends ConsumerState<FireMoneyReceiptReportScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(fireReceiptViewModelProvider.notifier).fetchReceipts());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fireReceiptViewModelProvider);
    
    double totalGross = state.receipts.fold(0, (sum, item) => sum + (item.bill?.grossPremium ?? 0));
    double totalNet = state.receipts.fold(0, (sum, item) => sum + (item.bill?.netPremium ?? 0));

    Map<String, double> dataMap = {
      "Net Value": totalNet,
      "Gross Value": totalGross,
    };

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Fire MR Report', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: state.isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(state.receipts.length, totalGross),
                const SizedBox(height: 30),
                Text('Value distribution', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: PieChart(
                    dataMap: dataMap,
                    chartType: ChartType.disc,
                    colorList: [Color(0xFFA57CFA), Colors.orange.shade300],
                    legendOptions: LegendOptions(legendPosition: LegendPosition.bottom, legendTextStyle: GoogleFonts.poppins()),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildSummaryCard(int count, double total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Receipts', style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
              Text(count.toString(), style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Total Value', style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
              Text('TK ${total.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF7C3AED))),
            ],
          ),
        ],
      ),
    );
  }
}
