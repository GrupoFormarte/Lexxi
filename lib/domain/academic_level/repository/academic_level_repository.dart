
import 'package:lexxi/domain/academic_level/model/academic_level.dart';

abstract class AcademicLevelRepository {

  Future<AcademicLevelModel?> getLevelById(String id);

}