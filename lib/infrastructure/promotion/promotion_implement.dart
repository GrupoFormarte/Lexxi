import 'package:lexxi/domain/promotion/model/promotion.dart';
import 'package:lexxi/domain/promotion/repositories/promotion_repositorie.dart';
import 'package:lexxi/infrastructure/api_service/api_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PromotionRepositorie)
class PromotionImplement implements PromotionRepositorie {
  final ApiService apiService;
  final _colecction = "promotion_alert";
  PromotionImplement(this.apiService);
  @override
  Future<PromotionModel> get() async {
    final data = await apiService.getAll(nameCollection: _colecction);
    return PromotionModel.getActivePromotion(data);
  }
}
