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
  final Map params;

  const CalendarPage({super.key, required this.params});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime selectedTime = DateTime.now();
  // DateTime selectedTime = DateTime.utc(2000);
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

  String titleText() {
    switch (widget.params['mode']) {
      case "ngay":
        return "${selectedTime.day}/${selectedTime.month}/${selectedTime.year}";
      case "tuan":
        final getDate = DateTime.parse(selectedTime.toString());
        final fromDate = getDate.subtract(Duration(days: getDate.weekday - 1));
        final toDate =
            getDate.add(Duration(days: DateTime.daysPerWeek - getDate.weekday));
        return "${fromDate.day}/${fromDate.month}${fromDate.year != toDate.year ? '/${fromDate.year}' : ''}-${toDate.day}/${toDate.month}/${toDate.year}";
      default:
        return "Tháng ${DateFormat.M().format(selectedTime)}";
    }
  }

  void _onUpdateDate(String action) {
    DateTime newTime = selectedTime;
    switch (action) {
      case "back":
        switch (widget.params['mode']) {
          case "ngay":
            newTime = selectedTime.subtract(const Duration(days: 1));
            break;
          case "tuan":
            newTime = selectedTime.subtract(const Duration(days: 7));
            break;
          default:
            newTime = DateTime(selectedTime.year, selectedTime.month - 1, 1);
            break;
        }
        break;
      case "forward":
        switch (widget.params['mode']) {
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
    switch (widget.params['mode']) {
      case 'ngay':
        return CalendarDayView(
          initialDay: selectedTime,
          key: ValueKey(selectedTime),
          onPageChange: (value) {
            setState(() {
              selectedTime = value;
            });
          },
        );
      case 'tuan':
        return CalendarWeekView(
          initialDay: selectedTime,
          key: ValueKey(selectedTime),
          onPageChange: (value) {
            setState(() {
              selectedTime = value;
            });
          },
        );
      default:
        return CalendarMonthView(
          initialMonth: selectedTime,
          key: ValueKey(selectedTime),
          onPageChange: (value) {
            setState(() {
              selectedTime = value;
            });
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
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
                message:
                    "${widget.params['mode'] == 'ngay' ? 'Ngày' : widget.params['mode'] == 'tuan' ? 'Tuần' : 'Tháng'} trước",
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
                message:
                    "${widget.params['mode'] == 'ngay' ? 'Ngày' : widget.params['mode'] == 'tuan' ? 'Tuần' : 'Tháng'} sau",
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
              Text(
                titleText(),
                style: const TextStyle(fontSize: 14),
              )
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
