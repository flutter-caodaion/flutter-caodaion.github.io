import 'package:caodaion/shared/services/xlsx_service.dart';
import 'package:excel/excel.dart';

class LibraryService {
  final String spreadSheetId =
      '2PACX-1vTsCA5rwuatpvDRWVRURaUJX74WoYG22AWBFsDN1J55IEZYTlYC4xsNdgHR6NDvdTzbMmWIRNKdxE23';
  XlsxService xlsxService = XlsxService();

  Future<Map<String, dynamic>?> fetchBooks() async {
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

      // Convert subsequent rows to a list of library
      final rows = table.rows.skip(1).map((row) {
        return Map<String, dynamic>.fromIterables(
          keys,
          row.map((e) => e?.value.toString() ?? '').toList(),
        );
      }).toList();

      return {'keys': keys, 'rows': rows};
    }

    var formData = extractTableData('library');

    if (formData == null) {
      return null;
    }

    return {'data': formData['rows']};
  }
}
