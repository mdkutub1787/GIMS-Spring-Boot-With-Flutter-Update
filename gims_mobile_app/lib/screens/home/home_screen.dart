import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/routing/app_router.dart';
import '../../core/widgets/brand_app_bar.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/fire_policy_viewmodel.dart';
import '../../models/fire/fire_policy.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(firePolicyViewModelProvider.notifier).fetchPolicies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final policyState = ref.watch(firePolicyViewModelProvider);
    final user = ref.watch(authViewModelProvider).user;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: BrandAppBar(
        height: 80,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.black87),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.shield_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              'GIMS',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
                onPressed: () {},
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFF9FAFB), width: 1.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _buildDrawer(context),
      body: RefreshIndicator(
        onRefresh: () => ref.read(firePolicyViewModelProvider.notifier).fetchPolicies(),
        color: theme.colorScheme.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Text
              Text(
                'Good Morning,',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
              ),
              Text(
                user?.name ?? 'Admin User',
                style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black87),
              ),
              const SizedBox(height: 20),

              // Main Purple Card (Like Aczone Balance Card)
              _buildMainCard(policyState),
              const SizedBox(height: 30),

              // Fire Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 70, child: _buildActionIcon(Icons.security, 'Fire Policy', const Color(0xFF20B2AA), () => Navigator.pushNamed(context, AppRouter.viewFirePolicy))),
                  SizedBox(width: 70, child: _buildActionIcon(Icons.receipt, 'Fire Bill', const Color(0xFF28B9A9), () => Navigator.pushNamed(context, AppRouter.viewFireBill))),
                  SizedBox(width: 70, child: _buildActionIcon(Icons.request_quote, 'Fire MR', const Color(0xFF1CB1A1), () => Navigator.pushNamed(context, AppRouter.viewFireMoneyReceipt))),
                ],
              ),
              const SizedBox(height: 24),

              // Marine Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 70, child: _buildActionIcon(Icons.directions_boat, 'Marine', const Color(0xFF20B2AA), () => Navigator.pushNamed(context, AppRouter.viewMarinePolicy))),
                  SizedBox(width: 70, child: _buildActionIcon(Icons.receipt_long, 'Marine Bill', const Color(0xFF28B9A9), () => Navigator.pushNamed(context, AppRouter.viewMarineBill))),
                  SizedBox(width: 70, child: _buildActionIcon(Icons.monetization_on, 'Marine MR', const Color(0xFF1CB1A1), () => Navigator.pushNamed(context, AppRouter.viewMarineMoneyReceipt))),
                ],
              ),
              const SizedBox(height: 24),

              // Reports Section
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 70, child: _buildActionIcon(Icons.assessment, 'Reports', const Color(0xFF0F9485), () => Navigator.pushNamed(context, AppRouter.combinedReport))),
                ],
              ),
              const SizedBox(height: 35),

              // Recent Activity Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Projects / Activity',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRouter.viewFirePolicy),
                    child: Text(
                      'View All',
                      style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: theme.colorScheme.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Recent Activity List
              policyState.isLoading
                  ? const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
                  : policyState.policies.isEmpty
                      ? Center(child: Text('No activity found', style: GoogleFonts.poppins(color: Colors.grey)))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: policyState.policies.take(5).length,
                          itemBuilder: (context, index) => _buildActivityTile(policyState.policies[index]),
                        ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainCard(FirePolicyState policyState) {
    double totalSum = 0;
    for (var p in policyState.policies) {
      totalSum += (p.sumInsured ?? 0);
    }

    return Container(
      width: double.infinity,
      height: 190,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF28B9A9), Color(0xFF1CB1A1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF28B9A9).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background decorative circles
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            right: 40,
            bottom: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          
          // Card Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Protection',
                      style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.8), fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const Icon(Icons.shield_outlined, color: Colors.white, size: 24),
                  ],
                ),
                Text(
                  'TK ${NumberFormat('#,##,###').format(totalSum)}',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${policyState.policies.length} Active Policies',
                      style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.8), fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.orange.withOpacity(0.8),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(-10, 0),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTile(FirePolicy policy) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.pushNamed(context, AppRouter.viewFirePolicy),
            splashColor: const Color(0xFF7C3AED).withOpacity(0.05),
            highlightColor: const Color(0xFF7C3AED).withOpacity(0.02),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(left: BorderSide(color: Color(0xFF7C3AED), width: 4)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C3AED).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.security_rounded, color: Color(0xFF7C3AED), size: 22),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          policy.policyholder ?? 'Unknown',
                          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          policy.date != null ? DateFormat('MMM dd, yyyy').format(policy.date!) : 'Recently added',
                          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'TK ${NumberFormat('#,##,###').format(policy.sumInsured ?? 0)}',
                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF7C3AED)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Processed',
                        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF10B981)),
                      ),
                    ],
                  ),
                ],
              ),
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
                _buildDrawerItem(Icons.home_rounded, 'Home', () => Navigator.pop(context), const Color(0xFF7C3AED)),
                _buildDrawerItem(Icons.security_rounded, 'Fire Insurance', () => Navigator.pushNamed(context, AppRouter.viewFirePolicy), Colors.orange),
                _buildDrawerItem(Icons.directions_boat_rounded, 'Marine Insurance', () => Navigator.pushNamed(context, AppRouter.viewMarinePolicy), Colors.teal),
                _buildDrawerItem(Icons.assessment_rounded, 'View Reports', () => Navigator.pushNamed(context, AppRouter.combinedReport), const Color(0xFF3B82F6)),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8), child: Divider(thickness: 1, height: 1)),
                _buildDrawerSectionTitle('App Settings'),
                _buildDrawerItem(Icons.person_outline_rounded, 'My Profile', () => Navigator.pushNamed(context, AppRouter.profile), const Color(0xFF64748B)),
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
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text('Version 1.0.2', style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
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
        style: GoogleFonts.poppins(
          color: const Color(0xFF7C3AED).withOpacity(0.7),
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
          ),
          borderRadius: BorderRadius.only(topRight: Radius.circular(32)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.2), width: 3)),
              child: const CircleAvatar(radius: 38, backgroundColor: Colors.white, child: Icon(Icons.person, size: 38, color: Color(0xFF7C3AED))),
            ),
            const SizedBox(height: 12),
            Text(user?.name ?? 'Admin User', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
            Text(user?.email ?? 'admin@gims.com', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white.withOpacity(0.85), fontWeight: FontWeight.w500)),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Data Completion', style: GoogleFonts.poppins(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      Text('85%', style: GoogleFonts.poppins(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
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
        title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
      ),
    );
  }
}
