

import '../model/componente_educativo.dart';

abstract class ComponenteEducativoRepository {
  Future<String> create(
      {required ComponenteEducativo data, required String collection});

  Future<List<ComponenteEducativo>> getAll({required String collection});
  Future<List<ComponenteEducativo>> search({required String collection,    required String searchTerm,
    required List<String> fields,});
  Future<ComponenteEducativo> getById(
      {required String id, required String collection});

  Future<void> delete({required String collection});

  Future<void> update(
      {required ComponenteEducativo data,required String id, required String collection});
}
