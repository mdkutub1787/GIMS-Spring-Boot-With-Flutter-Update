import 'package:flutter/material.dart';
import 'package:gims_mobile_app/core/routing/app_router.dart';

class CreateOptionsBottomSheet extends StatelessWidget {
  const CreateOptionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Create New', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Icons.security, color: Colors.orange),
            title: const Text('Fire Policy'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRouter.createFirePolicy);
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt, color: Colors.orange),
            title: const Text('Fire Bill'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRouter.createFireBill);
            },
          ),
          ListTile(
            leading: const Icon(Icons.request_quote, color: Colors.orange),
            title: const Text('Fire Money Receipt'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRouter.createFireMoneyReceipt);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.directions_boat, color: const Color(0xFF7C3AED)),
            title: const Text('Marine Policy'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRouter.createMarinePolicy);
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt, color: const Color(0xFF7C3AED)),
            title: const Text('Marine Bill'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRouter.createMarineBill);
            },
          ),
          ListTile(
            leading: const Icon(Icons.request_quote, color: const Color(0xFF7C3AED)),
            title: const Text('Marine Money Receipt'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRouter.createMarineMoneyReceipt);
            },
          ),
        ],
        ),
      ),
    );
  }
}

void showCreateOptionsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => const CreateOptionsBottomSheet(),
  );
}
