import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get fileName =>
      kReleaseMode ? "assets/env/.prod.env" : "assets/env/.dev.env";
  static String get apiUrl => dotenv.env['API_URL'] ?? 'http://localhost:3000/';
}
