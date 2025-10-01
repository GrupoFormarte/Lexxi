import 'package:flutter_test/flutter_test.dart';
import 'package:lexxi/src/providers/resumen_quiz_provider.dart';
import 'package:lexxi/domain/quiz/model/result_quiz_model.dart';

void main() {
  group('ResumenQuizProvider Tests', () {
    late ResumenQuizProvider provider;

    setUp(() {
      provider = ResumenQuizProvider();
    });

    test('Setter de resultQuizModel debe actualizar y notificar', () {
      // Arrange
      final result = ResultQuizModel(
        isSimulacro: false,
        rute: '/test',
        respuestas: [],
      );
      var notified = false;

      provider.addListener(() {
        notified = true;
      });

      // Act
      provider.resultQuizModel = result;

      // Assert
      expect(notified, isTrue);
      expect(provider.resultQuizModel.rute, '/test');
    });

    test('Getter debe retornar el resultado actual', () {
      // Arrange
      final result = ResultQuizModel(
        isSimulacro: true,
        rute: '/simulacro',
        respuestas: [],
      );

      // Act
      provider.resultQuizModel = result;

      // Assert
      expect(provider.resultQuizModel.isSimulacro, isTrue);
      expect(provider.resultQuizModel.rute, '/simulacro');
    });
  });
}
