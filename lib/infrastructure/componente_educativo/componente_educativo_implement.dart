import 'package:lexxi/domain/componente_educativo/model/componente_educativo.dart';
import 'package:lexxi/domain/componente_educativo/repository/componente_educativo_repo.dart';
import 'package:lexxi/infrastructure/api_service/api_service.dart';
import 'package:lexxi/utils/loogers_custom.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ComponenteEducativoRepository)
class ComponenteEducativoImplement implements ComponenteEducativoRepository {
  final ApiService dbCrud;

  ComponenteEducativoImplement(this.dbCrud);

  @override
  Future<String> create(
      {required ComponenteEducativo data, required String collection}) async {
    final info = await dbCrud.create(
      data: data.toJson(),
      collectionName: collection,
    );
    return info!['_id'];
  }

  @override
  Future<void> delete({required String collection}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<ComponenteEducativo>> getAll({required String collection}) async {
    List<ComponenteEducativo> items = [];
    final data = await dbCrud.getAll(
      nameCollection: collection,
    );
    for (var i in data) {
      ComponenteEducativo compo = ComponenteEducativo();
      final r = i;
      final List<Map<String, dynamic>> list = compo.toListMap(r['componente']);
      compo.componente = list;
      compo.id = i['_id'];
      compo.idRecurso = r['id_recurso'];
      compo.tipoRecurso = r['tipo_recurso'];
      items.add(compo);
    }
    return items;
  }

  @override
  Future<ComponenteEducativo> getById(
      {required String id, required String collection}) async {
    final data = await dbCrud.getById(collectionName: collection, id: id);
    ComponenteEducativo compo = ComponenteEducativo();

    final r = data;
    final List<Map<String, dynamic>> list = compo.toListMap(r!['componente']);
    compo.componente = list;
    compo.id = data!['_id'];
    compo.idRecurso = r['id_recurso'];
    compo.tipoRecurso = r['tipo_recurso'];
    return compo;
  }

  @override
  Future<void> update(
      {required ComponenteEducativo data,
      required String id,
      required String collection}) async {
    return dbCrud.update(
        id: id, data: data.toJson(), nameCollection: collection);
  }

  @override
  Future<List<ComponenteEducativo>> search(
      {required String collection,
      required String searchTerm,
      required List<String> fields}) async {
    final data = await dbCrud.searchByFields(
        collectionName: collection, query: searchTerm, fields: fields);
    ComponenteEducativo compo = ComponenteEducativo();
    List<ComponenteEducativo> items = [];
    for (var i in data ?? []) {
      final data = i;
      final List<Map<String, dynamic>> list =
          compo.toListMap(data['componente']);
      compo.componente = list;
      compo.id = i['_id'];
      compo.idRecurso = data['id_recurso'];
      compo.tipoRecurso = data['tipo_recurso'];
      items.add(compo);
    }
    return items;
  }
}
