import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarWeekView extends StatefulWidget {
  final DateTime initialDay;
  final ValueChanged<DateTime> onPageChange;
  const CalendarWeekView(
      {super.key, required this.initialDay, required this.onPageChange});

  @override
  State<CalendarWeekView> createState() => _CalendarWeekViewState();
}

class _CalendarWeekViewState extends State<CalendarWeekView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WeekView(
      initialDay: widget.initialDay,
      showLiveTimeLineInAllDays: true,
      weekPageHeaderBuilder: (startDate, endDate) {
        return const SizedBox();
      },
      weekDayStringBuilder: (p0) {
        switch (p0) {
          case 0:
            return "T2";
          case 1:
            return "T3";
          case 2:
            return "T4";
          case 3:
            return "T5";
          case 4:
            return "T6";
          case 5:
            return "T7";
          case 6:
            return "CN";
          default:
        }
        return p0.toString();
      },
      onPageChange: (date, page) {
        widget.onPageChange(date);
      },
    );
  }
}
