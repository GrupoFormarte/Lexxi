import 'package:lexxi/domain/pregunta/models/pregunta_model.dart';

abstract class PreguntaRepository {
  Future<List<Question>?> getPreguntas(String grado,
      {String dificultad = 'facil'});
  Future<List<Question>?> getPreguntaPorAsignatura(String asignatura,
      {String dificultad = 'facil'});

  Future<void> registrarPreguntaMala(int id);
}
