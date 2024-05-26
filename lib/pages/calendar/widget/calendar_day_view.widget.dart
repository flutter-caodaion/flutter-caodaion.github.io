import 'package:calendar_view/calendar_view.dart';
import 'package:caodaion/constants/constants.dart';
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
      eventTileBuilder: (date, events, boundary, startDuration, endDuration) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: events.map((event) {
            var eventData = event.event as Map<dynamic, dynamic>;
            return TextButton(
              onPressed: () {
                // Handle button press, e.g., show event details
                print('Event: $event');
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  eventData['eventGroup'] == 'staticGlobal'
                      ? ColorConstants.staticGlobalEventsColor
                      : ColorConstants.primaryBackground,
                ),
                padding: WidgetStateProperty.all<EdgeInsets>(
                  const EdgeInsets.all(8),
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
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
