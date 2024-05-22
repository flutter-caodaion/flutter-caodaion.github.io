// home_page.dart
import 'package:caodaion/widgets/responsive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
        appBar: AppBar(actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_outlined),
            tooltip: 'Quét mã QR',
            onPressed: () {
              context.go('/qr');
            },
            padding: const EdgeInsets.symmetric(horizontal: 20)
          ),
        ]),
        body: const Center(child: Text('Home Page')),
      ),
    );
  }
}
