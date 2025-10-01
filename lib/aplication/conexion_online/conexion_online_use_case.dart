import 'package:injectable/injectable.dart';
import 'package:lexxi/domain/conexion_online/models/conexion_online.dart';
import 'package:lexxi/domain/conexion_online/repository/conexion_online_repository.dart';

@injectable
class ConexionOnlineUseCase {
  final ConexionOnlineRepository _repository;

  ConexionOnlineUseCase({required ConexionOnlineRepository repository})
    : _repository = repository;

  Future<void> create() async {
    _repository.CreateConexion();
  }

  Future<List<ConexionOnline>> getAll() {
    return _repository.getDataListConexion();
  }
}
