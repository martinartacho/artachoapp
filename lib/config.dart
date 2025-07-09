/* class Config {
  static const String baseUrl = "https://artacho.org/api";
}
 */
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String get baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://fallback.url/api';
}
