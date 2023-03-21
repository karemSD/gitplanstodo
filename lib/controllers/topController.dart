import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../collectionsrefrences.dart';
import '../models/tops/TopModel_model.dart';

class TopController extends GetxController {
  // getDoc<TopModel>(CollectionReference<TopModel> reference, TopModel topModel) async {
  //   DocumentSnapshot querySnapshot = await reference.doc(topModel.).get();
  //   querySnapshot.data();
  //   print(querySnapshot.data());
  // }

  Future<List<t>> getAll<t extends TopModel>(
      String value, CollectionReference subreference, String field) async {
    var projectsubTask = (await query(
      field: field,
      reference: projectMainTasksRef,
      value: value,
    ))
        .docs;
    List<t> list = [];
    for (var element in projectsubTask) {
      list.add(element.data());
    }
    return list;
  }

  Future<void> deleteAll(
      CollectionReference reference, String field, dynamic value) async {
    final WriteBatch batch = FirebaseFirestore.instance.batch();
    // QuerySnapshot _query = await taskController
    //     .getCategoryTasksSnapshot(categoryId) as UserTaskModel;

    QuerySnapshot _query =
        await query(reference: reference, field: field, value: value);
    print(_query.runtimeType);
    for (var doc in _query.docs) {
      batch.delete(reference.doc(doc.id));
    }
    await batch.commit();
  }

  Future<dynamic> query(
      {CollectionReference? reference, dynamic value, String? field}) async {
    Query query = reference!;
    return await query.where(field!, isEqualTo: value).get();
  }

  Stream<QuerySnapshot<Object?>> query1(
      {CollectionReference? reference, dynamic value, String? field}) {
    Query query = reference!;
    return query.where(field!, isEqualTo: value).snapshots();
  }

  Future<void> addDoc(CollectionReference reference, TopModel model) async {
    await reference.doc(model.id).set(model);
  }

  Future<DocumentSnapshot> getDocById(
      CollectionReference reference, String id) async {
    return await reference.doc(id).get();
  }

  Future<void> deleteDoc(CollectionReference reference, TopModel model) async {
    await reference.doc(model.id).delete();
    print("tm al hazf");
  }

  Future<void> updateDoc<t extends TopModel>(
      CollectionReference<TopModel> reference,
      String field,
      dynamic value,
      String id) async {
    reference.doc(id).update({field: value});
  }

  Future<void> delDoc<t extends TopModel>(
    CollectionReference collectionReference,
    String id,
  ) async {
    await collectionReference.doc(id).delete();
  }

  Future<int> exist({
    CollectionReference? reference,
    dynamic value,
    String? field,
    dynamic value2,
    String? field2,
  }) async {
    Query query = reference!;
    AggregateQuerySnapshot querySnapshot = await query
        .where(field!, isEqualTo: value)
        .where(field2!, isEqualTo: value2)
        .count()
        .get();
    return querySnapshot.count;
  }
}
