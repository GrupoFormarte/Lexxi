import 'package:flutter_test/flutter_test.dart';
import 'package:lexxi/config/env_config.dart';

void main() {
  setUpAll(() async {
    // Cargar variables de entorno antes de las pruebas
    TestWidgetsFlutterBinding.ensureInitialized();
    await EnvConfig.load();
  });

  group('EnvConfig Tests', () {
    test('debe cargar BASE_URL correctamente', () {
      final baseUrl = EnvConfig.baseUrl;
      expect(baseUrl, isNotEmpty);
      expect(baseUrl, contains('api'));
    });

    test('debe cargar BASE_URL_2 correctamente', () {
      final baseUrl2 = EnvConfig.baseUrl2;
      expect(baseUrl2, isNotEmpty);
      expect(baseUrl2, contains('api'));
    });

    test('debe cargar APP_NAME correctamente', () {
      final appName = EnvConfig.appName;
      expect(appName, isNotEmpty);
    });

    test('debe cargar APP_VERSION correctamente', () {
      final version = EnvConfig.appVersion;
      expect(version, isNotEmpty);
    });

    test('debe cargar ENVIRONMENT correctamente', () {
      final env = EnvConfig.environment;
      expect(env, isNotEmpty);
      expect(env, isIn(['production', 'development', 'staging']));
    });

    test('isDevelopment debe ser booleano', () {
      final isDev = EnvConfig.isDevelopment;
      expect(isDev, isA<bool>());
    });

    test('isProduction debe ser booleano', () {
      final isProd = EnvConfig.isProduction;
      expect(isProd, isA<bool>());
    });

    test('isStaging debe ser booleano', () {
      final isStaging = EnvConfig.isStaging;
      expect(isStaging, isA<bool>());
    });

    test('get debe retornar valor con fallback', () {
      final value = EnvConfig.get('NON_EXISTENT_KEY', fallback: 'default');
      expect(value, equals('default'));
    });

    test('printConfig no debe lanzar error', () {
      expect(() => EnvConfig.printConfig(), returnsNormally);
    });
  });
}
