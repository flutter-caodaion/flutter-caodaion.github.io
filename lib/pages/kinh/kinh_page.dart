// kinh_page.dart
import 'package:caodaion/components/responsive_scaffold.dart';
import 'package:flutter/material.dart';

class KinhPage extends StatelessWidget {
  const KinhPage({Key? key}) : super(key: key);

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