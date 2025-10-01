import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Clase para manejar las variables de entorno de la aplicación
class EnvConfig {
  /// Carga las variables de entorno desde el archivo .env
  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }

  /// URL base principal de la API
  static String get baseUrl => dotenv.get('BASE_URL', fallback: 'https://app.formarte.co/api');

  /// URL base secundaria de la API
  static String get baseUrl2 => dotenv.get('BASE_URL_2', fallback: 'https://api.formarte.co/api');

  /// URL base para autenticación
  static String get authBaseUrl => dotenv.get('AUTH_BASE_URL', fallback: 'https://app.formarte.co');

  /// URL SAF para autenticación
  static String get authSafUrl => dotenv.get('AUTH_SAF_URL', fallback: 'https://stage-api.plataformapodium.com/api');

  /// Nombre de la aplicación
  static String get appName => dotenv.get('APP_NAME', fallback: 'Lexxi');

  /// Versión de la aplicación
  static String get appVersion => dotenv.get('APP_VERSION', fallback: '1.0.0');

  /// Entorno actual (production, development, staging)
  static String get environment => dotenv.get('ENVIRONMENT', fallback: 'production');

  /// Verifica si estamos en modo desarrollo
  static bool get isDevelopment => environment == 'development';

  /// Verifica si estamos en modo producción
  static bool get isProduction => environment == 'production';

  /// Verifica si estamos en modo staging
  static bool get isStaging => environment == 'staging';

  /// Imprime las configuraciones actuales (útil para debug)
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

  /// Obtiene una variable de entorno personalizada
  static String? get(String key, {String? fallback}) {
    return dotenv.get(key, fallback: fallback ?? '');
  }
}
