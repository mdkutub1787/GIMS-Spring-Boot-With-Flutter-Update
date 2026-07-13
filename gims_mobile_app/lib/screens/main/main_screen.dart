import 'package:flutter/material.dart';
import 'package:gims_mobile_app/screens/home/home_screen.dart';
import 'package:gims_mobile_app/screens/fire_policy/view_fire_policy_screen.dart';
import 'package:gims_mobile_app/screens/marine_policy/view_marine_policy_screen.dart';
import 'package:gims_mobile_app/screens/profile/profile_screen.dart';
import 'package:gims_mobile_app/screens/main/widgets/app_bottom_nav_bar.dart';
import 'package:gims_mobile_app/screens/main/widgets/create_options_bottom_sheet.dart';
import 'package:gims_mobile_app/core/theme/app_theme.dart';
import 'package:gims_mobile_app/core/routing/app_router.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const ViewFirePolicyScreen(),
    const ViewMarinePolicyScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: _pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCreateOptionsBottomSheet(context);
        },
        backgroundColor: theme.colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
