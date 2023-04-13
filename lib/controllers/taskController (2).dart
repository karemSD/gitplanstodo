import 'package:auth_with_koko/controllers/testController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../collectionsrefrences.dart';
import '../models/statusmodel.dart';
import '../models/team/Task_model.dart';



class TaskController extends TestController {
  // Future<List<t>> getTasksForStatus<t extends TaskClass>({
  //   required String status,
  //   required CollectionReference reference,
  //   required String field,
  //   required dynamic value,
  // }) async {
  //   final StatusModel statusModel = await getDocWhere(
  //     reference: statusesRef,
  //     field: "name",
  //     value: status,
  //   );
  //   return await getDocumentsWhereAndWhere(
  //     reference: reference,
  //     firstField: "statusId",
  //     firstValue: statusModel.getId,
  //     secondField: field,
  //     secondValue: value,
  //   );
  // }

  // Stream<QuerySnapshot<Object?>> getTasksForAStatusStream({
  //   required String status,
  //   required CollectionReference reference,
  //   required String field,
  //   required dynamic value,
  // }) {
  //   late StatusModel statusModel;
  //   () async {
  //     statusModel = await getDocWhere(
  //       reference: statusesRef,
  //       field: "name",
  //       value: status,
  //     );
  //   }();
  //   return queryWhereAndWhereStream(
  //     reference: reference,
  //     firstField: "statusId",
  //     firstValue: statusModel.id,
  //     secondField: field,
  //     secondValue: value,
  //   );
  // }

  // Future<double> getPercentOfTasksForAStatus(
  //     {required String field,
  //     required dynamic value,
  //     required String status,
  //     required CollectionReference reference}) async {
  //   final StatusModel statusModel = await getDocWhere(
  //     reference: statusesRef,
  //     field: "name",
  //     value: status,
  //   );
  //   int matchingStatusAndFieldValue = (await queryWhereAndWhere(
  //           reference: reference,
  //           firstField: "statusId",
  //           firstValue: statusModel,
  //           secondField: field,
  //           secondValue: value))
  //       .size;
  //   int totalMatchingFieldValue =
  //       (await queryWhere(reference: reference, field: field, value: value))
  //           .size;
  //   if (totalMatchingFieldValue == 0) {
  //     return 0;
  //   }
  //   return matchingStatusAndFieldValue / totalMatchingFieldValue;
  // }
//! TODO make this func work
  // Stream<double> getPercentOfTasksForAStatusStream(
  //     {required String field,
  //     required dynamic value,
  //     required String status,
  //     required CollectionReference reference})  {
  //   final StatusModel statusModel =  getDocWhere(
  //     reference: statusesRef,
  //     field: "name",
  //     value: status,
  //   );
  //   int matchingStatusAndFieldValue =  (queryWhereAndWhereStream(
  //           reference: reference,
  //           firstfield: "statusId",
  //           firstvalue: statusModel,
  //           secondfield: field,
  //           secondvalue: value))
  //       .length;
  //   int totalMatchingFieldValue = await (queryWhereStream(
  //           reference: reference, field: field, value: value))
  //       .length;
  //   if (totalMatchingFieldValue == 0) {
  //     return 0;
  //   }
  //   return matchingStatusAndFieldValue / totalMatchingFieldValue;
  // }

  // Future<List<t>> getTasksForAnImportance<t extends TaskClass>({
  //   required CollectionReference reference,
  //   required String field,
  //   required String value,
  //   required int importance,
  // }) async {
  //   Exception exception;
  //   if (importance < 1) {
  //     exception = Exception("importance cannot be less than 1");
  //     throw exception;
  //   }
  //   if (importance > 5) {
  //     exception = Exception("importance cannot be bigger than 5");
  //     throw exception;
  //   }
  //   return await getDocumentsWhereAndWhere(
  //     reference: reference,
  //     firstField: field,
  //     firstValue: value,
  //     secondField: "importance",
  //     secondValue: importance,
  //   );
  // }

  Stream<QuerySnapshot<Object?>>
      getTasksForAnImportanceStream<t extends TaskClass>({
    required CollectionReference reference,
    required String field,
    required String value,
    required int importance,
  }) {
    Exception exception;
    if (importance < 1) {
      exception = Exception("importance cannot be less than 1");
      throw exception;
    }
    if (importance > 5) {
      exception = Exception("importance cannot be bigger than 5");
      throw exception;
    }
    return queryWhereAndWhereStream(
      reference: reference,
      firstField: field,
      firstValue: value,
      secondField: "importance",
      secondValue: importance,
    );
  }

  Future<void> addTask({
    required TaskClass taskModel,
    required String field,
    required String value,
    required CollectionReference reference,
    required Exception exception,
  }) async {
    if (await existByTwo(
      collectionReference: reference,
      firstFiled: field,
      firstvalue: value,
      secondFiled: "name",
      secondValue: taskModel.name,
    )) {
      throw exception;
    }
    await addDoc(reference: projectSubTasksRef, model: taskModel);
  }
}
