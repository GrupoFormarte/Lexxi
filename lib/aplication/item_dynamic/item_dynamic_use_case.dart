import 'package:lexxi/domain/item_dynamic/model/item.dart';
import 'package:lexxi/domain/item_dynamic/repository/item_repository.dart';
import 'package:lexxi/utils/loogers_custom.dart';
import 'package:injectable/injectable.dart';

@injectable
class ItemDynamicUseCase {
  final IItemRepository _repository;

  ItemDynamicUseCase(this._repository);

  Future<void> createItem(
      {required String collection, required Item item}) async {
    return await _repository.createItem(collection: collection, item: item);
  }

  Future<Item?> getItemById(
      {required String collection, required String id}) async {
    return _repository.getItemById(collection: collection, id: id);
  }

  Future<List<Item>> getAllItems({required String collection}) async {
    return _repository.getAllItems(collection: collection);
  }

  Future<void> updateItem(
      {required String collection, required Item item}) async {
    await _repository.updateItem(collection: collection, item: item);
  }

  Future<void> deleteItem(
      {required String collection, required String id}) async {
    await _repository.deleteItem(collection: collection, id: id);
  }

  Future<List<Item>> searchByField(
      {required String collection, required String field, required value}) {
    return _repository.searchByField(
        collection: collection, field: field, value: value);
  }

  Future<List<Item>> getChildrents(
      {required String collection,
      required List<String> ids,
      String? param}) async {
    List<Item> childrents = [];

    for (var i in ids) {
      final id = param != null ? "$i/$param" : i;
      try {
        final item = await getItemById(collection: collection, id: id);
        childrents.add(item!);
      } on Exception catch (e) {
        logger.e(e);
      }
    }

    return childrents;
  }

  Future<List<Item>> getAllItemsApi() async {
    return _repository.getAllItemsApi();
  }

  Future<List<Item>> getAllItemsStateAndCity(String endPoint) async {
    return _repository.getAllItemsStateAndCity(endPoint);
  }

  Future<List<String>> getSimulacro({required String grado, int cantidad = 2}) {
    return _repository.getSimulacro(grado: grado, cantidad: cantidad);
  }

  Future<List<Item>> getItemsByIdsBulk(
      {required String collection,
      required List<String> ids,
      required String grado}) async {
    return _repository.getItemsByIdsBulk(
        collection: collection, ids: ids, grado: grado);
  }
}
