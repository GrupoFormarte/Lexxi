import 'package:lexxi/domain/pregunta/exeptions/user_exception.dart';
import 'package:lexxi/domain/pregunta/models/pregunta_model.dart';
import 'package:lexxi/domain/pregunta/repositories/pregunta_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class PreguntaService {
  final PreguntaRepository _preguntaRepository;

  PreguntaService(this._preguntaRepository);

  Future<List<Question>?> getPreguntas(String grado,
      {String dificultad = 'facil',String tipoPregunta='grado'}) async {
        print(grado);
    try {
      return await _preguntaRepository.getPreguntas('$tipoPregunta/$grado',
          dificultad: dificultad);
    } catch (e) {
      throw UserException(e.toString());
    }
  }

    Future<void> registrarPreguntaMala(int id) async {
      return await _preguntaRepository.registrarPreguntaMala(id);
    }
}
