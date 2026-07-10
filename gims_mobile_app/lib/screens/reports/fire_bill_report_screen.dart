import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../viewmodels/fire_bill_viewmodel.dart';

class FireBillReportScreen extends ConsumerStatefulWidget {
  const FireBillReportScreen({super.key});

  @override
  ConsumerState<FireBillReportScreen> createState() => _FireBillReportScreenState();
}

class _FireBillReportScreenState extends ConsumerState<FireBillReportScreen> {
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(fireBillViewModelProvider.notifier).fetchBills());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fireBillViewModelProvider);
    final theme = Theme.of(context);

    double totalNet = state.bills.fold(0, (sum, item) => sum + (item.netPremium));
    double totalTax = state.bills.fold(0, (sum, item) => sum + (item.tax));
    double totalGross = state.bills.fold(0, (sum, item) => sum + (item.grossPremium));

    Map<String, double> dataMap = {
      "Net Premium": totalNet,
      "Tax": totalTax,
      "Gross": totalGross,
    };

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Fire Bill Report', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: state.isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatGrid(totalNet, totalTax, totalGross, state.bills.length),
                const SizedBox(height: 30),
                Text('Distribution', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: PieChart(
                    dataMap: dataMap,
                    chartType: ChartType.disc,
                    colorList: [Colors.orange.shade300, Colors.red.shade300, Colors.green.shade300],
                    legendOptions: LegendOptions(legendPosition: LegendPosition.bottom, legendTextStyle: GoogleFonts.poppins()),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildStatGrid(double net, double tax, double gross, int count) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      childAspectRatio: 1.5,
      children: [
        _statCard('Total Bills', count.toString(), Colors.blue),
        _statCard('Net Total', 'TK ${net.toStringAsFixed(0)}', Colors.orange),
        _statCard('Total Tax', 'TK ${tax.toStringAsFixed(0)}', Colors.red),
        _statCard('Gross Total', 'TK ${gross.toStringAsFixed(0)}', Colors.green),
      ],
    );
  }

  Widget _statCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
          FittedBox(child: Text(value, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87))),
        ],
      ),
    );
  }
}
