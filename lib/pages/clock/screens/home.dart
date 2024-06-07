import 'dart:async';
import 'dart:convert';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:caodaion/pages/clock/screens/edit_alarm.dart';
import 'package:caodaion/pages/clock/screens/shortcut_button.dart';
import 'package:caodaion/pages/clock/widgets/tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExampleAlarmHomeScreen extends StatefulWidget {
  const ExampleAlarmHomeScreen({super.key});

  @override
  State<ExampleAlarmHomeScreen> createState() => _ExampleAlarmHomeScreenState();
}

class _ExampleAlarmHomeScreenState extends State<ExampleAlarmHomeScreen> {
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
    final List loopAlarms = jsonDecode(prefs.getString('loopAlarms') ?? '[]');
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
          if (foundAlarm.dateTime.compareTo(DateTime.now()) == -1) {
            while (element['selectedDays'][elementWeekday - 1] != true ||
                operatorWeekday - foundAlarm.dateTime.weekday <= 0) {
              if (elementWeekday == 7) {
                elementWeekday = 1;
              } else {
                elementWeekday++;
              }
              operatorWeekday++;
            }
          }
          if (operatorWeekday - foundAlarm.dateTime.weekday > 0 &&
              foundAlarm.dateTime.second < DateTime.now().second) {
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
  }

  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      final res = await Permission.notification.request();
    }
  }

  Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    if (status.isDenied) {
      final res = await Permission.scheduleExactAlarm.request();
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Danh sách hẹn giờ",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Hẹn giờ sắp tới",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  alarms.isNotEmpty
                      ? ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: alarms.length,
                          separatorBuilder: (context, index) => const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Divider(height: 1),
                          ),
                          itemBuilder: (context, index) {
                            return ExampleAlarmTile(
                              key: Key(alarms[index].id.toString()),
                              loopData: {},
                              dateTime: alarms[index].dateTime,
                              onPressed: () =>
                                  navigateToAlarmScreen(alarms[index]),
                              onDismissed: () {
                                stopAlarm(alarms[index].id);
                              },
                            );
                          },
                          shrinkWrap: true,
                        )
                      : Center(
                          child: Text(
                            'Hẹn giờ sắp tới chưa có',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                ],
              ),
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
