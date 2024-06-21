import 'package:calendar_view/calendar_view.dart';
import 'package:caodaion/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lunar/calendar/Lunar.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CalendarMonthView extends StatefulWidget {
  final DateTime initialMonth;
  final ValueChanged<DateTime> onPageChange;
  final ValueChanged<DateTime> onOpenDate;
  const CalendarMonthView(
      {super.key,
      required this.initialMonth,
      required this.onPageChange,
      required this.onOpenDate});

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
        final double screenHeight = constraints.maxHeight - 36;
        const int numberOfRows = 6;
        const int numberOfColumns = 7;
        final double cellWidth = screenWidth / numberOfColumns;
        final double cellHeight = screenHeight / numberOfRows;
        final double cellAspectRatio = cellWidth / cellHeight;
        return MonthView(
          initialMonth: widget.initialMonth,
          cellAspectRatio: cellAspectRatio,
          headerBuilder: (date) {
            return const SizedBox();
          },
          weekDayBuilder: (day) {
            String dayText = '';
            switch (day) {
              case 0:
                dayText = 'T2';
                break;
              case 1:
                dayText = 'T3';
                break;
              case 2:
                dayText = 'T4';
                break;
              case 3:
                dayText = 'T5';
                break;
              case 4:
                dayText = 'T6';
                break;
              case 5:
                dayText = 'T7';
                break;
              case 6:
                dayText = 'CN';
                break;
              default:
                break;
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text(dayText)),
            );
          },
          cellBuilder: (date, event, isToday, isInMonth, hideDaysNotInMonth) {
            final dateText = DateFormat.d().format(date);
            final Lunar gotLunar = Lunar.fromDate(date);
            Map<String, String> lunar = {
              "day": gotLunar.getDay().toString(),
              "month": gotLunar.getMonth().toString(),
            };
            if (event.isNotEmpty) {
              // print(event);
            }
            return Container(
              color: isInMonth ? Colors.white : Colors.black.withOpacity(0.05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        widget.onOpenDate(date);
                      },
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
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    ...event.map(
                      (event) {
                        var eventData = event.event as Map<dynamic, dynamic>;
                        return Column(
                          children: [
                            TextButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(
                                  eventData['eventGroup'] == 'staticGlobal'
                                      ? ColorConstants.staticGlobalEventsColor
                                      : eventData['eventGroup'] == 'firstHalf'
                                          ? ColorConstants
                                              .firstHaftMonthEventsColor
                                          : eventData['eventGroup'] == 'humane'
                                              ? ColorConstants.humaneEventsColor
                                              : ColorConstants
                                                  .primaryBackground,
                                ),
                                padding: WidgetStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.all(4),
                                ),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3)),
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                event.title,
                                style: TextStyle(
                                  color: eventData['eventGroup'] ==
                                              'staticGlobal' ||
                                          eventData['eventGroup'] == 'firstHalf'
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: ResponsiveBreakpoints.of(context)
                                          .isDesktop
                                      ? 12
                                      : 10,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          onPageChange: (date, page) {
            widget.onPageChange(date);
          },
        );
      },
    );
  }
}
