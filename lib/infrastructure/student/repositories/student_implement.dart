import 'package:lexxi/domain/auth/model/recordatorio_personalizado.dart';
import 'package:lexxi/domain/quiz/model/result_quiz_model.dart';
import 'package:lexxi/domain/student/model/student.dart';
import 'package:lexxi/domain/student/repositorie/student_repositorie.dart';
import 'package:lexxi/infrastructure/api_service/api_service.dart';
import 'package:lexxi/utils/loogers_custom.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: StudentsRepositorie)
class StudentImplement implements StudentsRepositorie {
  final ApiService dbCrud;

  String nameCollection = "Estudiantes";
  //  String answersCollection = "Respuestas";
  String answersCollection = "resultados_preguntas";
  String difficultyCollection = "grado_dificultad";
  String countersCollection = "contadores_preguntas";

  StudentImplement(this.dbCrud);

  @override
  Future<void> create(Student student) async {
    try {
      await dbCrud.createWithId(
        data: student.toJson(),
        collectionName: nameCollection,
        id: student.idStudent!,
      );
    } catch (e) {
      logger.e(['Error creating student', e]);
    }
  }

  @override
  Future<void> saveStudentResponse(Respuesta result) async {
    try {
      // Crear la respuesta del estudiante
      await dbCrud.create(
        data: result.toJson(),
        collectionName: answersCollection,
      );

      // Obtener el documento del contador
      final counterDocRef = '$countersCollection/${result.idPregunta}';
      final currentCounter = await dbCrud.getById(
        collectionName: countersCollection,
        id: result.idPregunta,
      );

      // Actualizar los contadores
      Map<String, dynamic> counterData = currentCounter ??
          {
            "trueCount": 0,
            "falseCount": 0,
          };
      final newTrueCount =
          (counterData["trueCount"] as int) + (result.respuesta! ? 1 : 0);
      final newFalseCount =
          (counterData["falseCount"] as int) + (result.respuesta! ? 0 : 1);
      counterData = {
        "trueCount": newTrueCount,
        "falseCount": newFalseCount,
      };

      if (currentCounter == null) {
        await dbCrud.createWithId(
          collectionName: countersCollection,
          id: result.idPregunta,
          data: counterData,
        );
      }
      // Guardar los contadores actualizados

      // Determinar el grado de dificultad
      String gradoDificultad;
      if (newTrueCount > newFalseCount) {
        gradoDificultad = "fácil";
      } else if (newFalseCount > newTrueCount) {
        gradoDificultad = "difícil";
      } else {
        gradoDificultad = "medio";
      }

      // Guardar el grado de dificultad en la colección `grado_dificultad`
      final difficultyData = {
        "idPregunta": result.idPregunta,
        "grado_dificultad": gradoDificultad,
      };
      final data = await dbCrud.createWithId(
        collectionName: difficultyCollection,
        id: result.idPregunta,
        data: difficultyData,
      );
      if (data == null) {
        final r = await dbCrud.update(
          nameCollection: difficultyCollection,
          id: result.idPregunta,
          data: difficultyData,
        );
      }

      if (currentCounter != null) {
        await dbCrud.update(
          nameCollection: countersCollection,
          id: result.idPregunta,
          data: counterData,
        );
      }
    } catch (e) {
      logger.e(['Error saving response and updating counters', e]);
    }
  }

  @override
  Future<void> update(Student student) {
    return dbCrud.update(
      id: student.idMongo!,
      data: student.toJson(),
      nameCollection: nameCollection,
    );
  }

  @override
  Future<Student?> getInfo(String id) async {
    try {
      final info = await dbCrud.getById(
        collectionName: "$nameCollection/convert_id",
        id: id,
      );
      return info != null ? Student.fromJson(info) : null;
    } catch (e) {
      logger.e(['Error getting info', e]);
      return null;
    }
  }

  @override
  Future<void> config(Config config) async {
    try {
      return dbCrud.update(
        id: "${config.idStudent}/config",
        data: config.toJson(),
        nameCollection: nameCollection,
      );
    } catch (e) {
      logger.e(['Error getting config', e]);
      // return null;
    }
  }

  @override
  Future<Map<String, dynamic>> getPosition(String id, String grado) async {
    try {
      final position = await dbCrud.getById(
        collectionName: "get-my-position/$grado",
        id: id,
      );
      if (position == null) {
        return {"position": 0, "n_estudiantes": 0};
      }
      return position;
    } catch (e) {
      return {"position": 0, "n_estudiantes": 0};
    }
  }
}
