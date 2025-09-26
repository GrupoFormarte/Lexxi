import 'package:lexxi/domain/auth/model/recordatorio_personalizado.dart';
import 'package:lexxi/domain/quiz/model/result_quiz_model.dart';
import 'package:lexxi/domain/student/model/student.dart';

abstract class StudentsRepositorie {
  Future<Student?> getInfo(String id);
  Future<void> update(Student student);
  Future<void> create(Student student);
  Future<void> config(Config config);
  Future<Map<String, dynamic>> getPosition(String id, String grado);
  Future<void> saveStudentResponse(Respuesta rsult);
}
