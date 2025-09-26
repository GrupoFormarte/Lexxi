import 'package:lexxi/aplication/auth/service/auth_service.dart';
import 'package:lexxi/domain/auth/model/recordatorio_personalizado.dart';
import 'package:lexxi/domain/quiz/model/result_quiz_model.dart';
import 'package:lexxi/domain/student/model/student.dart';
import 'package:lexxi/domain/student/repositorie/student_repositorie.dart';
import 'package:lexxi/injection.dart';
import 'package:injectable/injectable.dart';

@injectable
class StudentService {
  final StudentsRepositorie _studentsRepositorie;

  StudentService(this._studentsRepositorie);

  Future<void> create(List<Grado> grados) async {
    final user = await getIt.get<AuthService>().getUserLocal();

    Student student = Student(
        score: '0',
        nombre: user!.name,
        idStudent: user.id.toString(),
        idInstituto: user.institute.toString(),
        name: user.name,
        secondName: user.secondName,
        lastName: user.lastName,
        secondLastName: user.secondLast,
        documentTypeId: user.typeId,
        documentType: user.typeUser,
        identificationNumber: user.numberId,
        email: user.email,
        cellphone: user.cellphone,
        grados: grados);
    return _studentsRepositorie.create(student);
  }

  Future<Student?> getInfo() async {
    final user = await getIt.get<AuthService>().getUserLocal();
    return _studentsRepositorie.getInfo(user!.id.toString());
  }

  Future<void> saveStudentResponse(Respuesta result) {
    return _studentsRepositorie.saveStudentResponse(result);
  }

  Future<void> config(Config config) {
    return _studentsRepositorie.config(config);
  }

  Future<void> update(Student student) {
    return _studentsRepositorie.update(student);
  }

  Future<Map<String, dynamic>> getPosition(String grado) async {
    final user = await getIt.get<AuthService>().getUserLocal();
    return _studentsRepositorie.getPosition("${user!.id}", grado);
  }
}
