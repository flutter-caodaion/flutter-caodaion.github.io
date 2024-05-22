import 'package:caodaion/widgets/responsive_scaffold.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: const Center(child: Text('Settings Page')),
      ),
    );
  }
}