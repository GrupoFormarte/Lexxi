import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexxi/domain/auth/model/recordatorio_personalizado.dart';

void main() {
  group('RecordatorioPersonalizado Tests', () {
    test('fromJson debe crear instancia válida', () {
      // Arrange
      final json = {
        'status': true,
        'time': '9:30 AM',
      };

      // Act
      final recordatorio = RecordatorioPersonalizado.fromJson(json);

      // Assert
      expect(recordatorio.status, true);
      expect(recordatorio.time, '9:30 AM');
    });

    test('toJson debe convertir correctamente', () {
      // Arrange
      final recordatorio = RecordatorioPersonalizado(
        status: true,
        time: '8:00 PM',
      );

      // Act
      final json = recordatorio.toJson();

      // Assert
      expect(json['status'], true);
      expect(json['time'], '8:00 PM');
    });

    test('debe crear instancia con valores por defecto', () {
      // Arrange & Act
      final recordatorio = RecordatorioPersonalizado();

      // Assert
      expect(recordatorio.status, false);
      expect(recordatorio.time, '10:00 PM');
    });

    test('formatTimeOfDay debe formatear correctamente', () {
      // Arrange
      final recordatorio = RecordatorioPersonalizado();
      final timeOfDay = TimeOfDay(hour: 14, minute: 30);

      // Act
      final formatted = recordatorio.formatTimeOfDay(timeOfDay);

      // Assert
      expect(formatted, contains('2:30'));
      expect(formatted, contains('PM'));
    });

    test('parseTimeOfDay debe parsear correctamente', () {
      // Arrange
      final recordatorio = RecordatorioPersonalizado(time: '9:30 AM');

      // Act
      final timeOfDay = recordatorio.parseTimeOfDay();

      // Assert
      expect(timeOfDay.hour, 9);
      expect(timeOfDay.minute, 30);
    });
  });

  group('NotificationConfig Tests', () {
    test('fromJson debe crear instancia válida', () {
      // Arrange
      final json = {
        'sonido': true,
        'recordatorio': false,
        'recordatorio_personalizado': {
          'status': true,
          'time': '7:00 AM',
        }
      };

      // Act
      final config = NotificationConfig.fromJson(json);

      // Assert
      expect(config.sonido, true);
      expect(config.recordatorio, false);
      expect(config.recordatorioPersonalizado, isNotNull);
      expect(config.recordatorioPersonalizado!.time, '7:00 AM');
    });

    test('fromJson debe manejar recordatorio_personalizado nulo', () {
      // Arrange
      final json = {
        'sonido': true,
        'recordatorio': true,
      };

      // Act
      final config = NotificationConfig.fromJson(json);

      // Assert
      expect(config.recordatorioPersonalizado, isNull);
    });

    test('toJson debe convertir correctamente', () {
      // Arrange
      final config = NotificationConfig(
        sonido: false,
        recordatorio: true,
        recordatorioPersonalizado: RecordatorioPersonalizado(
          status: true,
          time: '6:00 PM',
        ),
      );

      // Act
      final json = config.toJson();

      // Assert
      expect(json['sonido'], false);
      expect(json['recordatorio'], true);
      expect(json['recordatorio_personalizado'], isNotNull);
    });

    test('debe crear instancia con valores por defecto', () {
      // Arrange & Act
      final config = NotificationConfig();

      // Assert
      expect(config.sonido, true);
      expect(config.recordatorio, true);
    });
  });

  group('Config Tests', () {
    test('fromJson debe crear instancia válida', () {
      // Arrange
      final json = {
        'idStudent': 'student123',
        'notification': {
          'sonido': true,
          'recordatorio': true,
        }
      };

      // Act
      final config = Config.fromJson(json);

      // Assert
      expect(config.idStudent, 'student123');
      expect(config.notification, isNotNull);
      expect(config.notification!.sonido, true);
    });

    test('fromJson debe manejar notification nulo', () {
      // Arrange
      final json = {
        'idStudent': 'student456',
      };

      // Act
      final config = Config.fromJson(json);

      // Assert
      expect(config.idStudent, 'student456');
      expect(config.notification, isNull);
    });

    test('fromJson debe usar string vacío si idStudent es null', () {
      // Arrange
      final Map<String, dynamic> json = {};

      // Act
      final config = Config.fromJson(json);

      // Assert
      expect(config.idStudent, '');
    });

    test('toJson debe convertir correctamente', () {
      // Arrange
      final config = Config(
        idStudent: 'student789',
        notification: NotificationConfig(sonido: false),
      );

      // Act
      final json = config.toJson();

      // Assert
      expect(json['notification'], isNotNull);
      expect(json['notification']['sonido'], false);
    });
  });
}
