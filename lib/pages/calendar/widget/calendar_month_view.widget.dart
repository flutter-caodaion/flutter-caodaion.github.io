import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarMonthView extends StatefulWidget {
  const CalendarMonthView({super.key});

  @override
  State<CalendarMonthView> createState() => _CalendarMonthViewState();
}

class _CalendarMonthViewState extends State<CalendarMonthView> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = constraints.maxWidth;
        final double screenHeight = constraints.maxHeight - 40;
        const int numberOfRows = 6;
        const int numberOfColumns = 7;
        final double cellAspectRatio = screenWidth / screenHeight;
        return MonthView(
          cellAspectRatio: cellAspectRatio,
          cellBuilder: (date, event, isToday, isInMonth, hideDaysNotInMonth) {
            final dateText = DateFormat.d().format(date);
            return SizedBox(
              width: screenWidth / numberOfColumns,
              height: screenHeight / numberOfRows,
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      dateText,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
