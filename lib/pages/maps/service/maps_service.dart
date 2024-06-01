import 'package:caodaion/shared/services/xlsx_service.dart';
import 'package:excel/excel.dart';

class MapsService {
  final String spreadSheetId =
      '2PACX-1vSt4mbrK2ibNf3z6WBa_zRamMdHh9XlBNDqeO3Lx4aqbaSVyyGBZ3jJ6hi4zZJbrkbHIu-k1JD2_Qmc';
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

    var formData = extractTableData('maps');

    if (formData == null) {
      return null;
    }

    return {
      'data': formData['rows']
    };
  }
}
