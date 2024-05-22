// tnht_page.dart
import 'package:caodaion/widgets/responsive_scaffold.dart';
import 'package:flutter/material.dart';

class TNHTPage extends StatelessWidget {
  const TNHTPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
        appBar: AppBar(title: const Text('TNHT')),
        body: const Center(child: Text('TNHT Page')),
      ),
    );
  }
}