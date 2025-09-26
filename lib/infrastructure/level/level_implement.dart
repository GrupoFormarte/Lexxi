import 'package:lexxi/domain/level/model/level.dart';
import 'package:lexxi/domain/level/repository/level_repository.dart';
import 'package:lexxi/infrastructure/api_service/api_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: LevelRepository)
class LevelImplement implements LevelRepository {
  final ApiService apiService;

  final _colecction = "academic_levels";
  LevelImplement(this.apiService);

  @override
  Future<Level?> get({required String id, required String score}) async {
    final data =
        await apiService.getById(collectionName: _colecction, id: "$id/$score");

    if (data == null) {
      return null;
    }
    return Level.fromJson(data);
  }
}
