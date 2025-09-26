import 'package:lexxi/domain/item_dynamic/model/item.dart';

abstract class IItemRepository {
  Future<void> createItem({required String collection, required Item item});
  Future<Item?> getItemById({required String collection, required String id});
  Future<List<Item>> getAllItems({required String collection});
  Future<void> updateItem({required String collection, required Item item});
  Future<List<Item>> searchByField(
      {required String collection,
      required String field,
      required dynamic value});
  Future<void> deleteItem({required String collection, required String id});
  Future<List<Item>> getAllItemsApi();
  Future<List<String>> getSimulacro({required String grado, int cantidad = 2});
  Future<List<Item>> getAllItemsStateAndCity(String endPoint);

  Future<List<Item>> getItemsByIdsBulk(
      {required String collection,
      required List<String> ids,
      required String grado});
}
