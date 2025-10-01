import 'package:flutter_test/flutter_test.dart';
import 'package:lexxi/domain/detalle_pregunta/model/pregunta.dart';

void main() {
  group('DetallePregunta Tests', () {
    test('fromJson debe crear instancia válida', () {
      // Arrange
      final json = {
        'id': 'preg123',
        'cod': 'P001',
        'componente': 'Componente A',
        'competencia': 'Competencia 1',
        'periodo': '2024-1',
        'grado': '10',
        'area': 'Matemáticas',
        'asignatura': 'Álgebra',
        'tipo': 'multiple',
        'cant_respuesta': '4',
        'pregunta': '¿Cuál es la solución?',
        'pregunta_correcta': 'A',
        'respuestas': ['Opción A', 'Opción B', 'Opción C', 'Opción D'],
      };

      // Act
      final detalle = DetallePregunta.fromJson(json);

      // Assert
      expect(detalle.id, 'preg123');
      expect(detalle.cod, 'P001');
      expect(detalle.componente, 'Componente A');
      expect(detalle.competencia, 'Competencia 1');
      expect(detalle.periodo, '2024-1');
      expect(detalle.grado, '10');
      expect(detalle.area, 'Matemáticas');
      expect(detalle.asignatura, 'Álgebra');
      expect(detalle.tipo, 'multiple');
      expect(detalle.cantRespuesta, '4');
      expect(detalle.pregunta, '¿Cuál es la solución?');
      expect(detalle.respuestaCorrecta, 'A');
      expect(detalle.respuestas.length, 4);
    });

    test('fromJson debe manejar respuestas vacías', () {
      // Arrange
      final json = {
        'id': 'preg456',
        'cod': 'P002',
        'pregunta': 'Pregunta sin respuestas',
      };

      // Act
      final detalle = DetallePregunta.fromJson(json);

      // Assert
      expect(detalle.respuestas, isEmpty);
    });

    test('fromJson debe manejar respuestas null', () {
      // Arrange
      final json = {
        'id': 'preg789',
        'cod': 'P003',
        'pregunta': 'Pregunta',
        'respuestas': null,
      };

      // Act
      final detalle = DetallePregunta.fromJson(json);

      // Assert
      expect(detalle.respuestas, isEmpty);
    });

    test('toJson debe convertir correctamente', () {
      // Arrange
      final detalle = DetallePregunta(
        id: 'preg111',
        cod: 'P004',
        componente: 'Comp B',
        competencia: 'Comp 2',
        periodo: '2024-2',
        grado: '11',
        area: 'Ciencias',
        asignatura: 'Física',
        tipo: 'simple',
        cantRespuesta: '2',
        pregunta: '¿Verdadero o falso?',
        respuestaCorrecta: 'V',
        respuestas: ['Verdadero', 'Falso'],
      );

      // Act
      final json = detalle.toJson();

      // Assert
      expect(json['id'], 'preg111');
      expect(json['cod'], 'P004');
      expect(json['componente'], 'Comp B');
      expect(json['pregunta_correcta'], 'V');
      expect(json['respuestas'], isNotEmpty);
    });

    test('toJsonNonNull debe excluir valores nulos', () {
      // Arrange
      final detalle = DetallePregunta(
        id: 'preg222',
        cod: 'P005',
        pregunta: 'Pregunta básica',
        respuestas: ['Resp1', 'Resp2'],
      );

      // Act
      final json = detalle.toJsonNonNull();

      // Assert
      expect(json['id'], 'preg222');
      expect(json['cod'], 'P005');
      expect(json['pregunta'], 'Pregunta básica');
      expect(json['respuestas'], isNotEmpty);
      expect(json.containsKey('componente'), false);
      expect(json.containsKey('competencia'), false);
    });

    test('toJsonNonNull debe incluir respuestas aunque esté vacía', () {
      // Arrange
      final detalle = DetallePregunta(
        id: 'preg333',
        respuestas: [],
      );

      // Act
      final json = detalle.toJsonNonNull();

      // Assert
      expect(json['respuestas'], isEmpty);
      expect(json['respuestas'], isA<List>());
    });

    test('debe crear instancia con valores por defecto', () {
      // Arrange & Act
      final detalle = DetallePregunta();

      // Assert
      expect(detalle.respuestas, isEmpty);
      expect(detalle.respuestasComponete, isEmpty);
      expect(detalle.id, isNull);
    });

    test('debe crear instancia con listas personalizadas', () {
      // Arrange & Act
      final detalle = DetallePregunta(
        id: 'preg444',
        respuestas: ['A', 'B', 'C'],
        respuestasComponete: [],
      );

      // Assert
      expect(detalle.id, 'preg444');
      expect(detalle.respuestas.length, 3);
      expect(detalle.respuestasComponete, isEmpty);
    });
  });
}
