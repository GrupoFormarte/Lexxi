import 'package:lexxi/domain/level/model/level.dart';
import 'package:lexxi/domain/level/repository/level_repository.dart';
import 'package:injectable/injectable.dart';


@injectable

class LevelUseCase {

  final LevelRepository _levelRepository;

LevelUseCase(this._levelRepository);





Future<Level?>get({required String id, required String score}){



  return _levelRepository.get(id: id, score: score);
}
  
  
}