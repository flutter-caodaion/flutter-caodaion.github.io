import 'package:excel/excel.dart';
import 'package:http/http.dart' as http;

class XlsxService {
  XlsxService();

  Future<Excel?> fetchAndReadXlsx(spreadSheetId) async {
    final uri = "https://docs.google.com/spreadsheets/d/e/$spreadSheetId/pub?output=xlsx";
    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      return Excel.decodeBytes(bytes);
    } else {
      print('Failed to fetch XLSX file: ${response.statusCode}');
      return null;
    }
  }
}