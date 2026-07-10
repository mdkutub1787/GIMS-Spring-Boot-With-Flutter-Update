import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../viewmodels/marine_bill_viewmodel.dart';

class MarineBillReportScreen extends ConsumerStatefulWidget {
  const MarineBillReportScreen({super.key});

  @override
  ConsumerState<MarineBillReportScreen> createState() => _MarineBillReportScreenState();
}

class _MarineBillReportScreenState extends ConsumerState<MarineBillReportScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(marineBillViewModelProvider.notifier).fetchBills());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(marineBillViewModelProvider);
    
    double totalNet = state.bills.fold(0, (sum, item) => sum + (item.netPremium));
    double totalTax = state.bills.fold(0, (sum, item) => sum + (item.tax));
    double totalStamp = state.bills.fold(0, (sum, item) => sum + (item.stampDuty));
    double totalGross = state.bills.fold(0, (sum, item) => sum + (item.grossPremium));

    Map<String, double> dataMap = {
      "Net Premium": totalNet,
      "Tax": totalTax,
      "Stamp Duty": totalStamp,
    };

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Marine Bill Report', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: state.isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryGrid(totalNet, totalTax, totalStamp, totalGross),
                const SizedBox(height: 30),
                Text('Premium Distribution', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: PieChart(
                    dataMap: dataMap,
                    chartType: ChartType.ring,
                    ringStrokeWidth: 32,
                    colorList: [Colors.orange.shade400, Colors.red.shade400, Colors.teal.shade400],
                    legendOptions: LegendOptions(legendPosition: LegendPosition.bottom, legendTextStyle: GoogleFonts.poppins()),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildSummaryGrid(double net, double tax, double stamp, double gross) {
    return Column(
      children: [
        _mainStatCard('Total Gross Premium', 'TK ${gross.toStringAsFixed(0)}', Colors.green),
        const SizedBox(height: 15),
        Row(
          children: [
            _statCard('Net Total', 'TK ${net.toStringAsFixed(0)}', Colors.orange),
            const SizedBox(width: 15),
            _statCard('Total Tax', 'TK ${tax.toStringAsFixed(0)}', Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _mainStatCard(String title, String value, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(title, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700])),
          Text(value, style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade100)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
            FittedBox(child: Text(value, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87))),
          ],
        ),
      ),
    );
  }
}
