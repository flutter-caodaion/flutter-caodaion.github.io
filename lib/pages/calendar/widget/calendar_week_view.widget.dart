import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

class CalendarWeekView extends StatefulWidget {
  const CalendarWeekView({super.key});

  @override
  State<CalendarWeekView> createState() => _CalendarWeekViewState();
}

class _CalendarWeekViewState extends State<CalendarWeekView> {
  @override
  Widget build(BuildContext context) {
    return WeekView();
  }
}