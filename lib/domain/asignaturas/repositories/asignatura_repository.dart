import 'package:lexxi/domain/asignaturas/model/asignatura_model.dart';
import 'package:lexxi/domain/asignaturas/model/resultado_asignatura.dart';

abstract class AsignaturaRepository{
  Future<List<Asignatura>> getAsignatura(String grado);

  Future<void> guardarResultadoAsignatura(ResultadoAsignatura data);

  Future<List<ResultadoAsignatura>> getResultadoAsignatura(int idU);

}