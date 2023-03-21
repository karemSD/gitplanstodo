import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/instance_manager.dart';

import '../collectionsrefrences.dart';
import '../models/task/UserTaskCategory_model.dart';
import 'topController.dart';
import 'user_task_controller.dart';
class UserTaskCategoryController extends TopController {
  UserTaskController taskController = Get.put(UserTaskController());
  Future<void> deleteAllCategorytasks(String categoryId) async {
    await deleteAll(usersTasksRef, "folderId", categoryId);
  }

  Future<List<UserTaskCategoryModel>> getUserCategoriesTop(
      String userId) async {
    return getAll(userId, userTaskCategoryRef, "userId");
  }

  Future<List<UserTaskCategoryModel>> getUserCategories(String userId) async {
    var categoryModel = (await query(
            reference: userTaskCategoryRef, field: "userId", value: userId))
        .docs;
    List<UserTaskCategoryModel> list = [];
    for (var element in categoryModel) {
      list.add(element.data());
    }
    return list;
  }

  Stream<QuerySnapshot<Object?>> getUserCategoriesSnapshot(String userId) {
    return (query1(
        reference: userTaskCategoryRef, field: "userId", value: userId));
  }

  Future<UserTaskCategoryModel> getbyid(String id) async {
    UserTaskCategoryModel s =
        (await query(reference: userTaskCategoryRef, field: "id", value: id))
            .data() as UserTaskCategoryModel;
    return s;
  }

  Future<void> addCategory(UserTaskCategoryModel categoryModel) async {
    await addDoc(userTaskCategoryRef, categoryModel);
  }

  Future<void> deleteCategory(String id) async {
    await delDoc(userTaskCategoryRef, id);
    await deleteAllCategorytasks(id);
  }
}
