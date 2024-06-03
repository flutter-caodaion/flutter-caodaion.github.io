import 'dart:async';
import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:caodaion/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Alarm.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late List<AlarmSettings> alarms;
  static StreamSubscription<AlarmSettings>? subscription;

  void loadAlarms(int? id) {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      if (id != 0 && alarms.isNotEmpty) {
        final foundActiveAlarm = alarms.firstWhere((item) => item.id == id);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            GoRouter.of(context).go('/dong-ho/${foundActiveAlarm.id}');
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadAlarms(0);
    loadAlarms(0);
    subscription ??= Alarm.ringStream.stream.listen((alarmSettings) {
      GoRouter.of(context).go('/dong-ho/${alarmSettings.id}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: ColorConstants.primaryColor,
        scaffoldBackgroundColor: ColorConstants.whiteBackdround,
        appBarTheme:
            AppBarTheme(backgroundColor: ColorConstants.primaryBackground),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.black,
          indicatorColor: ColorConstants.primaryColor,
        ),
      ),
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
    );
  }
}
