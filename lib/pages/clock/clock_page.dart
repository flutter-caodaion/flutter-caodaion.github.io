import 'dart:convert';

import 'package:caodaion/constants/constants.dart';
import 'package:caodaion/pages/clock/screens/focus_mode.dart';
import 'package:caodaion/pages/clock/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClockPage extends StatefulWidget {
  const ClockPage({super.key});

  @override
  State<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  @override
  void initState() {
    super.initState();
    loadNextFocus();
  }

  loadNextFocus() async {
    final prefs = await SharedPreferences.getInstance();
    var sharedFocusNext = jsonDecode(prefs.getString('focusNext') ?? "null");

    if (sharedFocusNext != null) {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              context.go('/');
            },
          ),
          bottom: TabBar(
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
        body: const TabBarView(
          children: [
            ExampleAlarmHomeScreen(),
            FocusMode(),
          ],
        ),
      ),
    );
  }
}
