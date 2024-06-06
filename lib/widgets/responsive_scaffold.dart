import 'dart:convert';

import 'package:caodaion/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResponsiveScaffold extends StatefulWidget {
  final Widget child;

  const ResponsiveScaffold({required this.child, super.key});

  @override
  State<ResponsiveScaffold> createState() => _ResponsiveScaffoldState();
}

class _ResponsiveScaffoldState extends State<ResponsiveScaffold> {
  @override
  void initState() {
    getAlarms();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ResponsiveScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    getAlarms();
  }

  getAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final storage = prefs.getString('alarms');
    final List<dynamic> storageAlarms = jsonDecode(storage ?? '[]');
    if (storageAlarms.isNotEmpty) {
      final foundActiveAlarm = storageAlarms.firstWhere((item) {
        final now = DateTime.now();
        final itemDate = DateTime.fromMicrosecondsSinceEpoch(item['dateTime']);
        return now.year == itemDate.year &&
            now.month == itemDate.month &&
            now.day == itemDate.day &&
            now.hour == itemDate.hour &&
            now.minute >= itemDate.minute;
      }, orElse: () => -1);
      if (foundActiveAlarm != -1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            GoRouter.of(context).go('/dong-ho/${foundActiveAlarm['id']}');
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          return SafeArea(
            child: Scaffold(
              body: Row(
                children: [
                  NavigationRail(
                    selectedIndex: _selectedIndex(context),
                    backgroundColor: ColorConstants.primaryBackground,
                    indicatorColor: ColorConstants.primaryIndicatorBackground,
                    onDestinationSelected: (index) =>
                        _onItemTapped(context, index),
                    labelType: NavigationRailLabelType.all,
                    destinations: <NavigationRailDestination>[
                      NavigationRailDestination(
                        icon: Tooltip(
                          message: "Trang chủ",
                          child: SvgPicture.asset(
                            'assets/icons/caodaion-logo.svg',
                            height: 32,
                            width: 32,
                          ),
                        ),
                        label: const Text('CaoDaiON'),
                        padding: const EdgeInsets.only(top: 4, bottom: 4),
                      ),
                      NavigationRailDestination(
                        icon: Tooltip(
                          message: "Kinh Cúng Tứ Thời & Quan Hôn Tang Tế",
                          child: SvgPicture.asset(
                            'assets/icons/book.svg',
                          ),
                        ),
                        label: const Text('Kinh'),
                        padding: const EdgeInsets.only(top: 4, bottom: 4),
                      ),
                      NavigationRailDestination(
                        icon: Tooltip(
                          message: "Thánh Ngôn Hiệp Tuyển",
                          child: SvgPicture.asset(
                            'assets/icons/close_book.svg',
                          ),
                        ),
                        label: const Text('TNHT'),
                        padding: const EdgeInsets.only(top: 4, bottom: 4),
                      ),
                      NavigationRailDestination(
                        icon: Tooltip(
                          message: "Lịch âm dương",
                          child: SvgPicture.asset(
                            'assets/icons/calendar.svg',
                          ),
                        ),
                        label: const Text('Lịch'),
                        padding: const EdgeInsets.only(top: 4, bottom: 4),
                      ),
                      NavigationRailDestination(
                        icon: Tooltip(
                          message: "Các ứng dụng",
                          child: SvgPicture.asset(
                            'assets/icons/apps.svg',
                          ),
                        ),
                        label: const Text('Ứng dụng'),
                        padding: const EdgeInsets.only(top: 4, bottom: 4),
                      ),
                    ],
                  ),
                  Expanded(child: widget.child),
                ],
              ),
            ),
          );
        } else {
          return SafeArea(
            child: Scaffold(
              body: widget.child,
              bottomNavigationBar: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: ColorConstants.primaryBackground,
                ),
                child: BottomNavigationBar(
                  currentIndex: _selectedIndex(context),
                  onTap: (index) => _onItemTapped(context, index),
                  selectedItemColor: ColorConstants.primaryColor,
                  backgroundColor: ColorConstants.primaryBackground,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Tooltip(
                        message: "Kinh Cúng Tứ Thời & Quan Hôn Tang Tế",
                        child: SvgPicture.asset(
                          'assets/icons/book.svg',
                          color: _selectedIndex(context) == 0
                              ? ColorConstants.primaryColor
                              : Colors.black,
                        ),
                      ),
                      label: 'Kinh',
                    ),
                    BottomNavigationBarItem(
                      icon: Tooltip(
                        message: "Thánh Ngôn Hiệp Tuyển",
                        child: SvgPicture.asset(
                          'assets/icons/close_book.svg',
                          color: _selectedIndex(context) == 1
                              ? ColorConstants.primaryColor
                              : Colors.black,
                        ),
                      ),
                      label: 'TNHT',
                    ),
                    BottomNavigationBarItem(
                      icon: Tooltip(
                        message: "Trang chủ CaoDaiON",
                        child: SvgPicture.asset(
                          'assets/icons/caodaion-logo.svg',
                          height: 32,
                          width: 32,
                        ),
                      ),
                      label: 'CaoDaiON',
                    ),
                    BottomNavigationBarItem(
                      icon: Tooltip(
                        message: "Lịch âm dương",
                        child: SvgPicture.asset(
                          'assets/icons/calendar.svg',
                          color: _selectedIndex(context) == 3
                              ? ColorConstants.primaryColor
                              : Colors.black,
                        ),
                      ),
                      label: 'Lịch',
                    ),
                    BottomNavigationBarItem(
                      icon: Tooltip(
                        message: "Các ứng dụng",
                        child: SvgPicture.asset(
                          'assets/icons/apps.svg',
                          color: _selectedIndex(context) == 4
                              ? ColorConstants.primaryColor
                              : Colors.black,
                        ),
                      ),
                      label: 'Ứng dụng',
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  int _selectedIndex(BuildContext context) {
    final location = ModalRoute.of(context)?.settings.name;
    if (ResponsiveBreakpoints.of(context).isDesktop) {
      if (location == '/') {
        return 0;
      } else if (location == '/kinh') {
        return 1;
      } else if (location == '/tnht') {
        return 2;
      } else if (location == '/lich') {
        return 3;
      }
      return 4;
    }
    if (!ResponsiveBreakpoints.of(context).isDesktop) {
      if (location == '/') {
        return 2;
      } else if (location == '/kinh') {
        return 0;
      } else if (location == '/tnht') {
        return 1;
      } else if (location == '/lich') {
        return 3;
      }
      return 4;
    }
    return 4;
  }

  void _onItemTapped(BuildContext context, int index) {
    if (ResponsiveBreakpoints.of(context).isDesktop) {
      switch (index) {
        case 0:
          context.go('/');
          break;
        case 1:
          context.go('/kinh');
          break;
        case 2:
          context.go('/tnht');
          break;
        case 3:
          context.go('/lich');
          break;
        case 4:
          context.go('/apps');
          break;
      }
    }
    if (!ResponsiveBreakpoints.of(context).isDesktop) {
      switch (index) {
        case 0:
          context.go('/kinh');
          break;
        case 1:
          context.go('/tnht');
          break;
        case 2:
          context.go('/');
          break;
        case 3:
          context.go('/lich');
          break;
        case 4:
          context.go('/apps');
          break;
      }
    }
  }
}
