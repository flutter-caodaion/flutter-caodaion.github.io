String createSlug(String input) {
  // Bước 1: Loại bỏ dấu tiếng Việt
  final vietnameseToLatinMap = {
    'À': 'A',
    'Á': 'A',
    'Â': 'A',
    'Ã': 'A',
    'È': 'E',
    'É': 'E',
    'Ê': 'E',
    'Ì': 'I',
    'Í': 'I',
    'Ò': 'O',
    'Ó': 'O',
    'Ô': 'O',
    'Õ': 'O',
    'Ù': 'U',
    'Ú': 'U',
    'Ý': 'Y',
    'à': 'a',
    'á': 'a',
    'â': 'a',
    'ã': 'a',
    'è': 'e',
    'é': 'e',
    'ê': 'e',
    'ì': 'i',
    'í': 'i',
    'ò': 'o',
    'ó': 'o',
    'ô': 'o',
    'õ': 'o',
    'ù': 'u',
    'ú': 'u',
    'ý': 'y',
    'Ă': 'A',
    'ă': 'a',
    'Đ': 'D',
    'đ': 'd',
    'Ĩ': 'I',
    'ĩ': 'i',
    'Ũ': 'U',
    'ũ': 'u',
    'Ơ': 'O',
    'ơ': 'o',
    'Ư': 'U',
    'ư': 'u',
    'Ạ': 'A',
    'ạ': 'a',
    'Ả': 'A',
    'ả': 'a',
    'Ấ': 'A',
    'ấ': 'a',
    'Ầ': 'A',
    'ầ': 'a',
    'Ẩ': 'A',
    'ẩ': 'a',
    'Ẫ': 'A',
    'ẫ': 'a',
    'Ậ': 'A',
    'ậ': 'a',
    'Ắ': 'A',
    'ắ': 'a',
    'Ằ': 'A',
    'ằ': 'a',
    'Ẳ': 'A',
    'ẳ': 'a',
    'Ẵ': 'A',
    'ẵ': 'a',
    'Ặ': 'A',
    'ặ': 'a',
    'Ẹ': 'E',
    'ẹ': 'e',
    'Ẻ': 'E',
    'ẻ': 'e',
    'Ẽ': 'E',
    'ẽ': 'e',
    'Ế': 'E',
    'ế': 'e',
    'Ề': 'E',
    'ề': 'e',
    'Ể': 'E',
    'ể': 'e',
    'Ễ': 'E',
    'ễ': 'e',
    'Ệ': 'E',
    'ệ': 'e',
    'Ỉ': 'I',
    'ỉ': 'i',
    'Ị': 'I',
    'ị': 'i',
    'Ọ': 'O',
    'ọ': 'o',
    'Ỏ': 'O',
    'ỏ': 'o',
    'Ố': 'O',
    'ố': 'o',
    'Ồ': 'O',
    'ồ': 'o',
    'Ổ': 'O',
    'ổ': 'o',
    'Ỗ': 'O',
    'ỗ': 'o',
    'Ộ': 'O',
    'ộ': 'o',
    'Ớ': 'O',
    'ớ': 'o',
    'Ờ': 'O',
    'ờ': 'o',
    'Ở': 'O',
    'ở': 'o',
    'Ỡ': 'O',
    'ỡ': 'o',
    'Ợ': 'O',
    'ợ': 'o',
    'Ụ': 'U',
    'ụ': 'u',
    'Ủ': 'U',
    'ủ': 'u',
    'Ứ': 'U',
    'ứ': 'u',
    'Ừ': 'U',
    'ừ': 'u',
    'Ử': 'U',
    'ử': 'u',
    'Ữ': 'U',
    'ữ': 'u',
    'Ự': 'U',
    'ự': 'u'
  };

  String normalized = input;
  vietnameseToLatinMap.forEach((key, value) {
    normalized = normalized.replaceAll(key, value);
  });

  // Bước 2: Loại bỏ ký tự đặc biệt
  normalized = normalized.replaceAll(RegExp(r'[^\w\s-]'), ' ');

  // Bước 3: Thay khoảng trắng bằng dấu gạch ngang
  normalized = normalized.replaceAll(RegExp(r'\s+'), '-');

  // Bước 4: Chuyển chuỗi sang chữ thường
  normalized = normalized.toLowerCase();

  return normalized;
}
