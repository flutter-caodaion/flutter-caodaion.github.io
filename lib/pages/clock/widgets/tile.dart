import 'package:alarm/model/alarm_settings.dart';
import 'package:caodaion/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExampleAlarmTile extends StatefulWidget {
  const ExampleAlarmTile({
    required this.dateTime,
    required this.onPressed,
    super.key,
    this.onDismissed,
    this.toggleActiveLoopAlarm,
    required this.loopData,
  });

  final DateTime dateTime;
  final Map loopData;
  final void Function() onPressed;
  final void Function()? onDismissed;
  final ValueChanged? toggleActiveLoopAlarm;

  @override
  State<ExampleAlarmTile> createState() => _ExampleAlarmTileState();
}

class _ExampleAlarmTileState extends State<ExampleAlarmTile> {
  late List<AlarmSettings> alarms;
  late DateTime nextAlarm = DateTime.now();
  late dynamic confirmDismiss = true;

  @override
  void initState() {
    loadAlarms(0);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ExampleAlarmTile oldWidget) {
    loadAlarms(0);
    super.didUpdateWidget(oldWidget);
  }

  void loadAlarms(int? id) {
    setState(() {
      var elementWeekday = widget.dateTime.weekday;
      var operatorWeekday = widget.dateTime.weekday;
      final nowDate = DateTime.now();
      if (widget.dateTime.compareTo(DateTime.now()) == -1) {
        if (nowDate.year == widget.dateTime.year &&
            nowDate.month == widget.dateTime.month &&
            nowDate.day == widget.dateTime.day) {
          elementWeekday += 1;
          operatorWeekday += 1;
        }
        if (widget.loopData['selectedDays'] != null) {
          while (widget.loopData['selectedDays'][elementWeekday - 1] != true ||
              operatorWeekday - widget.dateTime.weekday < 0) {
            if (elementWeekday == 7) {
              elementWeekday = 1;
            } else {
              elementWeekday++;
            }
            operatorWeekday++;
          }
        }
      } else {
        if (widget.loopData['selectedDays'] != null) {
          while (widget.loopData['selectedDays'][elementWeekday - 1] != true ||
              operatorWeekday - widget.dateTime.weekday < 0) {
            if (elementWeekday == 7) {
              elementWeekday = 1;
            } else {
              elementWeekday++;
            }
            operatorWeekday++;
          }
        }
      }
      if (widget.dateTime.second != DateTime.now().second) {
        nextAlarm = widget.dateTime
            .add(Duration(days: operatorWeekday - widget.dateTime.weekday));
      }
      var data = widget.loopData['data'];
      if (data != null) {
        confirmDismiss = AlarmConstants.defaultLoopAlarms.firstWhere(
                (item) => item['id'].toString() == data['id'].toString(),
                orElse: () => null) ==
            null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var data = widget.loopData['data'];
    return Dismissible(
      confirmDismiss: (direction) async {
        return confirmDismiss;
      },
      key: widget.key!,
      direction: widget.onDismissed != null
          ? DismissDirection.endToStart
          : DismissDirection.none,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 30),
        child: const Icon(
          Icons.delete,
          size: 30,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) => widget.onDismissed?.call(),
      child: RawMaterialButton(
        onPressed: widget.onPressed,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.loopData.isNotEmpty
                        ? Builder(
                            builder: (context) {
                              return Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                children: [
                                  Text(data!['notificationTitle']),
                                  Wrap(
                                    children: [
                                      const Icon(Icons.navigate_next_rounded),
                                      Text("${TimeOfDay(
                                        hour: nextAlarm.hour,
                                        minute: nextAlarm.minute,
                                      ).format(context)} ${DateFormat.d().format(nextAlarm)}/${DateFormat.M().format(nextAlarm)}/${DateFormat.y().format(nextAlarm)}"),
                                    ],
                                  ),
                                ],
                              );
                            },
                          )
                        : const SizedBox(),
                    Text(
                      TimeOfDay(
                        hour: widget.dateTime.hour,
                        minute: widget.dateTime.minute,
                      ).format(context),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    widget.loopData.isNotEmpty
                        ? Builder(
                            builder: (BuildContext context) {
                              List<String> days = [
                                'T2',
                                'T3',
                                'T4',
                                'T5',
                                'T6',
                                'T7',
                                'CN'
                              ];
                              if (widget.loopData['selectedDays'] is List) {
                                return Wrap(
                                  children: widget.loopData['selectedDays']
                                      .asMap()
                                      .entries
                                      .map<Widget>(
                                    (entry) {
                                      int index = entry.key;
                                      return Text(
                                        entry.value ? "${days[index]} " : '',
                                      );
                                    },
                                  ).toList(),
                                );
                              } else {
                                return const Text("No selected days");
                              }
                            },
                          )
                        : Text(
                            "${widget.dateTime.day}/${widget.dateTime.month}/${widget.dateTime.year}",
                          ),
                  ],
                ),
              ),
              widget.loopData.isNotEmpty
                  ? Switch(
                      value: widget.loopData['active'] ?? false,
                      onChanged: (value) =>
                          widget.toggleActiveLoopAlarm!(widget.loopData),
                    )
                  : const Icon(Icons.keyboard_arrow_right_rounded, size: 35),
            ],
          ),
        ),
      ),
    );
  }
}
