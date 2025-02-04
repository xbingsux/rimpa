import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavBarScaffold extends StatelessWidget {
  final Widget child;
  const NavBarScaffold({Key? key, required this.child}) : super(key: key);

  static final List<_NavBarItem> _navItems = [
    _NavBarItem(label: 'หน้าแรก', icon: Icons.home, route: '/home'),
    _NavBarItem(label: 'โปรด', icon: Icons.favorite, route: '/favorites'),
    _NavBarItem(label: 'ตั้งค่า', icon: Icons.settings, route: '/settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    final int selectedIndex = _navItems.indexWhere((item) => item.route == location);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex == -1 ? 0 : selectedIndex,
        items: _navItems.map((item) => BottomNavigationBarItem(icon: Icon(item.icon), label: item.label)).toList(),
        onTap: (index) {
          final route = _navItems[index].route;
          if (route != location) {
            context.go(route);
          }
        },
      ),
    );
  }
}

class _NavBarItem {
  final String label;
  final IconData icon;
  final String route;

  _NavBarItem({required this.label, required this.icon, required this.route});
}
