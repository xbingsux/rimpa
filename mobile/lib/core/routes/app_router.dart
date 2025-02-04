import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rimpa/screen/events/screen/screen_events.dart';
import 'package:rimpa/screen/home/screen/screen_home.dart';
import 'package:rimpa/screen/profile/screen/screen_profile.dart';
import 'package:rimpa/widgets/navbar.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return NavBarScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ScreenHome(),
            ),
          ),
          GoRoute(
            path: '/favorites',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ScreenEvents(),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ScreenProfile(),
            ),
          ),
        ],
      ),
    ],
  );
}
