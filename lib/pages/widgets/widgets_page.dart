import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

const String appGroupId = 'com.example.caodaion';
const String iOSWidgetName = 'LunarWidgets';
const String androidWidgetName = 'LunarWidget';

class WidgetsPage extends StatefulWidget {
  const WidgetsPage({super.key});
  @override
  State<WidgetsPage> createState() => _WidgetsPageState();
}

void updateHeadline(data) {
  HomeWidget.saveWidgetData<String>('headline_title', data);
  HomeWidget.saveWidgetData<String>('headline_description', data);
  HomeWidget.updateWidget(
    iOSName: iOSWidgetName,
    androidName: androidWidgetName,
  );
}

class _WidgetsPageState extends State<WidgetsPage> {
  @override
  void initState() {
    super.initState();

    HomeWidget.setAppGroupId(appGroupId);
    updateHeadline("this is the message when init widget");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widgets'),
        centerTitle: false,
      ),
      body: Center(
        child: TextButton(
          child: const Text("update"),
          onPressed: () {
            updateHeadline("This is the updated content!");
          },
        ),
      ),
    );
  }
}
