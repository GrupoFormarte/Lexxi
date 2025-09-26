import 'package:lexxi/domain/detalle_pregunta/model/pregunta.dart';
import 'package:lexxi/domain/detalle_pregunta/repository/detalle_pregunta_repository.dart';
import 'package:lexxi/infrastructure/api_service/api_service.dart';
import 'package:lexxi/utils/loogers_custom.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IPreguntaRepository)
class DetallePreguntaImplement implements IPreguntaRepository {
  final ApiService dbCrud;
  final String collectionName = 'detail_preguntas';

  DetallePreguntaImplement(this.dbCrud);

  @override
  Future<String> createPregunta(Map<String, dynamic> preguntaData) async {
    final info =
        await dbCrud.create(data: preguntaData, collectionName: collectionName);
    return info!['_id'];
  }

  @override
  Future<void> createPreguntaWithId(
      Map<String, dynamic> preguntaData, String id) {
    return dbCrud.createWithId(
        data: preguntaData, collectionName: collectionName, id: id);
  }

  @override
  Future<List<DetallePregunta>> getAllPreguntas() async {
    final data = await dbCrud.getAll(nameCollection: collectionName);
    return data.map((e) => DetallePregunta.fromJson(e)).toList();
  }

  @override
  Future<DetallePregunta> getPreguntaById(String id) async {
    final data = await dbCrud.getById(collectionName: collectionName, id: id);

    final dato = data;

    dato!['id'] = id;
    return DetallePregunta.fromJson(dato);
  }

  @override
  Future<void> updatePregunta(String id, Map<String, dynamic> preguntaData) {
    return dbCrud.update(
        id: id, data: preguntaData, nameCollection: collectionName);
  }

  // Future<void> deletePregunta(String id) {
  //   // return dbCrud.delete(id: id, nameCollection: collectionName);
  // }
}
