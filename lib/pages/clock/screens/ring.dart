import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_tts/flutter_tts.dart';
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

  late FlutterTts flutterTts;
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    initializeTTS();
    getRingData();
  }

  Future<void> initializeTTS() async {
    flutterTts = FlutterTts();

    // Set TTS parameters
    await flutterTts.setLanguage("vi-VN");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    // Register event listeners
    flutterTts.setStartHandler(() {
      setState(() {
        isSpeaking = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });

    flutterTts.setPauseHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        isSpeaking = false;
      });
      print("Error: $msg");
    });
    flutterTts.setContinueHandler(() {
      setState(() {
        isSpeaking = true;
      });
      flutterTts.continueHandler = () {
        print("Resumed TTS");
        log("Resumed TTS $isSpeaking");
      };
    });
  }

  speakSpecify() {

  }

  void _speak(text) async {
    text = text
        .replaceAll("&nbsp;", "")
        .replaceAll("#", "")
        .replaceAll("---", "")
        .replaceAll("<center>", "")
        .replaceAll(">", "")
        .replaceAll("</", "")
        .replaceAll("center", "")
        .replaceAll("</center>", "")
        .replaceAll("Décembre", "Đì-xem-bờ")
        .replaceAll("NOEL", "Nô-en")
        .replaceAll("Europe", "Ơ-rốp")
        .replaceAll("*", "");
    await flutterTts.speak(text);
    setState(() {
      isSpeaking = true;
    });
  }

  void _pause() async {
    await flutterTts.pause();
    setState(() {
      isSpeaking = false;
    });
  }

  void _stop() async {
    await flutterTts.stop();
    if (mounted) {
      setState(() {
        isSpeaking = false;
      });
    }
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

  _onStopAlarm() {
    speakSpecify();
    Alarm.stop(int.parse(widget.id)).then((_) => context.go('/dong-ho'));
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
            if (alarmSettings.notificationBody != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Markdown(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  data: alarmSettings.notificationBody,
                  styleSheet: MarkdownStyleSheet(
                    textAlign: WrapAlignment.center,
                  ),
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
                    _onStopAlarm();
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
