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
        final CalendarEventData responseEvent = CalendarEventData(
            title: responseData['title'], date: responseData['date']);
        responseStaticGlobalEvents.add(responseEvent);
      }
    }
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
