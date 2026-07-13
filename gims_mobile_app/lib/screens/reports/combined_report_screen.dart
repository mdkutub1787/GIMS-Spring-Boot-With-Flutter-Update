import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/fire_bill_viewmodel.dart';
import '../../viewmodels/marine_bill_viewmodel.dart';

class CombinedReportScreen extends ConsumerStatefulWidget {
  const CombinedReportScreen({super.key});

  @override
  ConsumerState<CombinedReportScreen> createState() => _CombinedReportScreenState();
}

class _CombinedReportScreenState extends ConsumerState<CombinedReportScreen> {
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(fireBillViewModelProvider.notifier).fetchBills();
      ref.read(marineBillViewModelProvider.notifier).fetchBills();
    });
  }

  @override
  Widget build(BuildContext context) {
    final fireState = ref.watch(fireBillViewModelProvider);
    final marineState = ref.watch(marineBillViewModelProvider);
    final theme = Theme.of(context);

    double totalFireGross = fireState.bills.fold(0, (sum, item) => sum + (item.grossPremium));
    double totalMarineGross = marineState.bills.fold(0, (sum, item) => sum + (item.grossPremium));

    Map<String, double> dataMap = {
      "Fire Insurance": totalFireGross,
      "Marine Insurance": totalMarineGross,
    };

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Combined Report', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(totalFireGross + totalMarineGross, theme),
            const SizedBox(height: 25),
            Text('Business Distribution', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: PieChart(
                dataMap: dataMap,
                chartType: ChartType.ring,
                ringStrokeWidth: 32,
                colorList: [Colors.orange.shade400, Color(0xFF915CEB)],
                legendOptions: LegendOptions(legendPosition: LegendPosition.bottom, legendTextStyle: GoogleFonts.poppins()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(double total, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [theme.colorScheme.primary, theme.colorScheme.primary.withOpacity(0.8)]),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Text('Grand Total Premium', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14)),
          Text('TK ${total.toStringAsFixed(0)}', style: GoogleFonts.poppins(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Icon(Icons.analytics_outlined, color: Colors.white54, size: 40),
        ],
      ),
    );
  }
}
