import 'package:lexxi/domain/promotion/model/promotion.dart';
import 'package:lexxi/domain/promotion/repositories/promotion_repositorie.dart';
import 'package:injectable/injectable.dart';

@injectable
class PromotionUseCause {
  final PromotionRepositorie _repositorie;
  PromotionUseCause(this._repositorie);


  Future<PromotionModel> get(){
    return _repositorie.get();
  }
}
