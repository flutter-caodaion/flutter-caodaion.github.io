import 'dart:convert';
import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmRingScreen extends StatefulWidget {
  const AlarmRingScreen({required this.id, super.key});

  final String id;

  @override
  State<AlarmRingScreen> createState() => _AlarmRingScreenState();
}

class _AlarmRingScreenState extends State<AlarmRingScreen> {
  late AlarmSettings alarmSettings = AlarmSettings(
    id: 0,
    dateTime: DateTime.now(),
    assetAudioPath: '',
    notificationTitle: '',
    notificationBody: '',
  );

  @override
  void initState() {
    super.initState();
    getRingData();
  }

  getRingData() async {
    final prefs = await SharedPreferences.getInstance();
    final storage = prefs.getString('alarms');
    final List<dynamic> storageAlarms = jsonDecode(storage!);
    if (storageAlarms.isNotEmpty) {
      final foundActiveAlarm = storageAlarms.firstWhere((item) {
        return item['id'] == int.parse(widget.id);
      }, orElse: () => -1);
      if (foundActiveAlarm != null && foundActiveAlarm != -1) {
        final dateTime =
            DateTime.fromMicrosecondsSinceEpoch(foundActiveAlarm['dateTime']);
        setState(() {
          alarmSettings = AlarmSettings(
            id: int.parse(widget.id),
            dateTime: dateTime,
            loopAudio: foundActiveAlarm['loopAudio'],
            vibrate: foundActiveAlarm['vibrate'],
            volume: foundActiveAlarm['volume'],
            assetAudioPath: foundActiveAlarm['assetAudioPath'],
            notificationTitle: foundActiveAlarm['notificationTitle'].isNotEmpty
                ? foundActiveAlarm['notificationTitle']
                : "Hẹn giờ ${dateTime.hour}:${dateTime.minute}",
            notificationBody: foundActiveAlarm['notificationBody'].isNotEmpty
                ? foundActiveAlarm['notificationBody']
                : "Hẹn giờ ${dateTime.hour}:${dateTime.minute} Ngày ${dateTime.day} tháng ${dateTime.month} năm ${dateTime.year}",
            enableNotificationOnKill: Platform.isIOS,
            fadeDuration: 5,
          );
        });
      }
    }
    loadNextFocus();
  }

  loadNextFocus() async {
    final prefs = await SharedPreferences.getInstance();
    final focusNext = jsonDecode(prefs.getString('focusNext') ?? 'null');
    final now = DateTime.now();
    if (focusNext != null) {
      final itemDate =
          DateTime.fromMicrosecondsSinceEpoch(focusNext['dateTime']);
      final dateTime =
          DateTime.fromMicrosecondsSinceEpoch(focusNext['dateTime']);
      final foundActiveAlarm = now.year == itemDate.year &&
          now.month == itemDate.month &&
          now.day == itemDate.day &&
          now.hour == itemDate.hour &&
          now.minute >= itemDate.minute;
      if (foundActiveAlarm == true) {
        setState(() {
          alarmSettings = AlarmSettings(
            id: int.parse(widget.id),
            dateTime: dateTime,
            loopAudio: focusNext['loopAudio'],
            vibrate: focusNext['vibrate'],
            volume: focusNext['volume'],
            assetAudioPath: focusNext['assetAudioPath'],
            notificationTitle: focusNext['notificationTitle'].isNotEmpty
                ? focusNext['notificationTitle']
                : "Hẹn giờ ${dateTime.hour}:${dateTime.minute}",
            notificationBody: focusNext['notificationBody'].isNotEmpty
                ? focusNext['notificationBody']
                : "Hẹn giờ ${dateTime.hour}:${dateTime.minute} Ngày ${dateTime.day} tháng ${dateTime.month} năm ${dateTime.year}",
            enableNotificationOnKill: Platform.isIOS,
            fadeDuration: 5,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                alarmSettings.notificationTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 30),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                alarmSettings.notificationBody,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Text('🔔', style: TextStyle(fontSize: 50)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // RawMaterialButton(
                //   onPressed: () {
                //     final now = DateTime.now();
                //     Alarm.set(
                //       alarmSettings: alarmSettings.copyWith(
                //         dateTime: DateTime(
                //           now.year,
                //           now.month,
                //           now.day,
                //           now.hour,
                //           now.minute,
                //         ).add(const Duration(minutes: 1)),
                //       ),
                //     ).then((_) => Navigator.pop(context));
                //   },
                //   child: Text(
                //     'Hẹn thêm 1 phút',
                //     style: Theme.of(context).textTheme.titleLarge,
                //   ),
                // ),
                RawMaterialButton(
                  onPressed: () {
                    Alarm.stop(int.parse(widget.id))
                        .then((_) => context.go('/dong-ho'));
                  },
                  child: Text(
                    'Dừng',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
