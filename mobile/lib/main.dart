import 'package:flutter/material.dart';
import 'package:rimpa/core/routes/app_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      title: 'GoRouter with BottomNavigationBar',
    );
  }
}
