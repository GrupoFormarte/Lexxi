import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:lexxi/aplication/componente_educativo/componente_educativo_use_case.dart';
import 'package:lexxi/domain/componente_educativo/repository/componente_educativo_repo.dart';
import 'package:lexxi/domain/componente_educativo/model/componente_educativo.dart';

import 'componente_educativo_use_case_test.mocks.dart';

@GenerateMocks([ComponenteEducativoRepository])
void main() {
  late ComponenteEducativoUseCase useCase;
  late MockComponenteEducativoRepository mockRepository;

  setUp(() {
    mockRepository = MockComponenteEducativoRepository();
    useCase = ComponenteEducativoUseCase(mockRepository);
  });

  group('ComponenteEducativoUseCase Tests', () {
    test('crearComponenteEducativo debe llamar al repositorio', () async {
      // Arrange
      final componente = ComponenteEducativo(
        id: '1',
        idRecurso: 'recurso1',
        tipoRecurso: 'leccion',
      );
      const collection = 'componentes';

      when(mockRepository.create(data: componente, collection: collection))
          .thenAnswer((_) async => '1');

      // Act
      final result = await useCase.crearComponenteEducativo(
        componenteEducativo: componente,
        collection: collection,
      );

      // Assert
      expect(result, '1');
      verify(mockRepository.create(data: componente, collection: collection))
          .called(1);
    });

    test('listarTodosLosComponentesEducativos debe retornar lista', () async {
      // Arrange
      const collection = 'componentes';
      final componentes = <ComponenteEducativo>[];

      when(mockRepository.getAll(collection: collection))
          .thenAnswer((_) async => componentes);

      // Act
      final result = await useCase.listarTodosLosComponentesEducativos(
        collection: collection,
      );

      // Assert
      expect(result, isEmpty);
      verify(mockRepository.getAll(collection: collection)).called(1);
    });

    test('obtenerComponenteEducativoPorId debe retornar componente', () async {
      // Arrange
      const id = '1';
      const collection = 'componentes';
      final componente = ComponenteEducativo(
        id: id,
        idRecurso: 'recurso1',
        tipoRecurso: 'leccion',
      );

      when(mockRepository.getById(id: id, collection: collection))
          .thenAnswer((_) async => componente);

      // Act
      final result = await useCase.obtenerComponenteEducativoPorId(
        id: id,
        collection: collection,
      );

      // Assert
      expect(result.id, id);
      verify(mockRepository.getById(id: id, collection: collection)).called(1);
    });

    test('actualizarComponenteEducativo debe llamar al repositorio', () async {
      // Arrange
      final componente = ComponenteEducativo(
        id: '1',
        idRecurso: 'recurso1',
        tipoRecurso: 'leccion',
      );
      const id = '1';
      const collection = 'componentes';

      when(mockRepository.update(
        data: componente,
        id: id,
        collection: collection,
      )).thenAnswer((_) async => null);

      // Act
      await useCase.actualizarComponenteEducativo(
        componenteEducativo: componente,
        id: id,
        collection: collection,
      );

      // Assert
      verify(mockRepository.update(
        data: componente,
        id: id,
        collection: collection,
      )).called(1);
    });

    test('eliminarComponenteEducativo debe llamar al repositorio', () async {
      // Arrange
      const id = '1';
      const collection = 'componentes';

      when(mockRepository.delete(collection: collection))
          .thenAnswer((_) async => null);

      // Act
      await useCase.eliminarComponenteEducativo(
        id: id,
        collection: collection,
      );

      // Assert
      verify(mockRepository.delete(collection: collection)).called(1);
    });
  });
}
