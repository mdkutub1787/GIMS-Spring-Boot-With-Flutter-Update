import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/routing/app_router.dart';
import '../../viewmodels/auth_viewmodel.dart';

class LocalOfficeScreen extends ConsumerWidget {
  const LocalOfficeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    final List<Map<String, dynamic>> menuItems = [
      {"icon": Icons.security, "title": "Fire Policy", "route": AppRouter.viewFirePolicy, "color": Colors.blue},
      {"icon": Icons.receipt_long, "title": "Fire Bill", "route": AppRouter.viewFireBill, "color": Colors.green},
      {"icon": Icons.directions_boat, "title": "Marine Policy", "route": AppRouter.viewMarinePolicy, "color": Colors.indigo},
      {"icon": Icons.description, "title": "Marine Bill", "route": AppRouter.viewMarineBill, "color": Colors.teal},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Local Office', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => ref.read(authViewModelProvider.notifier).logout().then((_) => Navigator.pushReplacementNamed(context, AppRouter.login)), 
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome Back,', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
            Text('Agent Dashboard', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 20, childAspectRatio: 1.1),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return InkWell(
                  onTap: () => Navigator.pushNamed(context, item['route']),
                  child: Container(
                    decoration: BoxDecoration(
                      color: (item['color'] as Color).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: (item['color'] as Color).withOpacity(0.1)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item['icon'], color: item['color'], size: 40),
                        const SizedBox(height: 12),
                        Text(item['title'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
