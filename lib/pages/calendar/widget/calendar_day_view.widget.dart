import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

class CalendarDayView extends StatefulWidget {
  final DateTime initialDay;
  final ValueChanged<DateTime> onPageChange;
  const CalendarDayView(
      {super.key, required this.initialDay, required this.onPageChange});

  @override
  State<CalendarDayView> createState() => _CalendarDayViewState();
}

class _CalendarDayViewState extends State<CalendarDayView> {
  @override
  Widget build(BuildContext context) {
    return DayView(
      initialDay: widget.initialDay,
      onPageChange: (date, page) {
        widget.onPageChange(date);
      },
      dayTitleBuilder: (date) {
        return const SizedBox();
      },
    );
  }
}
