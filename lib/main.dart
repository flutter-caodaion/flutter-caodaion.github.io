import 'package:caodaion/constants/constants.dart';
import 'package:flutter/material.dart';
import 'router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        scaffoldBackgroundColor: ColorConstants.secondaryBackdround,
        appBarTheme: AppBarTheme(backgroundColor: ColorConstants.secondaryBackdround),
      ),
    );
  }
}