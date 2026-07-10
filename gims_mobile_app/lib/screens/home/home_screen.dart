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
  bool _isBalanceVisible = false;
  bool _isCalculatorExpanded = false;
  Timer? _balanceTimer;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(firePolicyViewModelProvider.notifier).fetchPolicies();
    });
  }

  @override
  void dispose() {
    _balanceTimer?.cancel();
    super.dispose();
  }

  void _toggleBalance() {
    setState(() => _isBalanceVisible = !_isBalanceVisible);
    if (_isBalanceVisible) {
      _balanceTimer?.cancel();
      _balanceTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) setState(() => _isBalanceVisible = false);
      });
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    if (hour < 21) return 'Good Evening';
    return 'Good Night';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final policyState = ref.watch(firePolicyViewModelProvider);
    final user = ref.watch(authViewModelProvider).user;

    return Scaffold(
      backgroundColor: Colors.white,
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
        title: GestureDetector(
          onTap: _toggleBalance,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)]
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.account_balance_wallet, color: Colors.blue, size: 18),
                const SizedBox(width: 8),
                AnimatedCrossFade(
                  firstChild: const Text(
                    'BALANCE',
                    style: TextStyle(color: Color(0xFFE91E63), fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1),
                  ),
                  secondChild: const Text(
                    'TK 2,45,000',
                    style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  crossFadeState: _isBalanceVisible ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),
              ],
            ),
          ),
        ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              // FFLIPY Header
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
                              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.orange.shade700, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            TextSpan(
                              text: user?.name ?? 'Admin User',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.wb_sunny_rounded, color: Colors.orange, size: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // FFLIPY Action Grid Container
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))],
                    border: Border.all(color: Colors.blue.withOpacity(0.05), width: 1.5),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCircleAction(Icons.security, 'Fire Policy', () => Navigator.pushNamed(context, AppRouter.viewFirePolicy), Colors.blue),
                          _buildCircleAction(Icons.receipt_long, 'Fire Bill', () => Navigator.pushNamed(context, AppRouter.viewFireBill), Colors.green),
                          _buildCircleAction(Icons.payments, 'Money MR', () => Navigator.pushNamed(context, AppRouter.viewFireMoneyReceipt), Colors.orange),
                          _buildCircleAction(Icons.directions_boat, 'Marine Policy', () => Navigator.pushNamed(context, AppRouter.viewMarinePolicy), Colors.indigo),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCircleAction(Icons.description, 'Marine Bill', () => Navigator.pushNamed(context, AppRouter.viewMarineBill), Colors.teal),
                          _buildCircleAction(Icons.account_balance_wallet, 'Marine MR', () => Navigator.pushNamed(context, AppRouter.viewMarineMoneyReceipt), Colors.purple),
                          _buildCircleAction(Icons.assessment, 'Reports', () => Navigator.pushNamed(context, AppRouter.firePolicyReport), Colors.pink),
                          _buildCircleAction(Icons.analytics, 'Combined', () => Navigator.pushNamed(context, AppRouter.combinedReport), Colors.cyan),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              // Pending Transactions (FFLIPY Short View)
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
                height: 75,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 3,
                  itemBuilder: (context, index) => _buildPendingCardShort(),
                ),
              ),
              const SizedBox(height: 20),
              // Expandable Calculator Card
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
                          color: Colors.blue.withOpacity(0.05),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                                child: const Icon(Icons.calculate_rounded, color: Colors.blue, size: 24),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Premium Calculator', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    Text('Check rates instantly', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                  ],
                                ),
                              ),
                              Icon(_isCalculatorExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, color: Colors.blue),
                            ],
                          ),
                        ),
                      ),
                      if (_isCalculatorExpanded)
                        const Padding(padding: EdgeInsets.all(16), child: Text('Calculator UI will be here...', style: TextStyle(fontSize: 12, color: Colors.grey))),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              // Recent Activity
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Recent Activity', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              policyState.isLoading
                  ? const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: policyState.policies.take(10).length,
                      itemBuilder: (context, index) => _buildActivityTile(policyState.policies[index], index),
                    ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleAction(IconData icon, String label, VoidCallback onTap, Color color) {
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
              boxShadow: [BoxShadow(color: color.withOpacity(0.12), blurRadius: 12, offset: const Offset(0, 4))]
            ),
            child: Icon(icon, color: color, size: 24),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: Colors.black54), textAlign: TextAlign.center, maxLines: 2),
        ),
      ],
    );
  }

  Widget _buildPendingCardShort() {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12, bottom: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Fire Policy #102', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Pending', style: TextStyle(color: Colors.orange, fontSize: 9, fontWeight: FontWeight.bold)),
              Text('TK 5,000', style: TextStyle(color: Colors.blue.shade700, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTile(dynamic policy, int index) {
    final bgColor = index % 2 == 0 ? Colors.white : Colors.blue.withOpacity(0.02);
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.08)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: Container(
          width: 36, height: 36,
          decoration: BoxDecoration(color: Colors.blue.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.security, color: Colors.blue, size: 18),
        ),
        title: Text(policy.policyholder ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
        subtitle: Text(policy.bankName ?? 'N/A', style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('TK ${policy.sumInsured}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 14)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: Colors.green.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
              child: const Text('Paid', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 9)),
            ),
          ],
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
                _buildDrawerItem(Icons.home_rounded, 'Home', () => Navigator.pop(context), Colors.blue),
                _buildDrawerItem(Icons.security_rounded, 'Fire Insurance', () => Navigator.pushNamed(context, AppRouter.viewFirePolicy), Colors.orange),
                _buildDrawerItem(Icons.directions_boat_rounded, 'Marine Insurance', () => Navigator.pushNamed(context, AppRouter.viewMarinePolicy), Colors.teal),
                _buildDrawerItem(Icons.assessment_rounded, 'View Reports', () => Navigator.pushNamed(context, AppRouter.firePolicyReport), Colors.purple),
                const Divider(indent: 24, endIndent: 24),
                _buildDrawerItem(Icons.logout_rounded, 'Log Out', () {
                  ref.read(authViewModelProvider.notifier).logout().then((_) => Navigator.pushReplacementNamed(context, AppRouter.login));
                }, Colors.redAccent),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(dynamic user) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20, bottom: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFFF3BED9), Color(0xFF39D1B8)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.only(topRight: Radius.circular(32)),
      ),
      child: Column(
        children: [
          const CircleAvatar(radius: 38, backgroundColor: Colors.white, child: Icon(Icons.person, size: 38, color: Colors.blue)),
          const SizedBox(height: 12),
          Text(user?.name ?? 'Admin User', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          Text(user?.email ?? 'admin@gims.com', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.85))),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        onTap: onTap,
        dense: true,
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
