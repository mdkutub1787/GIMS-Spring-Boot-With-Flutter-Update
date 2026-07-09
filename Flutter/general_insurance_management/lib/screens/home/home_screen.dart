import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/routing/app_router.dart';
import '../../viewmodels/auth_viewmodel.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _carouselIndex = 0;
  late PageController _pageController;
  Timer? _timer;

  static const List<String> _images = [
    'https://www.shutterstock.com/image-photo/family-house-car-protected-by-260nw-1502368643.jpg',
    'https://www.shutterstock.com/image-photo/insurer-protecting-family-house-car-260nw-1295560780.jpg',
    'https://png.pngtree.com/template/20220516/ourmid/pngtree-insurance-policy-banner-template-flat-design-illustration-editable-of-square-background-image_1571396.jpg',
  ];

  final List<Map<String, dynamic>> menuItems = [
    {"icon": Icons.security, "title": "Fire Policy", "route": AppRouter.viewFirePolicy, "color": Colors.blue},
    {"icon": Icons.receipt_long, "title": "Fire Bill", "route": AppRouter.viewFireBill, "color": Colors.green},
    {"icon": Icons.payments, "title": "Fire Receipt", "route": AppRouter.viewFireMoneyReceipt, "color": Colors.orange},
    {"icon": Icons.directions_boat, "title": "Marine Policy", "route": AppRouter.viewMarinePolicy, "color": Colors.indigo},
    {"icon": Icons.description, "title": "Marine Bill", "route": AppRouter.viewMarineBill, "color": Colors.teal},
    {"icon": Icons.account_balance_wallet, "title": "Marine Receipt", "route": AppRouter.viewMarineMoneyReceipt, "color": Colors.purple},
    {"icon": Icons.assessment, "title": "Fire Reports", "route": AppRouter.firePolicyReport, "color": Colors.pink},
    {"icon": Icons.analytics, "title": "Combined", "route": AppRouter.combinedReport, "color": Colors.cyan},
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() => _carouselIndex = (_carouselIndex + 1) % _images.length);
        _pageController.animateToPage(_carouselIndex, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Icon(Icons.security, size: 30, color: Colors.blue),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () => ref.read(authViewModelProvider.notifier).logout().then((_) => Navigator.pushReplacementNamed(context, AppRouter.login)), 
          icon: const Icon(Icons.logout_rounded, color: Colors.redAccent)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Good Morning,', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
                  Text('Admin Dashboard', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            _buildCarousel(),
            _buildMenuGrid(theme),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    return Container(
      height: 160,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: PageView.builder(
          controller: _pageController,
          itemCount: _images.length,
          itemBuilder: (context, index) => Image.network(_images[index], fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildMenuGrid(ThemeData theme) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 20, crossAxisSpacing: 10, childAspectRatio: 0.8),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return Column(
          children: [
            InkWell(
              onTap: () => Navigator.pushNamed(context, item['route']),
              child: Container(
                width: 55, height: 55,
                decoration: BoxDecoration(color: (item['color'] as Color).withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(item['icon'], color: item['color'], size: 26),
              ),
            ),
            const SizedBox(height: 8),
            Text(item['title'], style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600), textAlign: TextAlign.center, maxLines: 2),
          ],
        );
      },
    );
  }
}
