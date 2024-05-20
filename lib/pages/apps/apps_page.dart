import 'package:caodaion/components/responsive_scaffold.dart';
import 'package:flutter/material.dart';

class AppsPage extends StatelessWidget {
  const AppsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
        appBar: AppBar(title: const Text('Apps')),
        body: const Center(child: Text('Apps Page')),
      ),
    );
  }
}
