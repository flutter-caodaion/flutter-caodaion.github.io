import 'package:calendar_view/calendar_view.dart';
import 'package:caodaion/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lunar/calendar/Lunar.dart';

class CalendarMonthView extends StatefulWidget {
  final DateTime initialMonth;
  const CalendarMonthView({super.key, required this.initialMonth});

  @override
  State<CalendarMonthView> createState() => _CalendarMonthViewState();
}

class _CalendarMonthViewState extends State<CalendarMonthView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = constraints.maxWidth;
        final double screenHeight = constraints.maxHeight;
        const int numberOfRows = 6;
        const int numberOfColumns = 7;
        final double cellAspectRatio = screenWidth / screenHeight;
        return MonthView(
          initialMonth: widget.initialMonth,
          cellAspectRatio: cellAspectRatio,
          headerBuilder: (date) {
            return const SizedBox();
          },
          cellBuilder: (date, event, isToday, isInMonth, hideDaysNotInMonth) {
            final dateText = DateFormat.d().format(date);
            final Lunar gotLunar = Lunar.fromDate(date);
            Map<String, String> lunar = {
              "day": gotLunar.getDay().toString(),
              "month": gotLunar.getMonth().toString(),
            };
            return SizedBox(
              width: screenWidth / numberOfColumns,
              height: screenHeight / numberOfRows,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: isToday
                            ? ColorConstants.primaryColor
                            : Colors.transparent,
                      ),
                      child: Column(
                        children: [
                          Text(
                            dateText,
                            style: TextStyle(
                              color: isToday ? Colors.white : Colors.black,
                            ),
                          ),
                          Text(
                            "${lunar['day']}/${lunar['month']}",
                            style: TextStyle(
                              fontSize: 12,
                              color: isToday ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
