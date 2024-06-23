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
  static String selectedKinhFontSize = 'RO4ozil6DSgF';
  static String selectedTNHTFontSize = 'Z2cSkgtdaVtg';
  static String humane = 'FVrLJEg7Hb1to';
  static String selectedKinhListDisplayMode = 'WZx4XTK8eOYA';
  static String selectedTNHTTableContentDisplayMode = '31G3lBhXQDZ9';
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

class ContentContants {
  static double defaultFontSizeDesktop = 16.0;
  static double defaultFontSizeTablet = 14.0;
  static double defaultFontSizeMobile = 13.0;
}
