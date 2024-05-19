import 'package:flutter/material.dart';
import '../main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

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