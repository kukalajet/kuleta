import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kuleta/features/app/view/nav_handler.dart';
import 'package:kuleta/features/invoice/view/invoice_page.dart';

class AppTabsPage extends StatefulWidget {
  const AppTabsPage({super.key});

  @override
  State<AppTabsPage> createState() => _AppTabsPageState();
}

class _AppTabsPageState extends State<AppTabsPage> {
  Widget _getBody(int index) {
    if (index == 0) return const InvoicePage();
    if (index == 1) return const Center(child: Text('Overview'));
    if (index == 2) return const Center(child: Text('Settings'));
    return const Scaffold(
      body: Center(child: Text('Listing')),
    );
  }

  // void _tap(NavHandler navHandler, int index) {
  //   navHandler.currentTabIndex = index;
  // }

  @override
  Widget build(BuildContext context) {
    final navHandler = context.watch<NavHandler>();
    final currentIndex = navHandler.currentTabIndex;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: _getBody(currentIndex),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colorScheme.primary,
        label: Text(
          'Shto faturë',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onPrimary,
          ),
        ),
        icon: Icon(Icons.add, color: colorScheme.onPrimary),
        onPressed: () => context.go('/scanner'),
        elevation: 0,
        focusColor: theme.colorScheme.secondary,
        autofocus: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   unselectedItemColor: Colors.grey,
      //   selectedItemColor: Colors.blue,
      //   showSelectedLabels: false,
      //   showUnselectedLabels: false,
      //   currentIndex: currentIndex,
      //   onTap: (index) => _tap(navHandler, index),
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.inventory),
      //       label: 'Listings',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.abc_outlined),
      //       label: 'Overview',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.accessible_forward_rounded),
      //       label: 'Settings',
      //     ),
      //   ],
      // ),
    );
  }
}
