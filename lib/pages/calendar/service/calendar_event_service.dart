import 'package:caodaion/shared/services/xlsx_service.dart';
import 'package:excel/excel.dart';

class CalendarEventService {
  final String spreadSheetId =
      '2PACX-1vSRtHl3pP1qRsmnajbePLYP4lUj8YNdmCwZLqVoT9o2Q9KZ6eWbEU9J-xUYOiKDWsIkyJiCpcdj-8Tw';
    XlsxService xlsxService = XlsxService();

  Future<Map<String, dynamic>?> fetchThanhSo() async {
    XlsxService xlsxService = XlsxService();
    Excel? excel = await xlsxService.fetchAndReadXlsx(spreadSheetId);

    if (excel == null) {
      print('Failed to fetch and read XLSX file');
      return null;
    }

    Map<String, dynamic>? extractTableData(String tableName) {
      var table = excel.tables[tableName];
      if (table == null || table.rows.isEmpty) {
        print('$tableName is empty or null');
        return null;
      }

      // Extract keys from the first row
      final keys = table.rows[0].map((e) => e?.value.toString() ?? '').toList();

      // Convert subsequent rows to a list of maps
      final rows = table.rows.skip(1).map((row) {
        return Map<String, dynamic>.fromIterables(
          keys,
          row.map((e) => e?.value.toString() ?? '').toList(),
        );
      }).toList();

      return {'keys': keys, 'rows': rows};
    }

    var formData = extractTableData('Form Responses 1');
    var settingsData = extractTableData('centerDatabase');

    if (formData == null || settingsData == null) {
      return null;
    }

    final settingsKeys = (settingsData['keys'] as List<String>).where((item) => item.isNotEmpty).toList();
    final settingsRows = (settingsData['rows'] as List<Map<String, dynamic>>).where((item) => item.isNotEmpty).toList();

    if (settingsKeys.isEmpty || settingsRows.isEmpty) {
      print('Settings data is incomplete');
      return null;
    }

    final settingsMap = <String, dynamic>{};
    for (var row in settingsRows) {
      settingsMap[row['field'].toString()] = row['trigger'];
    }

    return {
      'data': formData['rows'],
      'settings': settingsMap,
    };
  }

  Future<Map<String, dynamic>?> fetchThanhSoEvent(id) async {
    Excel? excel = await xlsxService.fetchAndReadXlsx(id);
    if (excel == null) {
      print('Failed to fetch and read XLSX file');
      return null;
    }

    Map<String, dynamic>? extractTableData(String tableName) {
      var table = excel.tables[tableName];
      if (table == null || table.rows.isEmpty) {
        print('$tableName is empty or null');
        return null;
      }

      // Extract keys from the first row
      final keys = table.rows[0].map((e) => e?.value.toString() ?? '').toList();

      // Convert subsequent rows to a list of maps
      final rows = table.rows.skip(1).map((row) {
        return Map<String, dynamic>.fromIterables(
          keys,
          row.map((e) => e?.value.toString() ?? '').toList(),
        );
      }).toList();

      return {'keys': keys, 'rows': rows};
    }

    var formData = extractTableData('Form Responses 1');
    var settingsData = extractTableData('setting');

    if (formData == null || settingsData == null) {
      return null;
    }

    final settingsKeys = (settingsData['keys'] as List<String>).where((item) => item.isNotEmpty).toList();
    final settingsRows = (settingsData['rows'] as List<Map<String, dynamic>>).where((item) => item.isNotEmpty).toList();

    if (settingsKeys.isEmpty || settingsRows.isEmpty) {
      print('Settings data is incomplete');
      return null;
    }

    final settingsMap = <String, dynamic>{};
    for (var row in settingsRows) {
      settingsMap[row['field'].toString()] = row['trigger'];
    }

    return {
      'data': formData['rows'],
      'settings': settingsMap,
    };
  }
}
