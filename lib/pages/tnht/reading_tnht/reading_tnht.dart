import 'package:caodaion/pages/tnht/reading_tnht/widget/view_tnht.dart';
import 'package:caodaion/widgets/responsive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ReadingTNHTPage extends StatefulWidget {
  final String id;
  final String group;

  const ReadingTNHTPage({super.key, required this.id, required this.group});

  @override
  State<ReadingTNHTPage> createState() => _ReadingTNHTPageState();
}

class _ReadingTNHTPageState extends State<ReadingTNHTPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      if (ResponsiveBreakpoints.of(context).isDesktop ||
          ResponsiveBreakpoints.of(context).isTablet) {
        return ResponsiveScaffold(
            child: ViewTNHTPage(id: widget.id, group: widget.group));
      }
      return ViewTNHTPage(id: widget.id, group: widget.group);
    });
  }
}
