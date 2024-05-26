import 'package:caodaion/pages/kinh/reading_kinh/widget/view_kinh.dart';
import 'package:caodaion/widgets/responsive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ReadingKinhPage extends StatefulWidget {
  final String id;

  const ReadingKinhPage({super.key, required this.id});

  @override
  State<ReadingKinhPage> createState() => _ReadingKinhPageState();
}

class _ReadingKinhPageState extends State<ReadingKinhPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      if (ResponsiveBreakpoints.of(context).isDesktop ||
          ResponsiveBreakpoints.of(context).isTablet) {
        return ResponsiveScaffold(child: ViewKinhPage(id: widget.id));
      }
      return ViewKinhPage(id: widget.id);
    });
  }
}
