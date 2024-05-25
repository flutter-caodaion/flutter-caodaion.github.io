import 'package:calendar_view/calendar_view.dart';
import 'package:lunar/calendar/Lunar.dart';
import 'package:lunar/calendar/Solar.dart';

class CalendarEventsConstants {
  List<CalendarEventData> staticGlobalEvents(selectedTime) {
    List<CalendarEventData> responseStaticGlobalEvents = [];
    for (var item in rawStaticGlobalEvents) {
      Map<dynamic, dynamic> responseData = {};
      if (item['title'] != null) {
        responseData['title'] = item['title'];
      }
      if (item['solar'] != null) {
        responseData['date'] = item['date'];
      }
      if (item['lunar'] != null) {
        if (item['lunar'].toString().contains('yearly')) {
          List<String> parts = item['lunar'].toString().split("-");
          int year = selectedTime.year;
          int month = int.parse(parts[1]);
          int day = int.parse(parts[2]);
          Lunar lunar = Lunar.fromYmd(year, month, day);
          Solar solar = lunar.getSolar();
          DateTime solarDateTime =
              DateTime(solar.getYear(), solar.getMonth(), solar.getDay());
          responseData['date'] = solarDateTime;
        }
      }
      if (responseData['title'] != null && responseData['date'] != null) {
        if (item['tuThoi'] != null && item['tuThoi'] == true) {
          final DateTime date = responseData['date'];
          final DateTime fromDate = date.subtract(const Duration(days: 1));
          final CalendarEventData responseEventTY = CalendarEventData(
              title: "Thời TÝ ${responseData['title']}",
              date: fromDate,
              startTime: DateTime.utc(
                  fromDate.year, fromDate.month, fromDate.day, 23, 0, 0),
              endTime: DateTime.utc(date.year, date.month, date.day, 1, 0, 0),
              endDate: date,
              description: responseData['title'],
              event: {"raw": item, "eventGroup": "staticGlobal"});
          responseStaticGlobalEvents.add(responseEventTY);
          final CalendarEventData responseEventMEO = CalendarEventData(
              title: "Thời MẸO ${responseData['title']}",
              date: date,
              startTime: DateTime.utc(date.year, date.month, date.day, 5, 0, 0),
              endTime: DateTime.utc(date.year, date.month, date.day, 7, 0, 0),
              event: {"raw": item, "eventGroup": "staticGlobal"});
          responseStaticGlobalEvents.add(responseEventMEO);
          final CalendarEventData responseEventNGO = CalendarEventData(
              title: "Thời NGỌ ${responseData['title']}",
              date: date,
              startTime:
                  DateTime.utc(date.year, date.month, date.day, 11, 0, 0),
              endTime: DateTime.utc(date.year, date.month, date.day, 13, 0, 0),
              event: {"raw": item, "eventGroup": "staticGlobal"});
          responseStaticGlobalEvents.add(responseEventNGO);
          final CalendarEventData responseEventDAU = CalendarEventData(
              title: "Thời DẬU ${responseData['title']}",
              date: date,
              startTime:
                  DateTime.utc(date.year, date.month, date.day, 17, 0, 0),
              endTime: DateTime.utc(date.year, date.month, date.day, 19, 0, 0),
              event: {"raw": item, "eventGroup": "staticGlobal"});
          responseStaticGlobalEvents.add(responseEventDAU);
        } else {
          final CalendarEventData responseEvent = CalendarEventData(
              title: responseData['title'],
              date: responseData['date'],
              event: {"raw": item, "eventGroup": "staticGlobal"});
          responseStaticGlobalEvents.add(responseEvent);
        }
      }
    }
    // print(responseStaticGlobalEvents);
    return responseStaticGlobalEvents;
  }

  List<Map<dynamic, dynamic>> rawStaticGlobalEvents = [
    {
      "key": "dai-le-via-duc-chi-ton",
      "title": "ĐẠI LỄ VÍA ĐỨC CHÍ TÔN",
      "lunar": "yearly-01-09",
      "tuThoi": true
    }
  ];
}
