
import 'dart:convert';

class ObjectMapHelper {

  Map<String, dynamic>? decodeJsonMapOrNull(String body) {
    final decoded = json.decode(body);

    if (decoded == null) return null;
    if (decoded is Map<String, dynamic>) return decoded;

    throw const FormatException('Invalid JSON format: expected object');
  }

  List<Map<String, dynamic>> decodeJsonListOrEmpty(String body) {
    final decoded = json.decode(body);

    if (decoded == null) return <Map<String, dynamic>>[];
    if (decoded is List) {
      return decoded.cast<Map<String, dynamic>>();
    }

    throw const FormatException('Invalid JSON format: expected array');
  }
}