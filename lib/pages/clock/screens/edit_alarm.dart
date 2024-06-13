import 'dart:convert';
import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExampleAlarmEditScreen extends StatefulWidget {
  const ExampleAlarmEditScreen(
      {super.key, required this.alarmSettings, required this.loopData});

  final alarmSettings;
  final loopData;

  @override
  State<ExampleAlarmEditScreen> createState() => _ExampleAlarmEditScreenState();
}

class _ExampleAlarmEditScreenState extends State<ExampleAlarmEditScreen> {
  bool loading = false;

  late bool creating;
  late DateTime selectedDateTime = DateTime.now();
  late bool loopAudio = true;
  late bool vibrate = true;
  late double volume = 1;
  late String assetAudio;
  late String notificationTitle = '';
  TextEditingController notificationTitleController = TextEditingController();
  late String notificationBody = '';
  TextEditingController notificationBodyController = TextEditingController();

  late List<bool> selectedDays = List.filled(7, false);
  late bool active = true;
  var alarmSettings;
  var loopData;

  @override
  void initState() {
    super.initState();
    creating = widget.alarmSettings == null;

    selectedDays = List.filled(7, false);
    active = true;
    if (creating) {
      selectedDateTime = DateTime.now().add(const Duration(minutes: 1));
      selectedDateTime = selectedDateTime.copyWith(second: 0, millisecond: 0);
      loopAudio = true;
      vibrate = true;
      volume = 0.3; // TODO:
      assetAudio = 'assets/audio/tune.mp3';
    } else {
      if (widget.alarmSettings.runtimeType.toString() == 'AlarmSettings') {
        Map<dynamic, dynamic> widgetAlarmSettings = {
          'id': widget.alarmSettings.id,
          'dateTime': widget.alarmSettings.dateTime.toString(),
          'loopAudio': widget.alarmSettings.loopAudio,
          'vibrate': widget.alarmSettings.vibrate,
          'volume': widget.alarmSettings.volume ?? 1.0,
          'assetAudioPath': widget.alarmSettings.assetAudioPath,
          'notificationTitle': widget.alarmSettings.notificationTitle,
          'notificationBody': widget.alarmSettings.notificationBody,
          'enableNotificationOnKill':
              widget.alarmSettings.enableNotificationOnKill,
          'fadeDuration': widget.alarmSettings.fadeDuration,
          'selectedDays': List.filled(7, false),
          'active': true,
        };
        alarmSettings = widgetAlarmSettings;
        loopData = widgetAlarmSettings;
      } else {
        alarmSettings = widget.alarmSettings;
        loopData = widget.alarmSettings;
      }
      selectedDateTime = alarmSettings['dateTime'] is String
          ? DateTime.parse(alarmSettings['dateTime'])
          : alarmSettings['dateTime'];
      loopAudio = alarmSettings['loopAudio'];
      vibrate = alarmSettings['vibrate'];
      volume = alarmSettings['volume'] ?? 1.0;
      assetAudio = alarmSettings['assetAudioPath'];
      for (var i = 0; i < loopData['selectedDays'].length; i++) {
        selectedDays[i] = loopData['selectedDays'][i].toString() == 'true';
      }
      active = loopData['active'];
    }
  }

  Widget buildDaySelector() {
    List<String> days = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    return Wrap(
      alignment: WrapAlignment.center,
      children: List.generate(7, (index) {
        return ChoiceChip(
          label: Text(days[index]),
          selected: selectedDays[index],
          onSelected: (selected) {
            setState(() {
              selectedDays[index] = selected;
            });
          },
        );
      }),
    );
  }

  String getDay() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final difference = selectedDateTime.difference(today).inDays;

    switch (difference) {
      case 0:
        return 'Hôm nay';
      case 1:
        return 'Ngày mai';
      case 2:
        return 'Ngày mốt';
      default:
        return 'In $difference days';
    }
  }

  Future<void> pickTime() async {
    final res = await showTimePicker(
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      context: context,
      cancelText: "Đóng",
      helpText: "Chọn thời gian",
    );

    if (res != null) {
      setState(() {
        final now = DateTime.now();
        selectedDateTime = now.copyWith(
          hour: res.hour,
          minute: res.minute,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        );
        if (selectedDateTime.isBefore(now)) {
          selectedDateTime = selectedDateTime.add(const Duration(days: 1));
        }
      });
    }
  }

  AlarmSettings buildAlarmSettings() {
    final id = creating
        ? DateTime.now().millisecondsSinceEpoch % 10000 + 1
        : widget.alarmSettings.runtimeType.toString() == 'AlarmSettings'
            ? widget.alarmSettings.id
            : widget.alarmSettings['id'];

    final alarmSettings = AlarmSettings(
        id: id,
        dateTime: selectedDateTime,
        loopAudio: loopAudio,
        vibrate: vibrate,
        volume: volume ?? 1.0,
        assetAudioPath: assetAudio,
        notificationTitle: notificationTitle.isNotEmpty
            ? notificationTitle
            : "Hẹn giờ ${TimeOfDay(hour: selectedDateTime.hour, minute: selectedDateTime.minute).format(context)}",
        notificationBody: notificationBody.isNotEmpty
            ? notificationBody
            : "Hẹn giờ ${TimeOfDay(hour: selectedDateTime.hour, minute: selectedDateTime.minute).format(context)} Ngày ${selectedDateTime.day} tháng ${selectedDateTime.month} năm ${selectedDateTime.year}",
        enableNotificationOnKill: Platform.isIOS,
        fadeDuration: 5);
    return alarmSettings;
  }

  Future<void> saveAlarm() async {
    if (loading) return;
    setState(() => loading = true);
    if (selectedDays.where((sd) => sd == true).isNotEmpty) {
      var elementWeekday = selectedDateTime.weekday;
      var operatorWeekday = selectedDateTime.weekday;
      if (selectedDateTime.day > DateTime.now().day) {
        while (selectedDays[elementWeekday - 1] != true ||
            operatorWeekday - selectedDateTime.weekday <= 0) {
          if (elementWeekday == 7) {
            elementWeekday = 1;
          } else {
            elementWeekday++;
          }
          operatorWeekday++;
        }
        if (operatorWeekday - selectedDateTime.weekday > 0 &&
            selectedDateTime.second < DateTime.now().second) {
          selectedDateTime = selectedDateTime
              .add(Duration(days: operatorWeekday - selectedDateTime.weekday));
        }
      }
    }
    final buildedAlarmSettings = buildAlarmSettings();
    if (selectedDays.where((sd) => sd == true).isNotEmpty) {
      Map<dynamic, dynamic> alarmSettings = {
        'id': buildedAlarmSettings.id,
        'dateTime': buildedAlarmSettings.dateTime.toString(),
        'loopAudio': buildedAlarmSettings.loopAudio,
        'vibrate': buildedAlarmSettings.vibrate,
        'volume': buildedAlarmSettings.volume,
        'assetAudioPath': buildedAlarmSettings.assetAudioPath,
        'notificationTitle': buildedAlarmSettings.notificationTitle,
        'notificationBody': buildedAlarmSettings.notificationBody,
        'enableNotificationOnKill':
            buildedAlarmSettings.enableNotificationOnKill,
        'fadeDuration': buildedAlarmSettings.fadeDuration,
        'selectedDays': selectedDays,
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
    }
    Alarm.set(alarmSettings: buildAlarmSettings()).then((res) {
      if (res) {
        Navigator.pop(context, true);
      }
      setState(() => loading = false);
    });
  }

  void deleteAlarm() {
    Alarm.stop(alarmSettings['id']).then((res) async {
      if (res) {
        Navigator.pop(context, true);
        final prefs = await SharedPreferences.getInstance();
        final List loopAlarms =
            jsonDecode(prefs.getString('loopAlarms') ?? '[]');
        loopAlarms.removeWhere((la) => la['id'] == alarmSettings['id']);
        await prefs.setString('loopAlarms', jsonEncode(loopAlarms.toList()));
      }
      ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Đóng',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.blueAccent),
                ),
              ),
              TextButton(
                onPressed: saveAlarm,
                child: loading
                    ? const CircularProgressIndicator()
                    : Text(
                        'Lưu',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.blueAccent),
                      ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextField(
                controller: notificationTitleController,
                decoration: const InputDecoration(hintText: "Tiêu đề hẹn giờ"),
                onChanged: (value) {
                  setState(
                    () {
                      notificationTitle = value;
                    },
                  );
                },
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                controller: notificationBodyController,
                decoration: const InputDecoration(hintText: "Nội dung hẹn giờ"),
                onChanged: (value) {
                  setState(
                    () {
                      notificationBody = value;
                    },
                  );
                },
              ),
            ],
          ),
          Text(
            getDay(),
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.blueAccent.withOpacity(0.8)),
          ),
          RawMaterialButton(
            onPressed: pickTime,
            fillColor: Colors.grey[200],
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Text(
                TimeOfDay.fromDateTime(selectedDateTime).format(context),
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: Colors.blueAccent),
              ),
            ),
          ),
          buildDaySelector(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lặp âm báo',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Switch(
                value: loopAudio,
                onChanged: (value) => setState(() => loopAudio = value),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rung',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Switch(
                value: vibrate,
                onChanged: (value) => setState(() => vibrate = value),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tùy chỉnh âm lượng',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Switch(
                value: volume != 1.0,
                onChanged: (value) => setState(() => volume = value ? 1.0 : 0),
              ),
            ],
          ),
          SizedBox(
            height: 30,
            child: volume != 1.0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        volume > 0.7
                            ? Icons.volume_up_rounded
                            : volume > 0.1
                                ? Icons.volume_down_rounded
                                : Icons.volume_mute_rounded,
                      ),
                      Expanded(
                        child: Slider(
                          value: volume,
                          onChanged: (value) {
                            setState(() => volume = value);
                          },
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
          if (!creating)
            TextButton(
              onPressed: deleteAlarm,
              child: Text(
                'Xóa hẹn giờ',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.red),
              ),
            ),
          const SizedBox(),
        ],
      ),
    );
  }
}
