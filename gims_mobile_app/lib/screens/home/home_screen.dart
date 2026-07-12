import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/routing/app_router.dart';
import '../../core/widgets/brand_app_bar.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/fire_policy_viewmodel.dart';
import '../../core/theme/app_theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isCalculatorExpanded = false;
  final ScrollController _scrollController = ScrollController();
  
  final TextEditingController _calcSumController = TextEditingController();
  final TextEditingController _calcRateController = TextEditingController();
  double _calcNet = 0.0;
  double _calcGross = 0.0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(firePolicyViewModelProvider.notifier).fetchPolicies();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _calcSumController.dispose();
    _calcRateController.dispose();
    super.dispose();
  }

  void _calculatePremium() {
    double sum = double.tryParse(_calcSumController.text) ?? 0.0;
    double rate = double.tryParse(_calcRateController.text) ?? 0.0;
    double net = (sum * rate) / 100;
    double gross = net + (net * 0.15); // assuming 15% tax
    setState(() {
      _calcNet = net;
      _calcGross = gross;
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    if (hour < 21) return 'Good Evening';
    return 'Good Night';
  }

  IconData _getGreetingIcon() {
    final hour = DateTime.now().hour;
    if (hour < 12) return Icons.wb_sunny_rounded;
    if (hour < 17) return Icons.wb_cloudy_rounded;
    if (hour < 21) return Icons.wb_twilight_rounded;
    return Icons.nights_stay_rounded;
  }

  Color _getGreetingColor() {
    final hour = DateTime.now().hour;
    if (hour < 12) return Colors.orange.shade700;
    if (hour < 17) return Colors.blue.shade600;
    if (hour < 21) return Colors.deepOrange;
    return Colors.indigo.shade400;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final policyState = ref.watch(firePolicyViewModelProvider);
    final user = ref.watch(authViewModelProvider).user;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: BrandAppBar(
        height: 65.0,
        leadingWidth: 100,
        leading: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: InkWell(
              onTap: () => Scaffold.of(context).openDrawer(),
              borderRadius: BorderRadius.circular(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: Colors.blue),
                      ),
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4)]
                        ),
                        child: const Icon(Icons.menu, color: Colors.black, size: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        title: const Text('Dashboard', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded, size: 28, color: Colors.black87),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _buildDrawer(context),
      body: RefreshIndicator(
        onRefresh: () => ref.read(firePolicyViewModelProvider.notifier).fetchPolicies(),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              // Header with Greeting
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${_getGreeting()}, ',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: _getGreetingColor(),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: user?.name ?? 'Admin User',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), shape: BoxShape.circle),
                      child: Icon(_getGreetingIcon(), color: _getGreetingColor(), size: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              // Pulsing Live Badge (FFLIPY style)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _PulsingLiveBadge(label: 'LIVE: Managing Insurance Data'),
              ),
              const SizedBox(height: 20),
              // Action Grid Container (FFLIPY style)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      )
                    ],
                    border: Border.all(color: Colors.blue.withOpacity(0.05), width: 1.5),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCircleAction(context, Icons.security_rounded, 'Fire Policy', () => Navigator.pushNamed(context, AppRouter.viewFirePolicy), theme.colorScheme.primary),
                          _buildCircleAction(context, Icons.receipt_long_rounded, 'Fire Bill', () => Navigator.pushNamed(context, AppRouter.viewFireBill), theme.colorScheme.success),
                          _buildCircleAction(context, Icons.payments_rounded, 'Money Receipt', () => Navigator.pushNamed(context, AppRouter.viewFireMoneyReceipt), theme.colorScheme.warning),
                          _buildCircleAction(context, Icons.directions_boat_rounded, 'Marine Policy', () => Navigator.pushNamed(context, AppRouter.viewMarinePolicy), theme.colorScheme.secondary),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCircleAction(context, Icons.description_rounded, 'Marine Bill', () => Navigator.pushNamed(context, AppRouter.viewMarineBill), theme.colorScheme.success),
                          _buildCircleAction(context, Icons.account_balance_wallet_rounded, 'Marine Receipt', () => Navigator.pushNamed(context, AppRouter.viewMarineMoneyReceipt), theme.colorScheme.warning),
                          _buildCircleAction(context, Icons.assessment_rounded, 'Reports', () => Navigator.pushNamed(context, AppRouter.firePolicyReport), theme.colorScheme.tertiary),
                          _buildCircleAction(context, Icons.analytics_rounded, 'Combined', () => Navigator.pushNamed(context, AppRouter.combinedReport), theme.colorScheme.info),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              // Pending Requests
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Pending Requests', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 16)),
                    Text('Track All', style: TextStyle(color: theme.colorScheme.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 3,
                  itemBuilder: (context, index) => _buildPendingCardShort(index),
                ),
              ),
              const SizedBox(height: 20),
              // Expandable Calculator Card (FFLIPY style)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue.withOpacity(0.3), width: 1.5),
                    boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 10))],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () => setState(() => _isCalculatorExpanded = !_isCalculatorExpanded),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue.withOpacity(0.05), Colors.white],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: Colors.blue.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                                child: const Icon(Icons.calculate_rounded, color: Colors.blue, size: 24),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Premium Calculator', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    Text('Check rates instantly', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                              AnimatedRotation(
                                turns: _isCalculatorExpanded ? 0.5 : 0,
                                duration: const Duration(milliseconds: 300),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), shape: BoxShape.circle),
                                  child: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.blue, size: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_isCalculatorExpanded)
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text('Quick Premium Estimation', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue.shade700)),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _calcSumController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: 'Sum Insured',
                                        isDense: true,
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      onChanged: (_) => _calculatePremium(),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      controller: _calcRateController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: 'Rate (%)',
                                        isDense: true,
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      onChanged: (_) => _calculatePremium(),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Net Premium', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
                                        Text('TK ${_calcNet.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        const Text('Gross (incl 15% VAT)', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
                                        Text('TK ${_calcGross.toStringAsFixed(0)}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade700, fontSize: 16)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              // Recent Activity Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Activity', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                    TextButton(onPressed: () {}, child: const Text('View All')),
                  ],
                ),
              ),
              policyState.isLoading
                  ? const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: policyState.policies.take(5).length,
                      itemBuilder: (context, index) => _buildActivityTile(policyState.policies[index], index),
                    ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleAction(BuildContext context, IconData icon, String label, VoidCallback onTap, Color color) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(32),
          child: Container(
            width: 62, height: 62,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 24),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 86,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 11,
              color: Colors.black54,
              height: 1.1,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPendingCardShort(int index) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 12, bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(index == 0 ? 'Fire Policy #102' : index == 1 ? 'Marine Bill #50' : 'MR #203', 
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), 
            maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Pending', style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
              Text('TK ${5000 * (index + 1)}', style: TextStyle(color: Colors.blue.shade700, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTile(dynamic policy, int index) {
    final bgColor = index % 2 == 0 ? Colors.white : Colors.blue.withOpacity(0.02);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: Colors.blue.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.security, color: Colors.blue, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(policy.policyholder ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(policy.bank?.name ?? 'N/A',
                        style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('TK ${NumberFormat('#,##,###').format(policy.sumInsured ?? 0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 14)),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: Colors.green.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                      child: const Text('Processed', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 9)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final user = ref.watch(authViewModelProvider).user;
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(32), bottomRight: Radius.circular(32))),
      child: Column(
        children: [
          _buildDrawerHeader(user),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                _buildDrawerSectionTitle('Dashboard'),
                _buildDrawerItem(Icons.home_rounded, 'Home', () => Navigator.pop(context), Colors.blue),
                _buildDrawerItem(Icons.security_rounded, 'Fire Insurance', () => Navigator.pushNamed(context, AppRouter.viewFirePolicy), Colors.orange),
                _buildDrawerItem(Icons.directions_boat_rounded, 'Marine Insurance', () => Navigator.pushNamed(context, AppRouter.viewMarinePolicy), Colors.teal),
                _buildDrawerItem(Icons.assessment_rounded, 'View Reports', () => Navigator.pushNamed(context, AppRouter.firePolicyReport), Colors.purple),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8), child: Divider(thickness: 1, height: 1)),
                _buildDrawerSectionTitle('App Settings'),
                _buildDrawerItem(Icons.person_outline_rounded, 'My Profile', () => Navigator.pushNamed(context, AppRouter.profile), Colors.blue),
                _buildDrawerItem(Icons.notifications_none_rounded, 'Notifications', () {}, Colors.indigo),
                _buildDrawerItem(Icons.help_outline_rounded, 'Help & Support', () {}, Colors.green),
                const SizedBox(height: 16),
                _buildDrawerItem(Icons.logout_rounded, 'Log Out', () {
                  ref.read(authViewModelProvider.notifier).logout().then((_) => Navigator.pushReplacementNamed(context, AppRouter.login));
                }, Colors.redAccent),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text('Version 1.0.2', style: TextStyle(fontSize: 10, color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.blue.withOpacity(0.7),
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(dynamic user) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRouter.profile),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20, bottom: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary], 
            begin: Alignment.topLeft, 
            end: Alignment.bottomRight
          ),
          borderRadius: const BorderRadius.only(topRight: Radius.circular(32)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.2), width: 3)),
              child: CircleAvatar(radius: 38, backgroundColor: Colors.white, child: Icon(Icons.person, size: 38, color: Theme.of(context).colorScheme.primary)),
            ),
            const SizedBox(height: 12),
            Text(user?.name ?? 'Admin User', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
            Text(user?.email ?? 'admin@gims.com', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.85), fontWeight: FontWeight.w500)),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Data Completion', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      Text('85%', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const LinearProgressIndicator(value: 0.85, minHeight: 4, backgroundColor: Colors.white24, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        onTap: onTap,
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
      ),
    );
  }
}

class _PulsingLiveBadge extends StatefulWidget {
  final String label;
  const _PulsingLiveBadge({required this.label});

  @override
  State<_PulsingLiveBadge> createState() => _PulsingLiveBadgeState();
}

class _PulsingLiveBadgeState extends State<_PulsingLiveBadge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.withOpacity(0.3), width: 1.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8, height: 8,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.6), blurRadius: 6, spreadRadius: 2)],
              ),
            ),
            const SizedBox(width: 8),
            Text(widget.label, style: const TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          ],
        ),
      ),
    );
  }
}
