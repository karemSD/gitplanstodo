
import 'package:auth_with_koko/services/utils_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'dart:developer' as dev;

import '../models/tops/TopModel_model.dart';

class TestController {
  Future<QuerySnapshot<Object?>> queryWhere(
      {required CollectionReference reference,
      required String field,
      dynamic value}) async {
    Query query = reference;
    return await query.where(field, isEqualTo: value).get();
  }

  Stream<QuerySnapshot<Object?>> queryWhereStream(
      {required CollectionReference reference,
      required String field,
      dynamic value}) {
    Query query = reference;
    return query.where(field, isEqualTo: value).snapshots();
  }

//جلب الدوكبومنتس ضغري عن  طريق سناب شوت وبعتها مشان ماتعذب باخد الكويري بعدين واوصل للدوكز يلي بقلبها ضغري ببعتهن
  Future<List<QueryDocumentSnapshot<Object?>>> getDocsWhere(
      {required CollectionReference collectionReference,
      required String field,
      dynamic value}) async {
    QuerySnapshot querySnapshot = await queryWhere(
        reference: collectionReference, field: field, value: value);
    List<QueryDocumentSnapshot<Object?>> list = querySnapshot.docs;
    return list;
  }

//جلب الدوك بشكل فوري
  Future<QueryDocumentSnapshot<Object?>?> getDocWhere(
      {required CollectionReference collectionReference,
      required String field,
      dynamic value}) async {
    QuerySnapshot querySnapshot = await queryWhere(
        reference: collectionReference, field: field, value: value);
    List<QueryDocumentSnapshot<Object?>> list = querySnapshot.docs;
    if (list.isEmpty) {
      return null;
    }
    return list.first;
  }

  //جلب دوك ستريم بشرط واحد
  Stream<DocumentSnapshot> getDocWhereStream(
      {required CollectionReference collectionReference,
      required String field,
      dynamic value}) async* {
    DocumentSnapshot? doc = await getDocWhere(
        collectionReference: collectionReference, field: field, value: value);
    yield* doc!.reference.snapshots();
  }

  //جلب دوك واحد بشرطين
  Future<QueryDocumentSnapshot<Object?>> getDocWhereAndWhere(
      {required CollectionReference collectionReference,
      required String firstField,
      dynamic firstValue,
      required String secondField,
      dynamic secondValue}) async {
    QuerySnapshot querySnapshot = await queryWhereAndWhere(
        reference: collectionReference,
        firstField: firstField,
        firstValue: firstValue,
        secondField: secondField,
        secondValue: secondValue);
    List<QueryDocumentSnapshot<Object?>> list = querySnapshot.docs;
    return list.first;
  }

  //ستريم جلب دوك واحد بشرطين
  Stream<DocumentSnapshot<Object?>> getDocWhereAndWhereStream(
      {required CollectionReference collectionReference,
      required String firstField,
      dynamic firstValue,
      required String secondField,
      dynamic secondValue}) async* {
    DocumentSnapshot documentSnapshot = await getDocWhereAndWhere(
        collectionReference: collectionReference,
        firstField: firstField,
        firstValue: firstValue,
        secondField: secondField,
        secondValue: secondValue);
    yield* documentSnapshot.reference.snapshots();
  }

//على شكل ستريم
  Stream<QuerySnapshot<Object?>> queryWhereAndWhereStream(
      {required CollectionReference reference,
      required String firstField,
      dynamic firstValue,
      required String secondField,
      dynamic secondValue}) {
    Query query = reference;
    return query
        .where(firstField, isEqualTo: firstValue)
        .where(secondField, isEqualTo: secondValue)
        .snapshots();
  }

  Future<QuerySnapshot<Object?>> queryWhereAndWhere(
      {required CollectionReference reference,
      required String firstField,
      dynamic firstValue,
      required String secondField,
      dynamic secondValue}) async {
    Query query = reference;
    return await query
        .where(firstField, isEqualTo: firstValue)
        .where(secondField, isEqualTo: secondValue)
        .get();
  }

//جلب جميع الدوك  بهيئة ليست
  Future<List<Object?>?> getAll<t extends TopModel>(
      {required CollectionReference collectionReference}) async {
    QuerySnapshot<Object?> querydocs = await collectionReference.get();
    List<Object?>? listDocs = [];
    for (var doc in querydocs.docs) {
      listDocs.add(doc.data());
    }
    return listDocs;
  }

//جلب جميع الدوك بشرط واحد بهيئة ليست
  Future<List<Object?>?> getAllWhere<t extends TopModel>(
      {required CollectionReference collectionReference,
      required String field,
      dynamic value}) async {
    QuerySnapshot<Object?> querydocs =
        await queryWhere(reference: collectionReference, field: value);
    List<Object?>? listDocs = [];
    for (var doc in querydocs.docs) {
      listDocs.add(doc.data());
    }
    return listDocs;
  }

//جلب الدوكيومنتس عند تحقق شرطين وتحويلها لليست وبعتها
  Future<List<Object?>?> getAllWhereAndWhere<t extends TopModel>(
      {required CollectionReference collectionReference,
      required String firstField,
      dynamic firstValue,
      required String secondField,
      dynamic secondValue}) async {
    QuerySnapshot<Object?> querydocs = await queryWhereAndWhere(
        reference: collectionReference,
        firstField: firstField,
        firstValue: firstValue,
        secondField: secondField,
        secondValue: secondValue);
    List<Object?>? listDocs = [];
    for (var doc in querydocs.docs) {
      listDocs.add(doc.data());
    }
    return listDocs;
  }

//جلب مودل بالايدي
  Future<DocumentSnapshot<Object?>> getDocById(
      {required CollectionReference reference, required String id}) async {
    return await reference.doc(id).get();
  }
   Stream<DocumentSnapshot> getDocByIdStream(
      {required CollectionReference reference, required String id})  {
    return  reference.doc(id).snapshots();
  }

//جلب دوك عن طريق انو البارمتر مودل
  Future<DocumentSnapshot<Object?>> getDocByModel(
      {required CollectionReference reference,
      required TopModel topModel}) async {
    return await reference.doc(topModel.id).get();
  }

  //للتأكد من صحة شرط واحد متل لما ضيف مانجر بدي أتاكد انو هل اليوزر موجود يلي عم ساويه مانجر او لأ
  Future<bool> existByOne(
      {required CollectionReference collectionReference,
      required String filed,
      dynamic value}) async {
    Query query = collectionReference;
    AggregateQuerySnapshot aggregateQuery =
        await query.where(filed, isEqualTo: value).count().get();
    if (aggregateQuery.count > 0) {
      return true;
    }
    return false;
  }

//تحديث الحقول التي ليس لها علاقة بمجموعات اخرى
  Future<void> updateNonRelationalFields(
      {required CollectionReference reference,
      required Map<String, dynamic> data,
      required String id}) async {
    if (data.containsKey("id")) {
      Exception exception = Exception(
          "id cannot be updated ...this method only for Update Non-Relational fields");
      throw exception;
    }
    data['updatedAt'] = firebasetime(DateTime.now());
    reference.doc(id).update(data);
  }

//اضافة دوكيومنت
  Future<void> addDoc(
      {required CollectionReference reference, required TopModel model}) async {
    await reference.doc(model.id).set(model);
  }

  //لما بدي اتأكد من وجود شغلتين ان كانا موجودان او لأ
  Future<bool> existInTowPlaces({
    required CollectionReference firstCollectionReference,
    required String firstFiled,
    dynamic firstvalue,
    required CollectionReference secondCollectionReference,
    required String secondFiled,
    dynamic secondValue,
  }) async {
    if (await existByOne(
            collectionReference: firstCollectionReference,
            filed: firstFiled,
            value: firstvalue) &&
        await existByOne(
            collectionReference: secondCollectionReference,
            filed: secondFiled,
            value: secondValue)) {
      return true;
    }
    return false;
  }

//للتأكد من شرطين انهما صحيحان مثلا وقت بدي ضيف مشروع بدي اـاكد انو الفريق يلي عم ضيفو يكون لهل المانجر نفس يلي حاطط ايديه بالبروجكت وانو الفريق موجود بالداتا بيز
  Future<bool> existByTwo({
    required CollectionReference collectionReference,
    required String firstFiled,
    dynamic firstvalue,
    required String secondFiled,
    dynamic secondValue,
  }) async {
    Query query = collectionReference;
    AggregateQuerySnapshot aggregateQuerySnapshot = await query
        .where(firstFiled, isEqualTo: firstvalue)
        .where(secondFiled, isEqualTo: secondValue)
        .count()
        .get();
    if (aggregateQuerySnapshot.count > 0) {
      return true;
    }
    return false;
  }

  Future<void> deleteDocUsingBatch<t extends TopModel>(
      {required DocumentSnapshot? documentSnapshot,
      required WriteBatch refbatch}) async {
    WriteBatch writeBatch;
    writeBatch = refbatch;
    if (documentSnapshot != null) {
      writeBatch.delete(documentSnapshot.reference);
    }
  }

  deleteAllUsingBatch(
      {required List<DocumentSnapshot?> list,
      required WriteBatch refbatch}) async {
    final WriteBatch batch = refbatch;
    for (var doc in list) {
      if (doc != null) {
        batch.delete(doc.reference);
      }
    }
  }
}
//todo 