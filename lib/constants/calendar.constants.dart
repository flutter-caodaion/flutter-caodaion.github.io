import 'dart:convert';

import 'package:calendar_view/calendar_view.dart';
import 'package:caodaion/constants/constants.dart';
import 'package:lunar/calendar/Lunar.dart';
import 'package:lunar/calendar/Solar.dart';

class CalendarEventsConstants {
  List<CalendarEventData> staticGlobalEvents(DateTime selectedTime) {
    List<CalendarEventData> responseStaticGlobalEvents = [];
    for (var item in rawStaticGlobalEvents) {
      Map<String, dynamic> responseData = {};
      if (item['title'] != null) {
        responseData['title'] = item['title'];
      }
      if (item['solar'] != null) {
        if (item['solar'].toString().contains('yearly')) {
          List<String> parts = item['solar'].toString().split("-");
          int year = selectedTime.year;
          int month = int.parse(parts[1]);
          int day = int.parse(parts[2]);
          responseData['date'] = DateTime.utc(year, month, day);
        }
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
        DateTime date = responseData['date'];
        responseStaticGlobalEvents.add(
          CalendarEventData(
            title: "${responseData['title']}",
            date: date,
            event: {"raw": item, "eventGroup": "staticGlobal"},
          ),
        );
      }
    }
    return responseStaticGlobalEvents;
  }

  List<Map<String, dynamic>> rawStaticGlobalEvents = [
    {
      "key": "dai-le-via-duc-chi-ton",
      "title": "ĐẠI LỄ VÍA ĐỨC CHÍ TÔN",
      "lunar": "yearly-01-09",
      "tuThoi": true
    },
    {
      "key": "dai-le-thuong-nguong",
      "title": "ĐẠI LỄ THƯỢNG NGƯƠNG",
      "lunar": "yearly-01-15",
      "tuThoi": true
    },
    {
      "key": "dai-le-via-duc-thai-thuong-lao-quan",
      "title": "ĐẠI LỄ VÍA ĐỨC THÁI THƯỢNG LÃO QUÂN",
      "lunar": "yearly-02-15",
      "tuThoi": true
    },
    {
      "key": "le-ky-niem-duc-giao-tong-dac-dao",
      "title": "LỄ KỶ NIỆM ĐỨC GIÁO TÔNG ĐẮC ĐẠO",
      "lunar": "yearly-02-25",
      "tuThoi": true
    },
    {
      "key": "le-ky-niem-duc-giao-tong-tho-phong",
      "title": "LỄ KỶ NIỆM ĐỨC GIÁO TÔNG THỌ PHONG",
      "lunar": "yearly-03-13",
      "tuThoi": true
    },
    {
      "key": "dai-le-via-duc-thich-ca-mau-ni-the-ton",
      "title": "ĐẠI LỄ VÍA ĐỨC THÍCH CA MÂU NI THẾ TÔN",
      "lunar": "yearly-04-08",
      "tuThoi": true
    },
    {
      "key": "dai-le-ky-niem-sinh-nhut-duc-giao-tong-nguyen-ngoc-tuong",
      "title": "ĐẠI LỄ KỶ NIỆM SINH NHỰT ĐỨC GIÁO TÔNG NGUYỄN NGỌC TƯƠNG",
      "lunar": "yearly-05-26",
      "tuThoi": true
    },
    {
      "key": "dai-le-trung-nguong",
      "title": "ĐẠI LỄ TRUNG NGƯƠNG",
      "lunar": "yearly-07-15",
      "tuThoi": true
    },
    {
      "key": "dai-le-via-duc-dieu-tri-kim-mau",
      "title": "ĐẠI LỄ VÍA ĐỨC DIÊU TRÌ KIM MẪU",
      "lunar": "yearly-08-15",
      "tuThoi": true
    },
    {
      "key": "dai-le-ha-nguong-va-ky-niem-khai-dao",
      "title": "ĐẠI LỄ HẠ NGƯƠNG và KỶ NIỆM KHAI ĐẠO",
      "lunar": "yearly-10-15",
      "tuThoi": true
    },
    {
      "key": "dai-le-ky-niem-sanh-nhut-duc-gia-to-giao-chu",
      "title": "ĐẠI LỄ KỶ NIỆM SANH NHỰT ĐỨC GIA TÔ GIÁO CHỦ",
      "solar": "yearly-12-25",
      "tuThoi": true
    },
    {
      "key": "tet-nguyen-dan-mung-1-dai-le-tan-nien",
      "title": "TẾT NGUYÊN ĐÁN | MÙNG 1 | ĐẠI LỄ TÂN NIÊN",
      "lunar": "yearly-01-01",
      "tuThoi": true
    },
    {
      "key": "tet-nguyen-dan-mung-2-dai-le-tan-nien",
      "title": "TẾT NGUYÊN ĐÁN | MÙNG 2 | ĐẠI LỄ TÂN NIÊN",
      "lunar": "yearly-01-02",
      "tuThoi": true
    },
    {
      "key": "tet-nguyen-dan-mung-3-dai-le-tan-nien",
      "title": "TẾT NGUYÊN ĐÁN | MÙNG 3 | ĐẠI LỄ TÂN NIÊN",
      "lunar": "yearly-01-03",
      "tuThoi": true
    },
  ];

  List<CalendarEventData> firstHaflEvents(DateTime selectedTime) {
    List<CalendarEventData> responseFirstHaflEvents = [];
    for (var i = 1; i <= 12; i++) {
      Lunar lunarFirst = Lunar.fromYmd(selectedTime.year, i, 1);
      Solar solarFirst = lunarFirst.getSolar();
      DateTime solarDateTimeFirst = DateTime(
          solarFirst.getYear(), solarFirst.getMonth(), solarFirst.getDay());
      responseFirstHaflEvents.add(
        CalendarEventData(
          title: 'Sóc nhựt tháng $i',
          date: solarDateTimeFirst,
          event: const {"eventGroup": "firstHalf"},
        ),
      );
      Lunar lunarHalf = Lunar.fromYmd(selectedTime.year, i, 15);
      Solar solarHalf = lunarHalf.getSolar();
      DateTime solarDateTimeHalf = DateTime(
          solarFirst.getYear(), solarHalf.getMonth(), solarHalf.getDay());
      responseFirstHaflEvents.add(
        CalendarEventData(
          title: 'Vọng nhựt tháng $i',
          date: solarDateTimeHalf,
          event: const {"eventGroup": "firstHalf"},
        ),
      );
    }
    return responseFirstHaflEvents;
  }

  List<CalendarEventData> humaneEvents(
      DateTime selectedTime, List<Map<String, dynamic>> rawHumaneEvents) {
    List<CalendarEventData> responseHumaneEvents = [];
    for (var item in rawHumaneEvents) {
      Map<String, dynamic> responseData = {};

      if (item['eventName'] != null) {
        responseData['title'] = item['eventName'];
      }

      if (item['data'] != null) {
        final data = json.decode(item['data']) as Map<dynamic, dynamic>;

        if (data['eventDate'] != null && data['eventMonth'] != null) {
          int year = selectedTime.year;
          int month = data['eventMonth'];
          int day = data['eventDate'];
          Lunar lunar = Lunar.fromYmd(year, month, day);
          Solar solar = lunar.getSolar();
          DateTime solarDateTime =
              DateTime(solar.getYear(), solar.getMonth(), solar.getDay());
          if (data['eventTime'] != null) {
            final List<Map<String, dynamic>> lunarTimes =
                TimeConstants.lunarTimes;
            final foundTime = lunarTimes.firstWhere(
              (lnt) => lnt['name'] == data['eventTime'],
              orElse: () => {},
            );

            if (foundTime.isNotEmpty) {
              final range = foundTime['range'];
              final startTime = DateTime(
                solar.getYear(),
                solar.getMonth(),
                solar.getDay(),
                int.parse(range.split('-')[0].split(':')[0]),
              );
              final endTime = DateTime(
                solar.getYear(),
                solar.getMonth(),
                solar.getDay(),
                int.parse(range.split('-')[1].split(':')[0]),
              );
              responseData['startTime'] = startTime;
              responseData['endTime'] = endTime;
            }
          }

          responseData['date'] = solarDateTime;
        }

        if (responseData['title'] != null && responseData['date'] != null) {
          DateTime date = responseData['date'];
          responseHumaneEvents.add(
            CalendarEventData(
              title: "${responseData['title']}",
              startTime: responseData['startTime'],
              endTime: responseData['endTime'],
              date: date,
              event: {"raw": item, "eventGroup": "humane"},
            ),
          );
        }
      }
    }
    return responseHumaneEvents;
  }
}
