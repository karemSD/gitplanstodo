import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


import '../collectionsrefrences.dart';
import '../models/User/User_task_Model.dart';
import 'topController.dart';

class UserTaskController extends TopController {
  Future<void> addTask(UserTaskModel taskModel) async {
    await addDoc(usersTasksRef, taskModel);
  }

  Future<void> deleteTask(String id) async {
    await delDoc(usersTasksRef, id);
  }

  Future<UserTaskModel> getbyid(String id) async {
    UserTaskModel s = (await query(reference: usersTasksRef, field: "id", value: id)).data()
            as UserTaskModel;
    print(s);
    return s;
  }

  Future<List<UserTaskModel>> getUserTasks(String userId) async {
    var taskModel =
        (await query(reference: usersTasksRef, field: "userId", value: userId))
            .docs;
    print(taskModel.runtimeType);
    List<UserTaskModel> list = [];
    for (var element in taskModel) {
      list.add(element.data());
    }
    return list;
  }

  Stream<QuerySnapshot<Object?>> getUserTasksSnapshot(String userId) {
    return (query1(reference: usersTasksRef, field: "userId", value: userId));
  }

  Stream<QuerySnapshot<Object?>> getCategoryTasksSnapshot(String folderId) {
    return (query1(
        reference: usersTasksRef, field: "folderId", value: folderId));
  }

  Future<List<UserTaskModel>> getCategoryTasks(String folderId) async {
    List<QueryDocumentSnapshot<UserTaskModel>> taskModel = (await query(
            reference: usersTasksRef, field: "folderId", value: folderId))
        .docs;
    List<UserTaskModel> list = [];
    for (var element in taskModel) {
      list.add(element.data());
    }
    return list;
    //return taskModel;
  }

  Stream<QuerySnapshot<Object?>> getChildTasksSnapshot(
      DocumentReference taskFatherId) {
    return (query1(
        reference: usersTasksRef, field: "taskFatherId", value: taskFatherId));
  }

  Future<List<UserTaskModel>> getChildTasks(
      DocumentReference taskFatherId) async {
    var taskModel = (await query(
            reference: usersTasksRef,
            field: "taskFatherId",
            value: taskFatherId))
        .docs;
    List<UserTaskModel> list = [];
    for (var element in taskModel) {
      list.add(element.data());
    }
    return list;
  }
}
