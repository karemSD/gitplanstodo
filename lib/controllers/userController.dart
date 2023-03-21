import 'package:auth_with_koko/controllers/topController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../collectionsrefrences.dart';
import '../models/User/User_model.dart';
import 'user_task_controller.dart';

class UserController extends TopController {
  final userModel = Rxn<UserModel>();
  addUserDoc(UserModel userModel) {
    addDoc(usersRef, userModel);
  }

  Future<void> deleteUser(String id) async {
    await delDoc(usersRef, id);
  }

  Stream<QuerySnapshot<Object?>> getUserData(String userId) {
    return (query1(reference: usersRef, field: "id", value: userId));
  }

  Stream<QuerySnapshot<Object?>> getUserDataSnapshot(String userId) {
    return (query1(reference: usersRef, field: "id", value: userId));
  }

  Future<UserModel> getbyid(String id) async {
    UserModel s = (await query(reference: usersRef, field: "id", value: id))
        .docs[0]
        .data() as UserModel;
    print(s);
    return s;
  }

  Future<UserModel> getUserDocById(String uid) async {
    return (await getDocById(usersRef, uid)).data() as UserModel;
  }

  // Future<void> getUserDocs(UserModel userModel) async {
  //   // await getDoc(usersRef, id);
  //   // print(
  //   //   (await usersRef.doc(userModel.id).get()).data(),
  //   // );
  //   List<QueryDocumentSnapshot<UserModel>> list = (await getDoc(
  //           model: userModel,
  //           field: "tokenFcm",
  //           reference: usersRef,
  //           value: userModel.tokenFcm[0])
  //       as List<QueryDocumentSnapshot<UserModel>>);
  //   list.forEach((element) {
  //     print(element.data() as UserModel);
  //   });
  // }

  Future<void> deleteUserDoc(UserModel userModel) async {
    deleteDoc(usersRef, userModel);
  }

  UserTaskController taskController = Get.put(UserTaskController());
  Future<void> deleteAllUserCategories(String userId) async {
    deleteAll(userTaskCategoryRef, "userId", userId);
  }
}
