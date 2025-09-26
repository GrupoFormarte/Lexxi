
import 'package:lexxi/domain/detalle_pregunta/model/pregunta.dart';

abstract class IPreguntaRepository {
  Future<void> createPregunta(Map<String, dynamic> preguntaData);
  Future<void> createPreguntaWithId(Map<String, dynamic> preguntaData, String id);
  Future<List<DetallePregunta>> getAllPreguntas();
  Future<DetallePregunta> getPreguntaById(String id);
  Future<void> updatePregunta(String id, Map<String, dynamic> preguntaData);
  // Future<void> deletePregunta(String id);
}
