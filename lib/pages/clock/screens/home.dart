import 'dart:async';
import 'dart:convert';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:caodaion/constants/alarm.constants.dart';
import 'package:caodaion/pages/clock/screens/edit_alarm.dart';
import 'package:caodaion/pages/clock/widgets/tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmHome extends StatefulWidget {
  const AlarmHome({super.key});

  @override
  State<AlarmHome> createState() => _AlarmHomeState();
}

class _AlarmHomeState extends State<AlarmHome> {
  late List<AlarmSettings> alarms;
  late List loopAlarmList = [];
  static StreamSubscription<AlarmSettings>? subscription;

  @override
  void initState() {
    super.initState();
    if (Alarm.android) {
      checkAndroidNotificationPermission();
      checkAndroidScheduleExactAlarmPermission();
    }
    loadAlarms(0);
    subscription ??= Alarm.ringStream.stream.listen((alarmSettings) {
      navigateToRingScreen(alarmSettings);
    });
  }

  void loadAlarms(int? id) {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      storeAlarms();
      storeLoopAlarm();
    });
  }

  storeLoopAlarm() async {
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('loopAlarms');
    var loopAlarms = jsonDecode(prefs.getString('loopAlarms') ?? '[]');
    setState(() {
      loopAlarmList = loopAlarms;
      loopAlarmList.sort((a, b) {
        var aDateTime = DateTime.utc(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          DateTime.parse(a['dateTime']).hour,
          DateTime.parse(a['dateTime']).minute,
        );
        var bDateTime = DateTime.utc(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          DateTime.parse(b['dateTime']).hour,
          DateTime.parse(b['dateTime']).minute,
        );
        return aDateTime.compareTo(bDateTime);
      });
      for (var element in loopAlarmList) {
        if (element['active'] == true) {
          if (element['dateTime'] != null) {
            final nowDateTime = DateTime.now();
            element['dateTime'] =
                "${DateFormat.y().format(nowDateTime)}-${NumberFormat("00").format(nowDateTime.month)}-${NumberFormat("00").format(nowDateTime.day)} ${element['dateTime'].split(" ")[1]}";
          }
          var parseDateTime = DateTime.parse(element['dateTime']);
          var foundAlarm = alarms.firstWhere(
            (test) => test.dateTime == parseDateTime,
            orElse: () => AlarmSettings(
              id: element['id'],
              dateTime: parseDateTime,
              assetAudioPath: element['assetAudioPath'],
              notificationTitle: element['notificationTitle'],
              notificationBody: element['notificationBody'],
              enableNotificationOnKill: element['enableNotificationOnKill'],
              fadeDuration: element['fadeDuration'],
              loopAudio: element['loopAudio'],
              vibrate: element['vibrate'],
              volume: element['volume'],
            ),
          );
          var elementWeekday = foundAlarm.dateTime.weekday;
          var operatorWeekday = foundAlarm.dateTime.weekday;
          final nowDate = DateTime.now();
          if (foundAlarm.dateTime.compareTo(DateTime.now()) == -1) {
            if (nowDate.year == foundAlarm.dateTime.year &&
                nowDate.month == foundAlarm.dateTime.month &&
                nowDate.day == foundAlarm.dateTime.day) {
              elementWeekday += 1;
              operatorWeekday += 1;
            }
            while (element['selectedDays'][elementWeekday - 1] != true ||
                operatorWeekday - foundAlarm.dateTime.weekday < 0) {
              if (elementWeekday == 7) {
                elementWeekday = 1;
              } else {
                elementWeekday++;
              }
              operatorWeekday++;
            }
          } else {
            while (element['selectedDays'][elementWeekday - 1] != true ||
                operatorWeekday - foundAlarm.dateTime.weekday < 0) {
              if (elementWeekday == 7) {
                elementWeekday = 1;
              } else {
                elementWeekday++;
              }
              operatorWeekday++;
            }
          }
          if (foundAlarm.dateTime.microsecond != DateTime.now().microsecond) {
            var addedDate = foundAlarm.dateTime.add(
                Duration(days: operatorWeekday - foundAlarm.dateTime.weekday));
            var newAlarmSettings = AlarmSettings(
              id: foundAlarm.id,
              dateTime: addedDate,
              loopAudio: foundAlarm.loopAudio,
              vibrate: foundAlarm.vibrate,
              volume: foundAlarm.volume,
              assetAudioPath: foundAlarm.assetAudioPath,
              notificationTitle: foundAlarm.notificationTitle,
              notificationBody: foundAlarm.notificationBody,
              enableNotificationOnKill: foundAlarm.enableNotificationOnKill,
              fadeDuration: foundAlarm.fadeDuration,
            );
            Alarm.set(alarmSettings: newAlarmSettings).then(
              (res) async {
                if (res) {
                  setState(() {
                    alarms = Alarm.getAlarms();
                    alarms.sort((a, b) => a.dateTime.compareTo(b.dateTime));
                    storeAlarms();
                  });
                }
              },
            );
          }
        }
      }
    });
  }

  toggleActiveLoopAlarm(value) async {
    final prefs = await SharedPreferences.getInstance();
    var indexLa =
        loopAlarmList.indexWhere((la) => la['id'] == value['data']['id']);
    loopAlarmList[indexLa]['active'] = !loopAlarmList[indexLa]['active'];
    await prefs.setString('loopAlarms', jsonEncode(loopAlarmList.toList()));
    var foundList = alarms.where((item) =>
        item.dateTime.hour == DateTime.parse(value['data']['dateTime']).hour &&
        item.dateTime.minute ==
            DateTime.parse(value['data']['dateTime']).minute);
    if (!loopAlarmList[indexLa]['active']) {
      if (foundList.isNotEmpty) {
        for (var element in foundList) {
          stopAlarm(element.id);
        }
      }
    }
    storeLoopAlarm();
  }

  storeAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'alarms',
      jsonEncode(
        alarms.toList(),
      ),
    );
  }

  void navigateToRingScreen(AlarmSettings alarmSettings) {
    loadAlarms(alarmSettings.id);
  }

  Future<void> navigateToAlarmScreen(settings) async {
    final res = await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      builder: (context) {
        var mapSettings = settings;
        return FractionallySizedBox(
          heightFactor: 0.75,
          child: ExampleAlarmEditScreen(
            alarmSettings: mapSettings,
            loopData: mapSettings,
          ),
        );
      },
    );

    if (res != null && res == true) loadAlarms(0);
  }

  removeLoopAlarm(id) async {
    final prefs = await SharedPreferences.getInstance();
    final List loopAlarms = jsonDecode(prefs.getString('loopAlarms') ?? '[]');
    loopAlarms.removeWhere((la) => la['id'] == id);
    await prefs.setString('loopAlarms', jsonEncode(loopAlarms.toList()));
    storeLoopAlarm();
    Alarm.stop(id).then((_) {
      loadAlarms(0);
    });
  }

  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    if (status.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
  }

  onSelectAlarmList(value) async {
    if (value == 'useDefaultLoopAlarms') {
      final prefs = await SharedPreferences.getInstance();
      var storedLoopAlarm = jsonDecode(prefs.getString('loopAlarms') ?? '[]');
      storedLoopAlarm = [
        ...storedLoopAlarm,
        ...AlarmConstants.defaultLoopAlarms
      ];
      await prefs.setString('loopAlarms', jsonEncode(storedLoopAlarm.toList()));
      storeLoopAlarm();
    }
    if (value == 'useReadyLoopAlarms') {
      final prefs = await SharedPreferences.getInstance();
      var storedLoopAlarm = jsonDecode(prefs.getString('loopAlarms') ?? '[]');
      storedLoopAlarm = [...storedLoopAlarm, ...AlarmConstants.readLoopAlarms];
      await prefs.setString('loopAlarms', jsonEncode(storedLoopAlarm.toList()));
      storeLoopAlarm();
    }
    if (value == 'removeAll') {
      final prefs = await SharedPreferences.getInstance();
      var storedLoopAlarm = jsonDecode(prefs.getString('loopAlarms') ?? '[]');
      storedLoopAlarm = [];
      await prefs.setString('loopAlarms', jsonEncode(storedLoopAlarm.toList()));
      storeLoopAlarm();
    }
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Danh sách hẹn giờ",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      PopupMenuButton(
                        color: Colors.white,
                        icon: const Icon(Icons.more_vert_rounded),
                        itemBuilder: (BuildContext context) {
                          return [
                            const PopupMenuItem(
                              value: 'useDefaultLoopAlarms',
                              child: Text('Dùng hẹn giờ từ ứng dụng'),
                            ),
                            const PopupMenuItem(
                              value: 'useReadyLoopAlarms',
                              child: Text('Báo trước hẹn giờ từ ứng dụng'),
                            ),
                            const PopupMenuItem(
                              value: 'removeAll',
                              child: Text('Xoá tất cả'),
                            ),
                          ];
                        },
                        onSelected: (value) {
                          onSelectAlarmList(value);
                        },
                      ),
                    ],
                  ),
                  const Divider(),
                  loopAlarmList.isNotEmpty
                      ? ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: loopAlarmList.length,
                          separatorBuilder: (context, index) => const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Divider(height: 1),
                          ),
                          itemBuilder: (context, index) {
                            var data = loopAlarmList[index];
                            var dateTime = DateTime.parse(data['dateTime']);
                            return data.isNotEmpty
                                ? ExampleAlarmTile(
                                    key: Key(data['id'].toString()),
                                    dateTime: dateTime,
                                    loopData: {
                                      "selectedDays": data['selectedDays'],
                                      "active": data['active'] ?? false,
                                      "data": data,
                                    },
                                    onPressed: () =>
                                        navigateToAlarmScreen(data),
                                    onDismissed: () {
                                      removeLoopAlarm(data['id']);
                                    },
                                    toggleActiveLoopAlarm: (value) {
                                      toggleActiveLoopAlarm(value);
                                    },
                                  )
                                : const SizedBox();
                          },
                          shrinkWrap: true,
                        )
                      : Center(
                          child: Text(
                            'Chưa có hẹn giờ nào được lưu',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                ],
              ),
            ),
            // SliverList(
            //   delegate: SliverChildListDelegate(
            //     [
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         children: [
            //           Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: Text(
            //               "Hẹn giờ sắp tới",
            //               style: Theme.of(context).textTheme.titleLarge,
            //             ),
            //           ),
            //         ],
            //       ),
            //       const Divider(),
            //       alarms.isNotEmpty
            //           ? ListView.separated(
            //               physics: const NeverScrollableScrollPhysics(),
            //               itemCount: alarms.length,
            //               separatorBuilder: (context, index) => const Padding(
            //                 padding: EdgeInsets.symmetric(horizontal: 8.0),
            //                 child: Divider(height: 1),
            //               ),
            //               itemBuilder: (context, index) {
            //                 return ExampleAlarmTile(
            //                   key: Key(alarms[index].id.toString()),
            //                   loopData: {},
            //                   dateTime: alarms[index].dateTime,
            //                   onPressed: () =>
            //                       navigateToAlarmScreen(alarms[index]),
            //                   onDismissed: () {
            //                     stopAlarm(alarms[index].id);
            //                   },
            //                 );
            //               },
            //               shrinkWrap: true,
            //             )
            //           : Center(
            //               child: Text(
            //                 'Hẹn giờ sắp tới chưa có',
            //                 style: Theme.of(context).textTheme.titleMedium,
            //               ),
            //             ),
            //     ],
            //   ),
            // ),
            const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 48),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // ExampleAlarmHomeShortcutButton(refreshAlarms: (value) {
            //   loadAlarms(
            //     value,
            //   );
            // }),
            FloatingActionButton(
              onPressed: () => navigateToAlarmScreen(null),
              child: const Icon(Icons.alarm_add_rounded, size: 33),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void stopAlarm(int id) {
    Alarm.stop(id).then((_) => loadAlarms(id));
  }
}
