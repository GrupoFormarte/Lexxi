
import 'package:lexxi/domain/academic_level/model/academic_level.dart';
import 'package:lexxi/domain/academic_level/repository/academic_level_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AcademicLevelUseCase {
  final AcademicLevelRepository academicLevelRepository;

  AcademicLevelUseCase(this.academicLevelRepository);



  Future<AcademicLevelModel?> getAcademicLevelById({required String id}) async {
    return await academicLevelRepository.getLevelById(id);
  }

}
