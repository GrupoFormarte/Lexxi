


import 'package:lexxi/domain/level/model/level.dart';

abstract class LevelRepository {

  Future<Level?> get({required String id,required String score});
  
}