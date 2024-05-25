import 'package:calendar_view/calendar_view.dart';
import 'package:caodaion/constants/constants.dart';
import 'package:caodaion/pages/calendar/widget/calendar_day_view.widget.dart';
import 'package:caodaion/pages/calendar/widget/calendar_month_view.widget.dart';
import 'package:caodaion/pages/calendar/widget/calendar_week_view.widget.dart';
import 'package:caodaion/widgets/responsive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';

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
            newTime = selectedTime.add(const Duration(days: 1));
            break;
          case "tuan":
            newTime = selectedTime.add(const Duration(days: 7));
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

  AppBar _calendarAppBar() {
    return AppBar(
      titleSpacing: 0,
      leading: Builder(
        builder: (context) {
          return Tooltip(
            message: "${_drawerContainerWidth == 0 ? 'Mở' : 'Đóng'} Menu",
            child: IconButton(
              onPressed: () {
                if (ResponsiveBreakpoints.of(context).isDesktop) {
                  setState(() {
                    _drawerContainerWidth =
                        _drawerContainerWidth == 0 ? 250 : 0;
                  });
                } else {
                  Scaffold.of(context).openDrawer();
                }
              },
              icon: const Icon(Icons.menu),
            ),
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
    );
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

  double _drawerContainerWidth = 250.0;

  Widget _buildSideNav(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: _drawerContainerWidth,
      color: ColorConstants.primaryBackground,
      child: _drawerListView(context),
    );
  }

  Widget _drawerListView(BuildContext context) {
    return _drawerContainerWidth == 0
        ? Container(
            color: ColorConstants.primaryBackground,
          )
        : ListView(
            children: [
              DrawerHeader(
                child: ListTile(
                  leading: SvgPicture.asset(
                    'assets/icons/calendar.svg',
                    color: ColorConstants.calendarColor,
                  ),
                  title: const Text("Lịch Âm Dương"),
                  onTap: () {
                    context.go('/lich');
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.params['mode'] == 'ngay'
                        ? ColorConstants.primaryIndicatorBackground
                        : Colors.transparent,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(100),
                    ),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.view_day_rounded),
                    title: const Text('Ngày'),
                    onTap: () {
                      context.go('/lich/ngay');
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.params['mode'] == 'tuan'
                        ? ColorConstants.primaryIndicatorBackground
                        : Colors.transparent,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(100),
                    ),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.view_week_rounded),
                    title: const Text('Tuần'),
                    onTap: () {
                      context.go('/lich/tuan');
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: (widget.params['mode'] == 'thang' ||
                            widget.params['mode'] == null ||
                            widget.params['mode'] == '')
                        ? ColorConstants.primaryIndicatorBackground
                        : Colors.transparent,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(100),
                    ),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.calendar_view_month_rounded),
                    title: const Text('Tháng'),
                    onTap: () {
                      context.go('/lich/thang');
                    },
                  ),
                ),
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: ResponsiveBreakpoints.of(context).isDesktop
          ? Row(
              children: [
                _buildSideNav(context),
                Expanded(
                    child: Scaffold(
                  appBar: _calendarAppBar(),
                  body: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: CalendarControllerProvider(
                      controller: EventController(),
                      child: _buildCalendarView(),
                    ),
                  ),
                )),
              ],
            )
          : Scaffold(
              appBar: _calendarAppBar(),
              body: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: CalendarControllerProvider(
                  controller: EventController(),
                  child: _buildCalendarView(),
                ),
              ),
              drawer: Drawer(
                backgroundColor: ColorConstants.primaryBackground,
                child: _drawerListView(context),
              ),
            ),
    );
  }
}
