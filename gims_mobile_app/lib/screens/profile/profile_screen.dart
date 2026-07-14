import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/routing/app_router.dart';
import '../../core/widgets/brand_app_bar.dart';
import '../../viewmodels/auth_viewmodel.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authViewModelProvider).user;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: BrandAppBar(
        height: 60,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.shield_rounded, color: Colors.white, size: 14),
            ),
            const SizedBox(width: 8),
            Text('GIMS', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)),
          ],
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, color: Colors.black87),
                onPressed: () {},
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(
                    color: Colors.redAccent, shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFF9FAFB), width: 1.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Purple Header & Info Card Stack
            SizedBox(
              height: 280,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Purple Background Header
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFF7C3AED),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.white24,
                          child: const Icon(Icons.person, size: 40, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.username ?? 'Guest User',
                                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                              Text(
                                user?.email ?? 'No Email Provided',
                                style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.verified, color: Colors.white, size: 14),
                                    const SizedBox(width: 4),
                                    Text((user?.role?.toString().split('.').last ?? 'USER').toUpperCase(), style: GoogleFonts.poppins(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Overlapping User Info Card
                  Positioned(
                    top: 130,
                    left: 24,
                    right: 24,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              _buildInfoItem(Icons.phone, 'Phone', user?.cell ?? 'Not provided', const Color(0xFF10B981)),
                              const SizedBox(width: 16),
                              _buildInfoItem(Icons.location_on, 'Address', user?.address ?? 'Not provided', const Color(0xFFF59E0B)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _buildInfoItem(Icons.business, 'Company', user?.companyName ?? 'N/A', const Color(0xFF3B82F6)),
                              const SizedBox(width: 16),
                              _buildInfoItem(Icons.work, 'Office', user?.officeName ?? 'N/A', const Color(0xFF7C3AED)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 10),

            // Settings List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildListTile(Icons.person_outline, 'Account Settings', () {
                    Navigator.pushNamed(context, AppRouter.editProfile);
                  }),
                  _buildListTile(Icons.notifications_none, 'Notifications', () {}),
                  _buildListTile(Icons.people_outline, 'Team Management', () {}),
                  _buildListTile(Icons.extension_outlined, 'Integrations', () {}),
                  _buildListTile(Icons.settings_outlined, 'App Settings', () {
                    Navigator.pushNamed(context, AppRouter.settings);
                  }),
                  _buildListTile(Icons.help_outline, 'Help & Support', () {}),
                  _buildListTile(Icons.logout, 'Log Out', () {
                    ref.read(authViewModelProvider.notifier).logout().then((_) {
                      Navigator.pushReplacementNamed(context, AppRouter.login);
                    });
                  }, isDestructive: true),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value, Color color) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                const SizedBox(height: 2),
                Text(value, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87), maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    final color = isDestructive ? Colors.redAccent : Colors.black87;
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: color, size: 24),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          trailing: isDestructive ? null : const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          onTap: onTap,
        ),
        if (!isDestructive)
          Divider(color: Colors.grey[200], height: 1, thickness: 1),
      ],
    );
  }
}
