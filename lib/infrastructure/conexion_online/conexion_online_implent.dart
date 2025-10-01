import 'package:injectable/injectable.dart';
import 'package:lexxi/domain/conexion_online/models/conexion_online.dart';
import 'package:lexxi/domain/conexion_online/repository/conexion_online_repository.dart';
import 'package:lexxi/infrastructure/api_service/api_service.dart';

@LazySingleton(as: ConexionOnlineRepository)
class ConexionOnlineImplent implements ConexionOnlineRepository {
  final ApiService dbCrud;
  final String nameCollection = "conexion_online";

  ConexionOnlineImplent({required this.dbCrud});

  @override
  Future<ConexionOnline> getDataConexion() async {
    final data = await dbCrud.getAllBy(nameCollection, "student/");
    return ConexionOnline.fromJson(data);
  }

  @override
  Future<void> CreateConexion() async {
    try {
      await dbCrud.post(
        data: {"isConeted": true},
        endPoint: "${nameCollection}",
      );
    } catch (e) {
      // return null;
      throw "Algo salio mal al crear el dato";
    }
  }

  @override
  Future<List<ConexionOnline>> getDataListConexion() async {
    final dataList = await dbCrud.getAll(nameCollection: nameCollection);
    return dataList.map((data) => ConexionOnline.fromJson(data)).toList();
  }
}
