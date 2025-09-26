import 'package:lexxi/domain/item_dynamic/model/item.dart';
import 'package:lexxi/domain/item_dynamic/repository/item_repository.dart';
import 'package:lexxi/infrastructure/api_service/api_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IItemRepository)
class ItemImplement implements IItemRepository {
  final ApiService apiService;
  ItemImplement(this.apiService);

  @override
  Future<String> createItem(
      {required String collection, required Item item}) async {
    final data = await apiService.create(
      data: item.toJson(),
      collectionName: collection,
    );

    return data?['_id'] ?? '';
  }

  @override
  Future<void> deleteItem(
      {required String collection, required String id}) async {
    await apiService.delete(collection, id);
  }

  @override
  Future<List<Item>> getAllItems({required String collection}) async {
    final data = await apiService.getAll(nameCollection: collection);
    return data.map((e) {
      Item item = Item.fromJson(e);
      item.id = e['_id'];
      return item;
    }).toList();
  }

  @override
  Future<Item?> getItemById(
      {required String collection, required String id}) async {
    final data = await apiService.getById(collectionName: collection, id: id);

    if (data != null) {
      Item item = Item.fromJson(data);
      item.id = id;
      return item;
    }
    return null;
  }

  @override
  Future<void> updateItem(
      {required String collection, required Item item}) async {
    await apiService.update(
      id: item.id!,
      nameCollection: collection,
      data: item.toJson(),
    );
  }

  @override
  Future<List<Item>> getAllItemsApi() async {
    final data = await apiService.getDataApi();
    return data.map((e) {
      Item item = Item();
      item.code = e['code'];
      item.value = e['name'];
      item.id = "${e['id']}";
      item.shortName = e['shortName'];

      return item;
    }).toList();
  }

  @override
  Future<List<Item>> searchByField(
      {required String collection,
      required String field,
      required dynamic value}) async {
    final data = await apiService.searchByField(collection, field, value);

    if (data == null) {
      return [];
    }
    return data.map((e) {
      Item item = Item.fromJson(e);
      item.id = e['_id'];
      return item;
    }).toList();
  }

  @override
  Future<List<Item>> getAllItemsStateAndCity(String endPoint) async {
    final data = await apiService.getAllItemsStateAndCity(endPoint);
    return data.map((e) {
      Item item = Item();
      item.id = "${e['id']}";
      item.codeDep = e['code_dep'];
      item.name = e['name'];

      return item;
    }).toList();
  }

  @override
  Future<List<Item>> getItemsByIdsBulk({
    required String collection,
    required List<String> ids,
    required String grado,
  }) async {
    try {
      final response = await apiService.post(
        endPoint: collection,
        data: {"ids": ids, "grado": grado},
      );

      if (response is! List) {
        throw Exception('Respuesta inesperada del servidor');
      }

      return response.map<Item>((json) {
        if (json != null && json is Map<String, dynamic>) {
          final item = Item.fromJson(json);
          if (json['_id'] != null) {
            item.id = json['_id'];
          }
          return item;
        } else {
          throw Exception('Elemento inválido en la respuesta');
        }
      }).toList();
    } catch (e) {
      // Manejo del error, puedes adaptarlo según tu estructura
      print('Error al obtener items por IDs: $e');
      rethrow;
    }
  }

  @override
  Future<List<String>> getSimulacro(
      {required String grado, int cantidad = 2}) async {
    final data = await apiService.getById(
        collectionName: "generate-simulacro", id: "$grado/$cantidad");

    List<String> lista = [];
    for (var element in data!['data']) {
      lista.add(element);
    }

    return lista;
  }
}
