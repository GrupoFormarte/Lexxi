import 'package:flutter_test/flutter_test.dart';
import 'package:lexxi/domain/quiz/model/result_quiz_model.dart';

void main() {
  group('ResultQuizModel Tests', () {
    test('fromJson debe crear instancia válida', () {
      // Arrange
      final json = {
        'isSimulacro': true,
        'rute': '/home',
        'respuestas': [
          {
            'idPregunta': '1',
            'asignatura': 'Matemáticas',
            'respuesta': true,
          }
        ],
      };

      // Act
      final result = ResultQuizModel.fromJson(json);

      // Assert
      expect(result.isSimulacro, true);
      expect(result.rute, '/home');
      expect(result.respuestas, isNotNull);
      expect(result.respuestas!.length, 1);
    });

    test('toJson debe convertir correctamente', () {
      // Arrange
      final respuestas = [
        Respuesta(idPregunta: '1', asignatura: 'Matemáticas', respuesta: true),
      ];
      final model = ResultQuizModel(
        isSimulacro: false,
        rute: '/quiz',
        respuestas: respuestas,
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json['isSimulacro'], false);
      expect(json['rute'], '/quiz');
      expect(json['respuestas'], isNotEmpty);
    });

    test('preguntasCorrectas debe contar respuestas correctas', () {
      // Arrange
      final respuestas = [
        Respuesta(idPregunta: '1', asignatura: 'Matemáticas', respuesta: true),
        Respuesta(idPregunta: '2', asignatura: 'Matemáticas', respuesta: false),
        Respuesta(idPregunta: '3', asignatura: 'Matemáticas', respuesta: true),
      ];
      final model = ResultQuizModel(respuestas: respuestas);

      // Act
      final correctas = model.preguntasCorrectas();

      // Assert
      expect(correctas, '2');
    });

    test('preguntasInCorrectas debe contar respuestas incorrectas', () {
      // Arrange
      final respuestas = [
        Respuesta(idPregunta: '1', asignatura: 'Matemáticas', respuesta: true),
        Respuesta(idPregunta: '2', asignatura: 'Matemáticas', respuesta: false),
        Respuesta(idPregunta: '3', asignatura: 'Matemáticas', respuesta: false),
      ];
      final model = ResultQuizModel(respuestas: respuestas);

      // Act
      final incorrectas = model.preguntasInCorrectas();

      // Assert
      expect(incorrectas, '2');
    });

    test('calcularPorcentajeRespuestasVerdaderas debe calcular correctamente',
        () {
      // Arrange
      final respuestas = [
        Respuesta(idPregunta: '1', asignatura: 'Matemáticas', respuesta: true),
        Respuesta(idPregunta: '2', asignatura: 'Matemáticas', respuesta: false),
        Respuesta(idPregunta: '3', asignatura: 'Matemáticas', respuesta: true),
        Respuesta(idPregunta: '4', asignatura: 'Matemáticas', respuesta: true),
      ];
      final model = ResultQuizModel(respuestas: respuestas);

      // Act
      final porcentaje = double.parse(model.calcularPorcentajeRespuestasVerdaderas());

      // Assert
      expect(porcentaje, 75.0);
    });

    test('calcularPorcentajeRespuestasVerdaderas debe retornar 0 si lista vacía',
        () {
      // Arrange
      final model = ResultQuizModel(respuestas: []);

      // Act
      final porcentaje = model.calcularPorcentajeRespuestasVerdaderas();

      // Assert
      expect(porcentaje, '0.0');
    });

    test('calcularNota debe calcular nota correctamente', () {
      // Arrange
      final model = ResultQuizModel();

      // Act & Assert
      expect(model.calcularNota(0), 0.0);
      expect(model.calcularNota(20), 1.0);
      expect(model.calcularNota(40), 2.0);
      expect(model.calcularNota(60), 3.0);
      expect(model.calcularNota(80), 4.0);
      expect(model.calcularNota(100), 5.0);
    });

    test('calcularNotaFinal debe calcular promedio de notas', () {
      // Arrange
      final respuestas = [
        Respuesta(idPregunta: '1', asignatura: 'Matemáticas', respuesta: true),
        Respuesta(idPregunta: '2', asignatura: 'Matemáticas', respuesta: true),
        Respuesta(idPregunta: '3', asignatura: 'Español', respuesta: true),
        Respuesta(idPregunta: '4', asignatura: 'Español', respuesta: false),
      ];
      final model = ResultQuizModel(respuestas: respuestas);

      // Act
      final notaFinal = model.calcularNotaFinal();

      // Assert
      expect(notaFinal, greaterThan(0));
    });

    test('calcularNotaFinal debe retornar 0 si no hay respuestas', () {
      // Arrange
      final model = ResultQuizModel(respuestas: []);

      // Act
      final notaFinal = model.calcularNotaFinal();

      // Assert
      expect(notaFinal, 0.0);
    });
  });

  group('Respuesta Tests', () {
    test('fromJson debe crear instancia válida', () {
      // Arrange
      final json = {
        'idPregunta': '123',
        'asignatura': 'Matemáticas',
        'respuesta': true,
        'idEstudiante': 'est1',
      };

      // Act
      final respuesta = Respuesta.fromJson(json);

      // Assert
      expect(respuesta.idPregunta, '123');
      expect(respuesta.asignatura, 'Matemáticas');
      expect(respuesta.respuesta, true);
      expect(respuesta.idEstudiante, 'est1');
    });

    test('toJson debe convertir correctamente', () {
      // Arrange
      final respuesta = Respuesta(
        idPregunta: '456',
        asignatura: 'Ciencias',
        respuesta: false,
      );

      // Act
      final json = respuesta.toJson();

      // Assert
      expect(json['idPregunta'], '456');
      expect(json['asignatura'], 'Ciencias');
      expect(json['respuesta'], false);
    });
  });

  group('AsignaturaPorcentaje Tests', () {
    test('debe crear instancia con valores correctos', () {
      // Arrange & Act
      final asignatura = AsignaturaPorcentaje(
        asignatura: 'Matemáticas',
        porcentajeCorrectas: 75.0,
        idAsignatura: 'mat1',
        nota: 3.5,
      );

      // Assert
      expect(asignatura.asignatura, 'Matemáticas');
      expect(asignatura.porcentajeCorrectas, 75.0);
      expect(asignatura.idAsignatura, 'mat1');
      expect(asignatura.nota, 3.5);
    });
  });
}
