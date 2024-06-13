import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:caodaion/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FocusMode extends StatefulWidget {
  const FocusMode({super.key});

  @override
  State<FocusMode> createState() => _FocusModeState();
}

class _FocusModeState extends State<FocusMode> {
  TextEditingController focusDurationController = TextEditingController();
  TextEditingController breakDurationController = TextEditingController();
  int focusMins = 1; // default 30
  int breakMins = 1; // default 5
  double volume = 0.3; // default 1.0
  bool isRunning = false; // default 1.0

  @override
  void initState() {
    loadInitValue();
    loadNextFocus();
    super.initState();
  }

  loadNextFocus() {
    
  }

  loadInitValue() {
    focusDurationController.text = focusMins.toString();
    breakDurationController.text = breakMins.toString();
  }

  onUpdateSettingValue() {}

  onStart() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmDateTime = DateTime.now().add(Duration(minutes: focusMins));
    final alarmSettings = AlarmSettings(
      id: DateTime.now().millisecondsSinceEpoch % 10000 + 1,
      dateTime: alarmDateTime,
      loopAudio: true,
      vibrate: true,
      volume: volume,
      assetAudioPath: 'assets/audio/tune.mp3',
      notificationTitle: "Xả nghỉ",
      notificationBody:
          "Chế độ tập trung đã kết thúc, bắt đầu xả nghỉ trong vòng $breakMins",
      enableNotificationOnKill: Platform.isIOS,
      fadeDuration: 5,
    );
    Alarm.set(alarmSettings: alarmSettings).then((res) async {
      if (res) {
        await prefs.setString('focusNext', jsonEncode(alarmSettings));
        setState(() {
          isRunning = true;
        });
      }
    });
  }

  onStop() async {
    final prefs = await SharedPreferences.getInstance();
    final focusNext = jsonDecode(prefs.getString('focusNext') ?? 'null');
    if (focusNext != null) {
      Alarm.stop(focusNext['id']).then((res) async {
        await prefs.remove('focusNext');
        setState(() {
          isRunning = false;
        });
      });
    }
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
                  Card(
                    color: ColorConstants.primaryBackground,
                    child: ListTile(
                      title: TextFormField(
                        controller: focusDurationController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Tập trung trong (phút)",
                        ),
                        onChanged: (value) {
                          setState(() {
                            if (value.isNotEmpty) {
                              focusMins = int.parse(value);
                            }
                            onUpdateSettingValue();
                          });
                        },
                      ),
                      leading: const Icon(Icons.adjust_rounded),
                      trailing: const Text("phút"),
                    ),
                  ),
                  Card(
                    color: ColorConstants.primaryBackground,
                    child: ListTile(
                      title: TextFormField(
                        controller: breakDurationController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Giải lao trong (phút)",
                        ),
                        onChanged: (value) {
                          setState(() {
                            if (value.isNotEmpty) {
                              breakMins = int.parse(value);
                            } else {
                              breakMins = 0;
                            }
                            onUpdateSettingValue();
                          });
                        },
                      ),
                      leading: const Icon(Icons.coffee_rounded),
                      trailing: const Text("phút"),
                    ),
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Tập trung trong $focusMins phút và giải lao trong $breakMins phút",
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Wrap(
                    alignment: WrapAlignment.spaceAround,
                    children: [
                      IconButton(
                        disabledColor: const Color(0xffe5e5e5),
                        onPressed: () {
                          !isRunning ? onStart() : null;
                        },
                        icon: const Icon(
                          Icons.play_circle_outline_rounded,
                          color: Color(0xff34a853),
                          size: 60,
                        ),
                      ),
                      IconButton(
                        disabledColor: const Color(0xffe5e5e5),
                        onPressed: () {
                          isRunning ? onStop() : null;
                        },
                        icon: const Icon(
                          Icons.stop_circle_outlined,
                          color: Color(0xffea4335),
                          size: 60,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
