import 'package:caodaion/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class ResponsiveScaffold extends StatelessWidget {
  final Widget child;

  const ResponsiveScaffold({required this.child, super.key});

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
                    leading: const SizedBox(
                      height: 12,
                    ),
                    selectedIndex: _selectedIndex(context),
                    backgroundColor: ColorConstants.primaryBackground,
                    indicatorColor: ColorConstants.primaryIndicatorBackground,
                    onDestinationSelected: (index) =>
                        _onItemTapped(context, index),
                    labelType: NavigationRailLabelType.all,
                    destinations: <NavigationRailDestination>[
                      NavigationRailDestination(
                        icon: SvgPicture.asset(
                          'assets/icons/home.svg',
                        ),
                        label: const Text('Trang chủ'),
                        padding: const EdgeInsets.only(top: 4, bottom: 4),
                      ),
                      NavigationRailDestination(
                        icon: SvgPicture.asset(
                          'assets/icons/book.svg',
                        ),
                        label: const Text('Kinh'),
                        padding: const EdgeInsets.only(top: 4, bottom: 4),
                      ),
                      NavigationRailDestination(
                        icon: SvgPicture.asset(
                          'assets/icons/close_book.svg',
                        ),
                        label: const Text('TNHT'),
                        padding: const EdgeInsets.only(top: 4, bottom: 4),
                      ),
                      NavigationRailDestination(
                        icon: SvgPicture.asset(
                          'assets/icons/calendar.svg',
                        ),
                        label: const Text('Lịch'),
                        padding: const EdgeInsets.only(top: 4, bottom: 4),
                      ),
                      NavigationRailDestination(
                        icon: SvgPicture.asset(
                          'assets/icons/apps.svg',
                        ),
                        label: const Text('Ứng dụng'),
                        padding: const EdgeInsets.only(top: 4, bottom: 4),
                      ),
                    ],
                  ),
                  Expanded(child: child),
                ],
              ),
            ),
          );
        } else {
          return SafeArea(
            child: Scaffold(
              body: child,
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
                      icon: SvgPicture.asset(
                        'assets/icons/home.svg',
                        color: _selectedIndex(context) == 0
                            ? ColorConstants.primaryColor
                            : Colors.black,
                      ),
                      label: 'Trang chủ',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        'assets/icons/book.svg',
                        color: _selectedIndex(context) == 1
                            ? ColorConstants.primaryColor
                            : Colors.black,
                      ),
                      label: 'Kinh',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        'assets/icons/close_book.svg',
                        color: _selectedIndex(context) == 2
                            ? ColorConstants.primaryColor
                            : Colors.black,
                      ),
                      label: 'TNHT',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        'assets/icons/calendar.svg',
                        color: _selectedIndex(context) == 3
                            ? ColorConstants.primaryColor
                            : Colors.black,
                      ),
                      label: 'Lịch',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        'assets/icons/apps.svg',
                        color: _selectedIndex(context) == 4
                            ? ColorConstants.primaryColor
                            : Colors.black,
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

  void _onItemTapped(BuildContext context, int index) {
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
}
