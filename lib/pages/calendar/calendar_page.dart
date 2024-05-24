import 'package:calendar_view/calendar_view.dart';
import 'package:caodaion/constants/constants.dart';
import 'package:caodaion/pages/calendar/widget/calendar_day_view.widget.dart';
import 'package:caodaion/pages/calendar/widget/calendar_month_view.widget.dart';
import 'package:caodaion/pages/calendar/widget/calendar_week_view.widget.dart';
import 'package:caodaion/widgets/responsive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CalendarPage extends StatefulWidget {
  final String mode;

  const CalendarPage({super.key, required this.mode});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.menu),
              );
            },
          ),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: CalendarControllerProvider(
            controller: EventController(),
            child: widget.mode == 'ngay'
                ? const CalendarDayView()
                : widget.mode == 'tuan'
                    ? const CalendarWeekView()
                    : const CalendarMonthView(),
          ),
        ),
        drawer: Drawer(
          backgroundColor: ColorConstants.primaryBackground,
          child: ListView(
            children: [
              const DrawerHeader(
                child: Text('CaoDaiON Lịch'),
              ),
              ListTile(
                title: const Text('Ngày'),
                onTap: () {
                  context.go('/lich/ngay');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Tuần'),
                onTap: () {
                  context.go('/lich/tuan');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Tháng'),
                onTap: () {
                  context.go('/lich/thang');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
