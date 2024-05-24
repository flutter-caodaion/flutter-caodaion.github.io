import 'package:calendar_view/calendar_view.dart';
import 'package:caodaion/constants/constants.dart';
import 'package:caodaion/pages/calendar/widget/calendar_day_view.widget.dart';
import 'package:caodaion/pages/calendar/widget/calendar_month_view.widget.dart';
import 'package:caodaion/pages/calendar/widget/calendar_week_view.widget.dart';
import 'package:caodaion/widgets/responsive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CalendarPage extends StatefulWidget {
  final Map param;

  const CalendarPage({super.key, required this.param});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final DateTime selectedTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadInitMonth();
  }

  _loadInitMonth() {}

  Widget _buildCalendarView() {
    print(widget.param);
    switch (widget.param['mode']) {
      case 'ngay':
        return const CalendarDayView();
      case 'tuan':
        return const CalendarWeekView();
      case 'thang':
      default:
        return CalendarMonthView(
          initialMonth: selectedTime,
        );
    }
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
          actions: [
            Row(
              children: [
                Tooltip(
                  message: "Hôm nay",
                  child: IconButton(
                    onPressed: () {
                      context.go("/lich/${widget.param['mode'] ?? ''}");
                    },
                    icon: const Icon(Icons.today),
                  ),
                ),
              ],
            )
          ],
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: CalendarControllerProvider(
            controller: EventController(),
            child: _buildCalendarView(),
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
