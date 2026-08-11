import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnvConfig {
  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }

  static String get baseUrl =>
      dotenv.get('BASE_URL', fallback: 'https://app.formarte.co/api');

  static String get baseUrl2 =>
      dotenv.get('BASE_URL_2', fallback: 'https://api.formarte.co/api');

  static String get authBaseUrl =>
      dotenv.get('AUTH_BASE_URL', fallback: 'https://app.formarte.co');

  static String get authSafUrl => dotenv.get(
    'AUTH_SAF_URL',
    fallback: 'https://stage-api.plataformapodium.com/api',
  );

  static String get appName => dotenv.get('APP_NAME', fallback: 'Lexxi');

  static String get appVersion => dotenv.get('APP_VERSION', fallback: '1.0.0');

  static String get environment =>
      dotenv.get('ENVIRONMENT', fallback: 'production');

  static bool get isDevelopment => environment == 'development';

  static bool get isProduction => environment == 'production';

  static bool get isStaging => environment == 'staging';

  static const String _tokenKey = 'token_for_mongo';
  static String? _tokenForMongo;
  static String get environmentName {
    if (isDevelopment) return 'development';
    if (isProduction) return 'production';
    return 'staging';
  }

  static Future<void> setTokenForMongo(String? token) async {
    _tokenForMongo = token;

    // Persist to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    if (token != null && token.isNotEmpty) {
      await prefs.setString(_tokenKey, token);
    } else {
      await prefs.remove(_tokenKey);
    }
  }

  static Future<void> loadTokenForMongo() async {
    final prefs = await SharedPreferences.getInstance();
    _tokenForMongo = prefs.getString(_tokenKey);
  }

  static Map<String, String> get defaultHeaders {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'User-Agent': 'FormArte-App/$environmentName',
    };

    if (_tokenForMongo != null && _tokenForMongo!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_tokenForMongo';
    }

    return headers;
  }

  static void printConfig() {
    print('=== EnvConfig ===');
    print('Environment: $environment');
    print('Base URL: $baseUrl');
    print('Base URL 2: $baseUrl2');
    print('Auth Base URL: $authBaseUrl');
    print('Auth SAF URL: $authSafUrl');
    print('App Name: $appName');
    print('App Version: $appVersion');
    print('=================');
  }

  static String? get(String key, {String? fallback}) {
    return dotenv.get(key, fallback: fallback ?? '');
  }
}
