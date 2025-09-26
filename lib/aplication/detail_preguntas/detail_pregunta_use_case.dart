import 'package:lexxi/aplication/componente_educativo/componente_educativo_use_case.dart';
import 'package:lexxi/domain/componente_educativo/model/componente_educativo.dart';
import 'package:lexxi/domain/detalle_pregunta/model/pregunta.dart';
import 'package:lexxi/domain/detalle_pregunta/repository/detalle_pregunta_repository.dart';
import 'package:lexxi/injection.dart';
import 'package:injectable/injectable.dart';

@injectable
class DetailPreguntasUseCase {
  final IPreguntaRepository preguntaRepository;

  DetailPreguntasUseCase(this.preguntaRepository);

  Future<List<DetallePregunta>> listarTodasLasPreguntas() async {
    final respuestasComponete = getIt.get<ComponenteEducativoUseCase>();
    final d = await preguntaRepository.getAllPreguntas();

    List<DetallePregunta> items = [];

    for (var i in d) {
      ComponenteEducativo pregunta =
          await respuestasComponete.obtenerComponenteEducativoPorId(
              id: i.pregunta!, collection: "Preguntas");
      i.respuestasComponete = [];
      for (var j in i.respuestas) {
        final respuesta = await respuestasComponete
            .obtenerComponenteEducativoPorId(id: j, collection: "Respuestas");

        i.respuestasComponete.add(respuesta);
      }
      i.preguntaComponent = pregunta;

      items.add(i);
    }
    return items;
  } 

  Future<DetallePregunta> obtenerPreguntaPorId(String id) async { 
    final respuestasComponete = getIt.get<ComponenteEducativoUseCase>();
    final d = await preguntaRepository.getPreguntaById(id);
    DetallePregunta detailPregunta = d;
    ComponenteEducativo pregunta =
        await respuestasComponete.obtenerComponenteEducativoPorId(
            id: d.pregunta!, collection: "Preguntas");
    detailPregunta.preguntaComponent = pregunta;
    List<ComponenteEducativo> respuestas = [];
    for (var i in d.respuestas) {
      final respuesta = await respuestasComponete
          .obtenerComponenteEducativoPorId(id: i, collection: "Respuestas");
      respuestas.add(respuesta);
    }
    detailPregunta.respuestasComponete = respuestas;
    return detailPregunta;
  }

  Future<void> actualizarPregunta(
      String id, Map<String, dynamic> preguntaData) async {
    await preguntaRepository.updatePregunta(id, preguntaData);
  }

  // Future<void> eliminarPregunta(String id) async {
  //   await preguntaRepository.deletePregunta(id);
  // }
}
