import 'package:lexxi/domain/academic_level/model/academic_level.dart';
import 'package:lexxi/domain/academic_level/repository/academic_level_repository.dart';
import 'package:lexxi/infrastructure/api_service/api_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AcademicLevelRepository)
class AcademicLevelRepositoryImpl implements AcademicLevelRepository {
  final ApiService dbCrud;
  final String collectionName = 'academic_levels';

  AcademicLevelRepositoryImpl(this.dbCrud);

  @override
  Future<AcademicLevelModel?> getLevelById(String id) async {
    final data = await dbCrud.getById(collectionName: collectionName, id: id);
    return data != null ? AcademicLevelModel.fromJson(data) : null;
  }
}
