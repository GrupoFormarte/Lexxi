import 'package:flutter_test/flutter_test.dart';
import 'package:lexxi/src/providers/grado_provider.dart';

void main() {
  group('GradoProvider Tests', () {
    late GradoProvider gradoProvider;

    setUp(() {
      gradoProvider = GradoProvider();
    });

    test('GradoProvider debe inicializar con valores vacíos', () {
      // Assert
      expect(gradoProvider.grado, equals(''));
      expect(gradoProvider.idGrado, equals(''));
    });

    test('Setter de grado debe actualizar el valor y notificar listeners', () {
      // Arrange
      var notified = false;
      gradoProvider.addListener(() {
        notified = true;
      });

      // Act
      gradoProvider.grado = 'Grado 10';

      // Assert
      expect(gradoProvider.grado, equals('Grado 10'));
      expect(notified, isTrue);
    });

    test('Setter de idGrado debe actualizar el valor y notificar listeners', () {
      // Arrange
      var notified = false;
      gradoProvider.addListener(() {
        notified = true;
      });

      // Act
      gradoProvider.idGrado = '123';

      // Assert
      expect(gradoProvider.idGrado, equals('123'));
      expect(notified, isTrue);
    });

    test('Múltiples cambios deben notificar listeners cada vez', () {
      // Arrange
      var notificationCount = 0;
      gradoProvider.addListener(() {
        notificationCount++;
      });

      // Act
      gradoProvider.grado = 'Grado 10';
      gradoProvider.idGrado = '123';
      gradoProvider.grado = 'Grado 11';

      // Assert
      expect(notificationCount, equals(3));
      expect(gradoProvider.grado, equals('Grado 11'));
      expect(gradoProvider.idGrado, equals('123'));
    });

    test('Remover listener debe dejar de recibir notificaciones', () {
      // Arrange
      var notificationCount = 0;
      void listener() {
        notificationCount++;
      }

      gradoProvider.addListener(listener);
      gradoProvider.grado = 'Grado 10'; // Primera notificación

      // Act
      gradoProvider.removeListener(listener);
      gradoProvider.grado = 'Grado 11'; // No debe notificar

      // Assert
      expect(notificationCount, equals(1));
    });
  });
}
