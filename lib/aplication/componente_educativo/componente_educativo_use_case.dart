import 'package:lexxi/domain/componente_educativo/model/componente_educativo.dart';
import 'package:lexxi/domain/componente_educativo/repository/componente_educativo_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class ComponenteEducativoUseCase {
  final ComponenteEducativoRepository componenteEducativoRepository;

  ComponenteEducativoUseCase(this.componenteEducativoRepository);

  Future<String> crearComponenteEducativo(
      {required ComponenteEducativo componenteEducativo,
      required String collection}) async {
   return await componenteEducativoRepository.create(
      data: componenteEducativo,
      collection: collection,
    );
  }

  Future<List<ComponenteEducativo>> listarTodosLosComponentesEducativos(
      {required String collection}) async {
    return await componenteEducativoRepository.getAll(collection: collection);
  }
  Future<List<ComponenteEducativo>> searh(
      {required String collection,required String searchTerm,required List<String> fields}) async {
    return await componenteEducativoRepository.search(collection: collection, searchTerm: searchTerm, fields: fields);
  }

  Future<ComponenteEducativo> obtenerComponenteEducativoPorId(
      {required String id, required String collection}) async {
    return await componenteEducativoRepository.getById(
        id: id, collection: collection);
  }

  Future<void> eliminarComponenteEducativo(
      {required String id, required String collection}) async {
    await componenteEducativoRepository.delete(collection: collection);
  }

  Future<void> actualizarComponenteEducativo(
      {required ComponenteEducativo componenteEducativo,
      required String id,
      required String collection}) async {
    await componenteEducativoRepository.update(
      data: componenteEducativo,
      id: id,
      collection: collection,
    );
  }
}
