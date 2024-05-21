// clock_page.dart
import 'package:caodaion/widgets/responsive_scaffold.dart';
import 'package:flutter/material.dart';

class ClockPage extends StatelessWidget {
  const ClockPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
        appBar: AppBar(title: const Text('Clock')),
        body: const Center(child: Text('Clock Page')),
      ),
    );
  }
}