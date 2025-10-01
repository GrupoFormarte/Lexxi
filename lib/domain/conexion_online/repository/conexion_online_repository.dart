import 'package:lexxi/domain/conexion_online/models/conexion_online.dart';

abstract class ConexionOnlineRepository {
  Future<ConexionOnline> getDataConexion();
  Future<List<ConexionOnline>> getDataListConexion();
  Future<void>CreateConexion();
}
