import 'package:caodaion/pages/apps/apps_page.dart';
import 'package:caodaion/pages/calendar/calendar_page.dart';
import 'package:caodaion/pages/home/home_page.dart';
import 'package:caodaion/pages/kinh/kinh_page.dart';
import 'package:caodaion/pages/profile/profile_page.dart';
import 'package:caodaion/pages/qr/qr_page.dart';
import 'package:caodaion/pages/settings/settings_page.dart';
import 'package:caodaion/pages/tnht/tnht_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NoTransitionPage<T> extends CustomTransitionPage<T> {
  NoTransitionPage({
    required Widget child,
    LocalKey? key,
    String? name,
    Object? arguments,
    String? restorationId,
  }) : super(
    key: key,
    name: name,
    arguments: arguments,
    restorationId: restorationId,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => NoTransitionPage(child: const HomePage(), name: '/'),
    ),
    GoRoute(
      path: '/kinh',
      pageBuilder: (context, state) => NoTransitionPage(child: const KinhPage(), name: '/kinh'),
    ),
    GoRoute(
      path: '/tnht',
      pageBuilder: (context, state) => NoTransitionPage(child: const TNHTPage(), name: '/tnht'),
    ),
    GoRoute(
      path: '/lich',
      pageBuilder: (context, state) => NoTransitionPage(child: const CalendarPage(), name: '/lich'),
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) => NoTransitionPage(child: const SettingsPage(), name: '/settings'),
    ),
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) => NoTransitionPage(child: const ProfilePage(), name: '/profile'),
    ),
    GoRoute(
      path: '/apps',
      pageBuilder: (context, state) => NoTransitionPage(child: const AppsPage(), name: '/apps'),
    ),
    GoRoute(
      path: '/qr',
      pageBuilder: (context, state) => NoTransitionPage(child: const QRPage(), name: '/qr'),
    ),
  ],
);
