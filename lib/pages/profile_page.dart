import 'package:flutter/material.dart';
import '../main.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: Text('Profile Page')),
      ),
    );
  }
}
