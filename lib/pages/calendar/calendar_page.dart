import 'package:caodaion/widgets/responsive_scaffold.dart';
import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
        appBar: AppBar(title: const Text('Calendar')),
        body: const Center(child: Text('Calendar Page')),
      ),
    );
  }
}
