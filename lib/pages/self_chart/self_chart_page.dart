// self_chart_page.dart
import 'package:caodaion/constants/constants.dart';
import 'package:caodaion/pages/self_chart/self_chart_page%20copy.dart';
import 'package:caodaion/widgets/responsive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SelfChartPage extends StatelessWidget {
  const SelfChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.go('/apps');
          },
        ),
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/chart.svg',
              color: ColorConstants.chartColor,
            ),
            const SizedBox(
              width: 8,
            ),
            const Text("Tự tỉnh"),
          ],
        ),
      ),
      body: SingleChildScrollView(child: RadarChartSample1()),
    );
  }
}
