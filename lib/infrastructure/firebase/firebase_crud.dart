// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:injectable/injectable.dart';

// @injectable
// class FirebaseCrud {
//   final FirebaseFirestore db = FirebaseFirestore.instance;

//   // Método para crear un nuevo documento
//   Future<DocumentReference> create({
//     required Map<String, dynamic> data,
//     required String nameCollection,
//   }) async => db.collection(nameCollection).add(data);

//   // Método para crear un nuevo documento con un ID específico
//   Future<void> createWithId({
//     required Map<String, dynamic> data,
//     required String nameCollection,
//     String? id,
//   }) async => db.collection(nameCollection).doc(id).set(data);

//   // Método para obtener todos los documentos de una colección
//   Future<QuerySnapshot> getAll({required String nameCollection}) async =>
//       db.collection(nameCollection).get();

//   // Método para obtener un documento por ID
//   Future<DocumentSnapshot> getById({
//     required String collection,
//     required String id,
//   }) async => db.collection(collection).doc(id).get();

//   // Método para actualizar un documento por ID
//   Future<void> update({
//     required String id,
//     required Map<String, dynamic> data,
//     required String nameCollection,
//   }) async => db.collection(nameCollection).doc(id).update(data);

//   // Método para eliminar un documento por ID
//   Future<void> delete({
//     required String id,
//     required String nameCollection,
//   }) async => db.collection(nameCollection).doc(id).delete();

//   // Método para obtener documentos por una categoría específica
//   Future<QuerySnapshot> getAllBy({
//     required String category,
//     required String table,
//     required String nameCollection,
//   }) async => db.collection(nameCollection).where(table, isEqualTo: category).get();

//   // Método para buscar documentos por un campo y valor específicos
//   Future<QuerySnapshot?> searchByField({
//     required String collection,
//     required String field,
//     required dynamic value,
//   }) async {
//     try {
//       return await db.collection(collection)
//                      .where(field, isEqualTo: value)
//                      .get();
//     } catch (e) {
//       print('Error al buscar documentos: $e');
//       return null;
//     }
//   }

//   // Método para buscar documentos por múltiples campos y un valor específico
//   Future<List<QueryDocumentSnapshot>> searchByFields({
//     required String nameCollection,
//     required String query,
//     required List<String> fields,
//   }) async {
//     List<Future<QuerySnapshot>> searchFutures = [];
//     for (String field in fields) {
//       searchFutures.add(
//         db.collection(nameCollection)
//           .where(field, isGreaterThanOrEqualTo: query)
//           .get(),
//       );
//     }
//     List<QuerySnapshot> snapshots = await Future.wait(searchFutures);
//     Set<QueryDocumentSnapshot> combinedResults = {};
//     for (var snapshot in snapshots) {
//       combinedResults.addAll(snapshot.docs);
//     }
//     return combinedResults.toList();
//   }
// }