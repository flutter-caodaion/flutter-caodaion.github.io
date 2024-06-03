import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AlarmRingScreen extends StatefulWidget {
  const AlarmRingScreen({required this.id, super.key});

  final String id;

  @override
  State<AlarmRingScreen> createState() => _AlarmRingScreenState();
}

class _AlarmRingScreenState extends State<AlarmRingScreen> {
  late List<AlarmSettings> alarms;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'You alarm (${widget.id}) is ringing...',
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
                //     'Snooze',
                //     style: Theme.of(context).textTheme.titleLarge,
                //   ),
                // ),
                RawMaterialButton(
                  onPressed: () {
                    Alarm.stop(int.parse(widget.id))
                        .then((_) => context.go('/dong-ho'));
                  },
                  child: Text(
                    'Stop',
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
