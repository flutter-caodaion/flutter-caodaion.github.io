import 'dart:convert';

import 'package:caodaion/constants/constants.dart';
import 'package:caodaion/pages/clock/screens/focus_mode.dart';
import 'package:caodaion/pages/clock/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClockPage extends StatefulWidget {
  const ClockPage({super.key});

  @override
  State<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController = TabController(length: 2, vsync: this);

  @override
  void initState() {
    super.initState();
    // Initialize the TabController with the number of tabs
    _tabController = TabController(length: 2, vsync: this);
    loadNextFocus();
  }

  loadNextFocus() async {
    final prefs = await SharedPreferences.getInstance();
    var sharedFocusNext = jsonDecode(prefs.getString('focusNext') ?? "null");

    if (sharedFocusNext != null) {
      _tabController.animateTo(1);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.go('/apps');
          },
        ),
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/clock.svg',
              color: ColorConstants.clockColor,
            ),
            const SizedBox(
              width: 8,
            ),
            const Text("Đồng hồ"),
          ],
        ),
        bottom: TabBar(
          controller: _tabController, // Use the TabController here
          tabs: const [
            Tab(
              text: 'Hẹn giờ',
            ),
            Tab(
              text: 'Chế độ tập trung',
            ),
          ],
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return ColorConstants.primaryBackground;
              }
              return null;
            },
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController, // Use the TabController here
        children: const [
          AlarmHome(),
          FocusMode(),
        ],
      ),
    );
  }
}
