import 'package:calendar_view/calendar_view.dart';
import 'package:caodaion/constants/constants.dart';
import 'package:caodaion/pages/calendar/widget/calendar_day_view.widget.dart';
import 'package:caodaion/pages/calendar/widget/calendar_month_view.widget.dart';
import 'package:caodaion/pages/calendar/widget/calendar_week_view.widget.dart';
import 'package:caodaion/widgets/responsive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  final Map param;

  const CalendarPage({super.key, required this.param});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime selectedTime = DateTime.now();
  bool isShowMonthSection = false;

  @override
  void initState() {
    super.initState();
    _loadInitMonth();
  }

  @override
  void didUpdateWidget(covariant CalendarPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadInitMonth();
  }

  _loadInitMonth() {}

  void _onUpdateDate(String action) {
    DateTime newTime = selectedTime;
    switch (action) {
      case "back":
        switch (widget.param['mode']) {
          case "ngay":
            newTime = selectedTime.subtract(Duration(days: 1));
            break;
          case "tuan":
            newTime = selectedTime.subtract(Duration(days: 7));
            break;
          default:
            newTime = DateTime(selectedTime.year, selectedTime.month - 1, 1);
            break;
        }
        break;
      case "forward":
        switch (widget.param['mode']) {
          case "ngay":
            newTime = selectedTime.add(Duration(days: 1));
            break;
          case "tuan":
            newTime = selectedTime.add(Duration(days: 7));
            break;
          default:
            newTime = DateTime(selectedTime.year, selectedTime.month + 1, 1);
            break;
        }
        break;
      default:
        break;
    }
    setState(() {
      selectedTime = newTime;
    });
  }

  Widget _buildCalendarView() {
    switch (widget.param['mode']) {
      case 'ngay':
        return const CalendarDayView();
      case 'tuan':
        return const CalendarWeekView();
      default:
        return CalendarMonthView(
          initialMonth: selectedTime,
          key: ValueKey(selectedTime),
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
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Tooltip(
                message: "trước",
                child: IconButton(
                  onPressed: () {
                    _onUpdateDate('back');
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 15,
                  ),
                ),
              ),
              Tooltip(
                message: "sau",
                child: IconButton(
                  onPressed: () {
                    _onUpdateDate('forward');
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                ),
              ),
              Builder(builder: (BuildContext context) {
                final String month = DateFormat.M().format(selectedTime);
                return Text(
                  "Tháng $month",
                  style: const TextStyle(fontSize: 14),
                );
              })
            ],
          ),
          actions: [
            Row(
              children: [
                Tooltip(
                  message: "Hôm nay",
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        selectedTime = DateTime.now();
                      });
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
