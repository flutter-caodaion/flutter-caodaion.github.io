import 'dart:convert';

import 'package:alarm/model/alarm_settings.dart';
import 'package:caodaion/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExampleAlarmTile extends StatefulWidget {
  const ExampleAlarmTile({
    required this.dateTime,
    required this.onPressed,
    super.key,
    this.onDismissed,
    this.toggleActiveLoopAlarm,
    required this.loopData,
    this.onLoad,
  });

  final DateTime dateTime;
  final Map loopData;
  final void Function() onPressed;
  final void Function()? onDismissed;
  final ValueChanged? onLoad;
  final ValueChanged? toggleActiveLoopAlarm;

  @override
  State<ExampleAlarmTile> createState() => _ExampleAlarmTileState();
}

class _ExampleAlarmTileState extends State<ExampleAlarmTile> {
  late List<AlarmSettings> alarms;
  late DateTime nextAlarm = DateTime.now();
  DateTime? newAlarmDate;

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
    if (widget.loopData.isNotEmpty) {
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
            while (
                widget.loopData['selectedDays'][elementWeekday - 1] != true ||
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
            while (
                widget.loopData['selectedDays'][elementWeekday - 1] != true ||
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
      });
    } else {
      setState(() {
        nextAlarm = widget.dateTime;
      });
    }
  }

  bool isShowReoppen = false;

  _isReOpenNextAlarm(value) {
    setState(() {
      isShowReoppen = false;
    });
    if (value == false) {
      var elementWeekday = widget.dateTime.weekday;
      var operatorWeekday = widget.dateTime.weekday + 1;
      if (widget.loopData['selectedDays'] != null) {
        while (widget.loopData['selectedDays']
                    [elementWeekday == 7 ? 0 : elementWeekday] !=
                true ||
            operatorWeekday - widget.dateTime.weekday < 0) {
          if (elementWeekday == 7) {
            elementWeekday = 1;
          } else {
            elementWeekday++;
          }
          operatorWeekday++;
        }
      }
      if (widget.dateTime.second != DateTime.now().second) {
        setState(() {
          newAlarmDate = widget.dateTime
              .add(Duration(days: operatorWeekday - widget.dateTime.weekday));
          isShowReoppen = true;
        });
      }
    }
  }

  Future<void> saveAlarm() async {
    var data = widget.loopData['data'];
    if (newAlarmDate != null) {
      Map<dynamic, dynamic> alarmSettings = {
        'id': data['id'],
        'dateTime': newAlarmDate.toString(),
        'loopAudio': data['loopAudio'],
        'vibrate': data['vibrate'],
        'volume': data['volume'],
        'assetAudioPath': data['assetAudioPath'],
        'notificationTitle': data['notificationTitle'],
        'notificationBody': data['notificationBody'],
        'enableNotificationOnKill': data['enableNotificationOnKill'],
        'fadeDuration': data['fadeDuration'],
        'selectedDays': widget.loopData['selectedDays'],
        'active': true,
      };
      final prefs = await SharedPreferences.getInstance();
      final List loopAlarms = jsonDecode(prefs.getString('loopAlarms') ?? '[]');
      var foundLoopAlarms = loopAlarms.firstWhere(
        (la) => la['id'] == alarmSettings['id'],
        orElse: () => {},
      );
      if (foundLoopAlarms.isEmpty) {
        loopAlarms.add(alarmSettings);
      } else {
        foundLoopAlarms = alarmSettings;
        var indexLa =
            loopAlarms.indexWhere((la) => la['id'] == alarmSettings['id']);
        loopAlarms[indexLa] = foundLoopAlarms;
      }
      await prefs.setString('loopAlarms', jsonEncode(loopAlarms.toList()));
      setState(() {
        isShowReoppen = false;
      });
      widget.onLoad!({"id": data['id'], "dateTime": newAlarmDate});
    }
  }

  @override
  Widget build(BuildContext context) {
    var data = widget.loopData['data'];
    return Dismissible(
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
                                      ).format(context)} ${NumberFormat("00").format(nextAlarm.day)}/${NumberFormat("00").format(nextAlarm.month)}/${DateFormat.y().format(nextAlarm)}"),
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
                            "${NumberFormat("00").format(widget.dateTime.day)}/${NumberFormat("00").format(widget.dateTime.month)}/${widget.dateTime.year}",
                          ),
                    isShowReoppen && newAlarmDate != null
                        ? ElevatedButton(
                            onPressed: () {
                              saveAlarm();
                            },
                            child: Text(
                              "Đặt lại vào ngày ${NumberFormat("00").format(newAlarmDate?.day)}/${NumberFormat("00").format(newAlarmDate?.month)}",
                              style: const TextStyle(color: Colors.black),
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
              ),
              widget.loopData.isNotEmpty
                  ? Switch(
                      value: widget.loopData['active'] ?? false,
                      activeColor: ColorConstants.clockColor,
                      onChanged: (value) {
                        widget.toggleActiveLoopAlarm!(widget.loopData);
                        _isReOpenNextAlarm(value);
                      },
                    )
                  : const Icon(Icons.keyboard_arrow_right_rounded, size: 35),
            ],
          ),
        ),
      ),
    );
  }
}
