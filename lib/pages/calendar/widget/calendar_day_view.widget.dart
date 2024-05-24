import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

class CalendarDayView extends StatefulWidget {
  const CalendarDayView({super.key});

  @override
  State<CalendarDayView> createState() => _CalendarDayViewState();
}

class _CalendarDayViewState extends State<CalendarDayView> {
  @override
  Widget build(BuildContext context) {
    return DayView();
  }
}