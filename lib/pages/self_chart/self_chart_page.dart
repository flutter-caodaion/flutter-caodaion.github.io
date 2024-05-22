// self_chart_page.dart
import 'package:caodaion/pages/self_chart/self_chart_page%20copy.dart';
import 'package:caodaion/widgets/responsive_scaffold.dart';
import 'package:flutter/material.dart';

class SelfChartPage extends StatelessWidget {
  const SelfChartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
        appBar: AppBar(title: const Text('Tự Tỉnh')),
        body: SingleChildScrollView(child: RadarChartSample1()),
      ),
    );
  }
}
