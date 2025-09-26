import 'package:lexxi/domain/asignaturas/model/asignatura_model.dart';
import 'package:lexxi/domain/asignaturas/model/resultado_asignatura.dart';
import 'package:lexxi/domain/asignaturas/repositories/asignatura_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AsignaturaService {
  final AsignaturaRepository _asignaturaRepository;
  AsignaturaService(this._asignaturaRepository);

  Future<List<Asignatura>> getAsignaturas(String grado) async {
    return await _asignaturaRepository.getAsignatura(grado);
  }

  Future<void> guardarResultadoAsignatura(ResultadoAsignatura data) async {
    await _asignaturaRepository.guardarResultadoAsignatura(data);
  }

  Future<List<ResultadoAsignatura>> getResultadoAsignatura(int idU) async {
    return await _asignaturaRepository.getResultadoAsignatura(idU);
  }
}
