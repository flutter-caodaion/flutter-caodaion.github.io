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
  int focusMins = AlarmConstants.defaultFocusMins; // default 30
  int breakMins = AlarmConstants.defaultBreakMins; // default 5
  int remainingTime = 0;
  double volume = 1.0; // default 1.0
  bool isRunning = false;
  bool isFocusMode = false;
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

  updateFocusSetting() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('focusMins', focusMins);
    await prefs.setInt('breakMins', breakMins);
    focusDurationController.text = focusMins.toString();
    breakDurationController.text = breakMins.toString();
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

        remainingTime = (!isFocusMode ? focusMins : breakMins) * 60;
        if (focusNext['notificationTitle'] ==
            AlarmConstants.breakModeAlarmMessage) {
          if (DateTime.fromMicrosecondsSinceEpoch(sharedFocusNext['dateTime'])
              .isAfter(DateTime.now())) {
            _onStartFocus();
          } else {
            _onStartBreak();
          }
        } else {
          if (DateTime.fromMicrosecondsSinceEpoch(sharedFocusNext['dateTime'])
              .isAfter(DateTime.now())) {
            _onStartBreak();
          } else {
            _onStartFocus();
          }
        }
      });
    }
  }

  loadInitValue() async {
    final prefs = await SharedPreferences.getInstance();
    var sharedfocusMins = prefs.getInt('focusMins');
    var sharedbreakMins = prefs.getInt('breakMins');
    if (sharedfocusMins != null) {
      setState(() {
        focusMins = sharedfocusMins;
        focusDurationController.text = focusMins.toString();
      });
    } else {
      focusDurationController.text = focusMins.toString();
    }
    if (sharedbreakMins != null) {
      setState(() {
        breakMins = sharedbreakMins;
        breakDurationController.text = breakMins.toString();
      });
    } else {
      breakDurationController.text = breakMins.toString();
    }
  }

  void _onStartFocus() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmDateTime = DateTime.now().add(Duration(
        minutes: focusMins != 0 ? focusMins : AlarmConstants.defaultFocusMins));
    final alarmSettings = AlarmSettings(
      id: DateTime.now().millisecondsSinceEpoch % 10000 + 1,
      dateTime: alarmDateTime,
      loopAudio: true,
      vibrate: true,
      volume: volume,
      assetAudioPath:
          'assets/audio/mixkit-uplifting-bells-notification-938.wav',
      notificationTitle: AlarmConstants.breakModeAlarmMessage,
      notificationBody:
          "Chế độ tập trung đã kết thúc, bắt đầu xả nghỉ trong vòng ${breakMins != 0 ? breakMins : AlarmConstants.defaultBreakMins} phút",
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
            isRunning = true;
            isFocusMode = false;
            _startTimer();
          });
        }
      });
    } else {
      setState(() {
        remainingTime =
            DateTime.fromMicrosecondsSinceEpoch(focusNext['dateTime'])
                .difference(DateTime.now())
                .inSeconds;
        isRunning = true;
        isFocusMode = false;
        _startTimer();
      });
    }
  }

  _onStartBreak() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmDateTime = DateTime.now().add(
      Duration(
        minutes: breakMins != 0 ? breakMins : AlarmConstants.defaultBreakMins,
      ),
    );
    final alarmSettings = AlarmSettings(
      id: DateTime.now().millisecondsSinceEpoch % 10000 + 1,
      dateTime: alarmDateTime,
      loopAudio: true,
      vibrate: true,
      volume: volume,
      assetAudioPath: 'assets/audio/mixkit-happy-bells-notification-937.wav',
      notificationTitle: AlarmConstants.focusModeAlarmMessage,
      notificationBody:
          "Bắt đầu tập trung trong vòng ${focusMins != 0 ? focusMins : AlarmConstants.defaultFocusMins} phút",
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
            isRunning = true;
            isFocusMode = true;
            _startTimer();
          });
        }
      });
    } else {
      setState(() {
        remainingTime =
            DateTime.fromMicrosecondsSinceEpoch(focusNext['dateTime'])
                .difference(DateTime.now())
                .inSeconds;
        isRunning = true;
        isFocusMode = true;
        _startTimer();
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
          remainingTime = focusMins * 60;
          isRunning = false;
          isFocusMode = false;
          timer?.cancel();
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
        }
      });
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
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
                          enabled: !isRunning,
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
                              } else {
                                focusMins = 0;
                              }
                              updateFocusSetting();
                            });
                          },
                        ),
                        leading: IconButton(
                            onPressed: isRunning
                                ? null
                                : () => {
                                      setState(() {
                                        focusMins =
                                            AlarmConstants.defaultFocusMins;
                                        updateFocusSetting();
                                      })
                                    },
                            icon: const Icon(Icons.adjust_rounded)),
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
                          enabled: !isRunning,
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
                              updateFocusSetting();
                            });
                          },
                        ),
                        leading: IconButton(
                            onPressed: isRunning
                                ? null
                                : () => {
                                      setState(() {
                                        breakMins =
                                            AlarmConstants.defaultBreakMins;
                                        updateFocusSetting();
                                      })
                                    },
                            icon: const Icon(Icons.coffee_rounded)),
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
                  Icon(
                    !isFocusMode ? Icons.adjust_rounded : Icons.coffee,
                    size: 50,
                    color: !isFocusMode
                        ? ColorConstants.clockColor
                        : const Color(0xfffbbc05),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      !isFocusMode ? 'Chế độ tập trung' : 'Xả nghỉ',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 30),
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
                          value: remainingTime > 0
                              ? (remainingTime /
                                  (!isFocusMode
                                      ? focusMins * 60
                                      : breakMins * 60))
                              : 0,
                          minHeight: 32,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            !isFocusMode
                                ? ColorConstants.clockColor
                                : const Color(0xfffbbc05),
                          ),
                          backgroundColor: ColorConstants.primaryBackground,
                          borderRadius: BorderRadius.circular(20),
                        );
                      },
                    ),
                  ),
                  Text(
                    'Còn lại: ${formatTime(remainingTime)}',
                    style: const TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
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
