import 'package:calendar_view/calendar_view.dart';
import 'package:caodaion/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';

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
      eventTileBuilder: (date, events, boundary, startDuration, endDuration) {
        return Column(
          children: events.map((event) {
            var eventData = event.event as Map<dynamic, dynamic>;
            return TextButton(
              onPressed: () {
                // Handle button press, e.g., show event details
                print('Event: ${event}');
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  eventData['eventGroup'] == 'staticGlobal'
                      ? ColorConstants.staticGlobalEventsColor
                      : ColorConstants.primaryBackground,
                ),
                padding: WidgetStateProperty.all<EdgeInsets>(
                  const EdgeInsets.all(4),
                ),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                ),
              ),
              child: SizedBox(
                height: boundary.height,
                child: Text(
                  event.title,
                  style: TextStyle(
                    color: eventData['eventGroup'] == 'staticGlobal'
                        ? Colors.white
                        : Colors.black,
                    fontSize:
                        ResponsiveBreakpoints.of(context).isDesktop ? 16 : 10,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
      onPageChange: (date, page) {
        widget.onPageChange(date);
      },
    );
  }
}
