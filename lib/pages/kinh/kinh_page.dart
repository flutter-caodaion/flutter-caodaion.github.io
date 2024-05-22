// kinh_page.dart
import 'package:caodaion/widgets/responsive_scaffold.dart';
import 'package:flutter/material.dart';

class KinhPage extends StatelessWidget {
  const KinhPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
        appBar: AppBar(title: const Text('Kinh')),
        body: const Center(child: Text('Kinh Page')),
      ),
    );
  }
}