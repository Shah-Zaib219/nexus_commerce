import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/dashboard_cubit/dashboard_cubit.dart';
import 'home_screen.dart';

import 'cart_screen.dart';
import 'settings_screen.dart';
import '../widgets/custom_app_bar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // List of tabs
    final List<Widget> pages = [
      const HomeScreen(),
      const CartScreen(), // Index 1 (FAB target)
      const SettingsScreen(), // Index 2
    ];

    return BlocProvider(
      create: (context) => DashboardCubit(),
      child: BlocBuilder<DashboardCubit, int>(
        builder: (context, currentIndex) {
          return Scaffold(
            appBar: const CustomAppBar(),
            // We use IndexedStack to preserve state of pages (e.g. scroll position on Home)
            body: IndexedStack(index: currentIndex, children: pages),

            // Floating Cart Button
            floatingActionButton: FloatingActionButton(
              onPressed: () => context.read<DashboardCubit>().updateIndex(
                1,
              ), // Index 1 is Cart now
              backgroundColor: colorScheme.primary,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,

            // Bottom Navigation Bar
            bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 8.0,
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                height:
                    kBottomNavigationBarHeight +
                    12, // Slightly taller for safety
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavBaseItem(
                      context,
                      icon: Icons.home_outlined,
                      activeIcon: Icons.home,
                      label: "Home",
                      index: 0,
                      currentIndex: currentIndex,
                    ),
                    const SizedBox(width: 48), // Spacer for FAB
                    _buildNavBaseItem(
                      context,
                      icon: Icons.settings_outlined,
                      activeIcon: Icons.settings,
                      label: "Setting",
                      index: 2,
                      currentIndex: currentIndex,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavBaseItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required int currentIndex,
  }) {
    final isSelected = currentIndex == index;
    final color = isSelected
        ? Theme.of(context).colorScheme.primary
        : (Theme.of(context).brightness == Brightness.dark
              ? Colors.white70
              : Colors.black87);

    return InkWell(
      onTap: () => context.read<DashboardCubit>().updateIndex(index),
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isSelected ? activeIcon : icon, color: color, size: 24),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
