import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConstants {
  static Color primaryColor = const Color(0xff577CFF);
  static Color primaryBackground = const Color(0xffeaf1fb);
  static Color primaryIndicatorBackground = const Color(0xffd3e3fd);
  static Color secondaryBackdround = const Color(0xfff6f8fc);
  static Color whiteBackdround = const Color(0xffffffff);
  static Color qrColor = const Color(0xffb53c34);
  static Color mapsColor = const Color(0xff8eea88);
  static Color libraryColor = const Color(0xffdf4b39);
  static Color calendarColor = const Color(0xff34A853);
  static Color tnhtColor = const Color(0xffFBBC05);
  static Color kinhColor = const Color(0xff000000);
  static Color chartColor = const Color(0xffFE777B);
  static Color clockColor = const Color(0xff454FE3);
  static Color textHorizontalDividerTextColor = const Color(0xff5F6368);
  static Color textHorizontalDividerDividerColor = const Color(0xffD9D9D9);
  static Color staticGlobalEventsColor = const Color(0xffeb4132);
  static Color firstHaftMonthEventsColor = const Color(0xff4285f4);
  static Color humaneEventsColor = const Color(0xfffbbc05);
}

class MapsConstants {
  static double caodaionLatitute = 11.9861833;
  static double caodaionLongitute = 108.4376802;
}

class TokenConstants {
  static String selectedFontSize = 'RO4ozil6DSgF';
  static String humane = 'FVrLJEg7Hb1to';
  static String selectedKinhListDisplayMode = 'WZx4XTK8eOYA';
  static String genimiAPIKey = 'AIzaSyBwKa0mxRUZ0AeaJZRC2pr5tP_aZ8SxVh8';
}

class TimeConstants {
  static List<Map<String, dynamic>> lunarTimes = [
    {
      "name": "TÝ",
      "range": "23:00-01:00",
    },
    {
      "name": "SỬU",
      "range": "01:00-03:00",
    },
    {
      "name": "DẦN",
      "range": "03:00-05:00",
    },
    {
      "name": "MẸO",
      "range": "05:00-07:00",
    },
    {
      "name": "THÌN",
      "range": "07:00-09:00",
    },
    {
      "name": "TỴ",
      "range": "09:00-11:00",
    },
    {
      "name": "NGỌ",
      "range": "11:00-13:00",
    },
    {
      "name": "MÙI",
      "range": "13:00-15:00",
    },
    {
      "name": "THÂN",
      "range": "15:00-17:00",
    },
    {
      "name": "DẬU",
      "range": "17:00-19:00",
    },
    {
      "name": "TUẤT",
      "range": "19:00-21:00",
    },
    {
      "name": "HỢI",
      "range": "21:00-23:00",
    },
  ];
}

class AlarmConstants {
  static String focusModeAlarmMessage = "Bắt đầu tập trung";
  static String breakModeAlarmMessage = "Xả nghỉ";
  static int defaultFocusMins = 30;
  static int defaultBreakMins = 5;
  static double defaultVolume = 1.0;
  static String defaultAudio =
      "assets/audio/mixkit-uplifting-bells-notification-938.wav";
  static List defaultLoopAlarms = [
    {
      "id": 5199,
      "dateTime":
          DateTime.now().copyWith(hour: 4, minute: 0, second: 0).toString(),
      "loopAudio": true,
      "vibrate": true,
      "volume": defaultVolume,
      "assetAudioPath": defaultAudio,
      "notificationTitle": "Thức dậy ⏰",
      "notificationBody":
          "Đến giờ thức dậy rồi 🕓⏰! Chúc bạn có một ngày mới vui vẻ hạnh phúc 😊!",
      "enableNotificationOnKill": false,
      "fadeDuration": 5.0,
      "selectedDays": [true, true, true, true, true, true, true],
      "active": true
    },
    {
      "id": 9931,
      "dateTime":
          DateTime.now().copyWith(hour: 23, minute: 0, second: 0).toString(),
      "loopAudio": true,
      "vibrate": true,
      "volume": defaultVolume,
      "assetAudioPath": defaultAudio,
      "notificationTitle": "Cúng thời TÝ 🐭",
      "notificationBody":
          "Đến giờ Cúng thời TÝ rồi 🕚🐭! Chúc bạn có một đàn cúng hiệu quả 😊!",
      "enableNotificationOnKill": false,
      "fadeDuration": 5.0,
      "selectedDays": [true, true, true, true, true, true, true],
      "active": true
    },
    {
      "id": 4884,
      "dateTime":
          DateTime.now().copyWith(hour: 5, minute: 0, second: 0).toString(),
      "loopAudio": true,
      "vibrate": true,
      "volume": defaultVolume,
      "assetAudioPath": defaultAudio,
      "notificationTitle": "Cúng thời MẸO 🐱",
      "notificationBody":
          "Đến giờ Cúng thời MẸO rồi 🕔🐱! Chúc bạn có một đàn cúng hiệu quả 😊!",
      "enableNotificationOnKill": false,
      "fadeDuration": 5.0,
      "selectedDays": [true, true, true, true, true, true, true],
      "active": true
    },
    {
      "id": 834,
      "dateTime":
          DateTime.now().copyWith(hour: 11, minute: 0, second: 0).toString(),
      "loopAudio": true,
      "vibrate": true,
      "volume": defaultVolume,
      "assetAudioPath": defaultAudio,
      "notificationTitle": "Cúng thời NGỌ 🐴",
      "notificationBody":
          "Đến giờ Cúng thời NGỌ rồi 🕚🐴! Chúc bạn có một đàn cúng hiệu quả 😊!",
      "enableNotificationOnKill": false,
      "fadeDuration": 5.0,
      "selectedDays": [true, true, true, true, true, true, true],
      "active": true
    },
    {
      "id": 292,
      "dateTime":
          DateTime.now().copyWith(hour: 17, minute: 0, second: 0).toString(),
      "loopAudio": true,
      "vibrate": true,
      "volume": defaultVolume,
      "assetAudioPath": defaultAudio,
      "notificationTitle": "Cúng thời DẬU 🐔",
      "notificationBody":
          "Đến giờ Cúng thời DẬU rồi 🕔🐔! Chúc bạn có một đàn cúng hiệu quả 😊!",
      "enableNotificationOnKill": false,
      "fadeDuration": 5.0,
      "selectedDays": [true, true, true, true, true, true, true],
      "active": true
    },
    {
      "id": 4654,
      "dateTime":
          DateTime.now().copyWith(hour: 19, minute: 30, second: 0).toString(),
      "loopAudio": true,
      "vibrate": true,
      "volume": defaultVolume,
      "assetAudioPath": defaultAudio,
      "notificationTitle": "Học Đạo 📑",
      "notificationBody":
          "Đến giờ Học Đạo rồi 📑! Chúc bạn có một buổi học tập hiệu quả 😊!",
      "enableNotificationOnKill": false,
      "fadeDuration": 5.0,
      "selectedDays": [true, true, true, true, true, true, true],
      "active": true
    },
    {
      "id": 9691,
      "dateTime":
          DateTime.now().copyWith(hour: 21, minute: 0, second: 0).toString(),
      "loopAudio": true,
      "vibrate": true,
      "volume": defaultVolume,
      "assetAudioPath": defaultAudio,
      "notificationTitle": "Đi ngủ 🥱",
      "notificationBody": "Đến giờ ngủ rồi 🕘🥱! Chúc bạn ngủ ngon 😴!",
      "enableNotificationOnKill": false,
      "fadeDuration": 5.0,
      "selectedDays": [true, true, true, true, true, true, true],
      "active": true
    },
  ];
}

class ContentContants {
  static double defaultFontSizeDesktop = 16.0;
  static double defaultFontSizeTablet = 14.0;
  static double defaultFontSizeMobile = 13.0;
}
