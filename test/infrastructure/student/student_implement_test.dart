import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lexxi/infrastructure/student/repositories/student_implement.dart';
import 'package:lexxi/infrastructure/api_service/api_service.dart';
import 'package:lexxi/domain/student/model/student.dart';
import 'package:lexxi/domain/quiz/model/result_quiz_model.dart';
import 'package:lexxi/domain/auth/model/recordatorio_personalizado.dart';

import 'student_implement_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  late StudentImplement implementation;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    implementation = StudentImplement(mockApiService);
  });

  group('StudentImplement Tests', () {
    test('create debe llamar al servicio API', () async {
      // Arrange
      final student = Student(
        idStudent: 'student123',
        nombre: 'Juan',
        lastName: 'Pérez',
      );

      when(mockApiService.createWithId(
        data: anyNamed('data'),
        collectionName: anyNamed('collectionName'),
        id: anyNamed('id'),
      )).thenAnswer((_) async => null);

      // Act
      await implementation.create(student);

      // Assert
      verify(mockApiService.createWithId(
        data: student.toJson(),
        collectionName: 'Estudiantes',
        id: 'student123',
      )).called(1);
    });

    test('getInfo debe retornar Student cuando existe', () async {
      // Arrange
      final mockData = {
        'id_student': 'student123',
        'nombre': 'Juan',
        'last_name': 'Pérez',
      };

      when(mockApiService.getById(
        collectionName: anyNamed('collectionName'),
        id: anyNamed('id'),
      )).thenAnswer((_) async => mockData);

      // Act
      final result = await implementation.getInfo('student123');

      // Assert
      expect(result, isNotNull);
      expect(result!.idStudent, 'student123');
      verify(mockApiService.getById(
        collectionName: 'Estudiantes/convert_id',
        id: 'student123',
      )).called(1);
    });

    test('getInfo debe retornar null cuando no existe', () async {
      // Arrange
      when(mockApiService.getById(
        collectionName: anyNamed('collectionName'),
        id: anyNamed('id'),
      )).thenAnswer((_) async => null);

      // Act
      final result = await implementation.getInfo('student123');

      // Assert
      expect(result, isNull);
    });

    test('update debe llamar al servicio API', () async {
      // Arrange
      final student = Student(
        idMongo: 'mongo123',
        idStudent: 'student123',
        nombre: 'Juan',
        lastName: 'Pérez',
      );

      when(mockApiService.update(
        id: anyNamed('id'),
        data: anyNamed('data'),
        nameCollection: anyNamed('nameCollection'),
      )).thenAnswer((_) async => null);

      // Act
      await implementation.update(student);

      // Assert
      verify(mockApiService.update(
        id: 'mongo123',
        data: student.toJson(),
        nameCollection: 'Estudiantes',
      )).called(1);
    });

    test('config debe actualizar configuración del estudiante', () async {
      // Arrange
      final config = Config(
        idStudent: 'student123',
        notification: NotificationConfig(
          recordatorioPersonalizado: RecordatorioPersonalizado(
            status: true,
            time: '10:00',
          ),
        ),
      );

      when(mockApiService.update(
        id: anyNamed('id'),
        data: anyNamed('data'),
        nameCollection: anyNamed('nameCollection'),
      )).thenAnswer((_) async => null);

      // Act
      await implementation.config(config);

      // Assert
      verify(mockApiService.update(
        id: 'student123/config',
        data: config.toJson(),
        nameCollection: 'Estudiantes',
      )).called(1);
    });

    test('getPosition debe retornar posición del estudiante', () async {
      // Arrange
      final mockData = {
        'position': 5,
        'n_estudiantes': 100,
      };

      when(mockApiService.getById(
        collectionName: anyNamed('collectionName'),
        id: anyNamed('id'),
      )).thenAnswer((_) async => mockData);

      // Act
      final result = await implementation.getPosition('student123', '11');

      // Assert
      expect(result['position'], 5);
      expect(result['n_estudiantes'], 100);
      verify(mockApiService.getById(
        collectionName: 'get-my-position/11',
        id: 'student123',
      )).called(1);
    });

    test('getPosition debe retornar valores por defecto cuando falla',
        () async {
      // Arrange
      when(mockApiService.getById(
        collectionName: anyNamed('collectionName'),
        id: anyNamed('id'),
      )).thenAnswer((_) async => null);

      // Act
      final result = await implementation.getPosition('student123', '11');

      // Assert
      expect(result['position'], 0);
      expect(result['n_estudiantes'], 0);
    });
  });
}
