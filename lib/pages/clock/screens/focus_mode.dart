import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:caodaion/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  int remainingTime = 0;
  double volume = 1; // default 1.0
  bool isRunning = false;
  bool isFocusMode = true;
  late List<AlarmSettings> alarms;
  late dynamic focusNext = null;
  Timer? timer;

  @override
  void initState() {
    loadInitValue();
    loadNextFocus();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FocusMode oldWidget) {
    super.didUpdateWidget(oldWidget);
    loadInitValue();
    loadNextFocus();
  }

  loadNextFocus() async {
    final prefs = await SharedPreferences.getInstance();
    var sharedFocusNext = jsonDecode(prefs.getString('focusNext') ?? "null");
    setState(() {
      focusNext = null;
    });
    if (sharedFocusNext != null) {
      setState(() {
        focusNext = sharedFocusNext;
        if (focusNext['notificationTitle'] ==
            AlarmConstants.breakModeAlarmMessage) {
          _onStartBreak();
        } else {
          _onStartFocus();
        }
      });
    }
  }

  loadInitValue() {
    focusDurationController.text = focusMins.toString();
    breakDurationController.text = breakMins.toString();
  }

  void _onStartFocus() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmDateTime = DateTime.now().add(Duration(minutes: focusMins));
    final alarmSettings = AlarmSettings(
      id: DateTime.now().millisecondsSinceEpoch % 10000 + 1,
      dateTime: alarmDateTime,
      loopAudio: true,
      vibrate: true,
      volume: volume,
      assetAudioPath: 'assets/audio/bell-sound-193696.mp3',
      notificationTitle: AlarmConstants.breakModeAlarmMessage,
      notificationBody:
          "Chế độ tập trung đã kết thúc, bắt đầu xả nghỉ trong vòng $breakMins phút",
      enableNotificationOnKill: Platform.isIOS,
      fadeDuration: 5,
    );
    if (focusNext == null ||
        DateTime.fromMicrosecondsSinceEpoch(focusNext['dateTime'])
            .isBefore(DateTime.now())) {
      Alarm.set(alarmSettings: alarmSettings).then((res) async {
        if (res) {
          await prefs.setString('focusNext', jsonEncode(alarmSettings));
          setState(() {
            remainingTime = 0;
            if (focusNext != null) {
              remainingTime =
                  DateTime.fromMicrosecondsSinceEpoch(focusNext['dateTime'])
                      .difference(DateTime.now())
                      .inSeconds;
            }
            _startTimer();
            isRunning = true;
            isFocusMode = false;
          });
        }
      });
    } else {
      setState(() {
        remainingTime =
            DateTime.fromMicrosecondsSinceEpoch(focusNext['dateTime'])
                .difference(DateTime.now())
                .inSeconds;
        _startTimer();
        isRunning = true;
        isFocusMode = false;
      });
    }
  }

  _onStartBreak() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmDateTime = DateTime.now().add(Duration(minutes: breakMins));
    final alarmSettings = AlarmSettings(
      id: DateTime.now().millisecondsSinceEpoch % 10000 + 1,
      dateTime: alarmDateTime,
      loopAudio: true,
      vibrate: true,
      volume: volume,
      assetAudioPath: 'assets/audio/bell-chord1-83260.mp3',
      notificationTitle: AlarmConstants.focusModeAlarmMessage,
      notificationBody: "Bắt đầu tập trung trong vòng $focusMins phút",
      enableNotificationOnKill: Platform.isIOS,
      fadeDuration: 5,
    );
    if (focusNext == null ||
        DateTime.fromMicrosecondsSinceEpoch(focusNext['dateTime'])
            .isBefore(DateTime.now())) {
      Alarm.set(alarmSettings: alarmSettings).then((res) async {
        if (res) {
          await prefs.setString('focusNext', jsonEncode(alarmSettings));
          setState(() {
            remainingTime = 0;
            if (focusNext != null) {
              remainingTime =
                  DateTime.fromMicrosecondsSinceEpoch(focusNext['dateTime'])
                      .difference(DateTime.now())
                      .inSeconds;
            }
            _startTimer();
            isRunning = true;
            isFocusMode = true;
          });
        }
      });
    } else {
      setState(() {
        remainingTime =
            DateTime.fromMicrosecondsSinceEpoch(focusNext['dateTime'])
                .difference(DateTime.now())
                .inSeconds;
        _startTimer();
        isRunning = true;
        isFocusMode = true;
      });
    }
  }

  void _onStop() async {
    final prefs = await SharedPreferences.getInstance();
    final focusNext = jsonDecode(prefs.getString('focusNext') ?? 'null');
    if (focusNext != null) {
      Alarm.stop(focusNext['id']).then((res) async {
        await prefs.remove('focusNext');
        setState(() {
          remainingTime = 0;
          timer?.cancel();
          isRunning = false;
          isFocusMode = false;
        });
      });
    }
  }

  void _startTimer() {
    setState(() {
      isRunning = true;
      if (remainingTime <= 0) {
        remainingTime = (!isFocusMode ? focusMins : breakMins) * 60;
      }
    });

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          timer.cancel();
          isRunning = false;
          remainingTime = (!isFocusMode ? focusMins : breakMins) * 60;
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
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
                            });
                          },
                        ),
                        leading: const Icon(Icons.adjust_rounded),
                        trailing: const Text("phút"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
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
                            });
                          },
                        ),
                        leading: const Icon(Icons.coffee_rounded),
                        trailing: const Text("phút"),
                      ),
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
                        color: const Color(0xff34a853),
                        onPressed: isRunning ? null : _onStartFocus,
                        icon: const Icon(
                          Icons.play_circle_outline_rounded,
                          size: 60,
                        ),
                      ),
                      IconButton(
                        disabledColor: const Color(0xffe5e5e5),
                        color: const Color(0xffea4335),
                        onPressed: !isRunning ? null : _onStop,
                        icon: const Icon(
                          Icons.stop_circle_outlined,
                          size: 60,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      !isFocusMode ? 'Chế độ tập trung' : 'Xả nghỉ',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: 0,
                        end: remainingTime > 0
                            ? (remainingTime /
                                (!isFocusMode
                                    ? focusMins * 60
                                    : breakMins * 60))
                            : 0,
                      ),
                      duration: const Duration(seconds: 1),
                      builder: (context, value, child) {
                        return LinearProgressIndicator(
                          value: value,
                          minHeight: 32,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            ColorConstants.clockColor,
                          ),
                          backgroundColor: ColorConstants.primaryBackground,
                          borderRadius: BorderRadius.circular(20),
                        );
                      },
                    ),
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
