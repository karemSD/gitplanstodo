import 'package:auth_with_koko/collectionsrefrences.dart';
import 'package:auth_with_koko/controllers/testController.dart';
import 'package:auth_with_koko/models/User/User_task_Model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as dev;
import '../models/task/UserTaskCategory_model.dart';

class TaskCategoryController extends TestController {
  //حلب نوع بواسطة الايدي ستريم
  Stream<DocumentSnapshot<UserTaskCategoryModel>> getCategoryByIdStream(
      {required String id}) {
    Stream<DocumentSnapshot> stream =
        getDocByIdStream(reference: userTaskCategoryRef, id: id);
    return stream.cast<DocumentSnapshot<UserTaskCategoryModel>>();
  }

  Future<UserTaskCategoryModel> getCategoryById({required String id}) async {
    DocumentSnapshot doc =
        await getDocById(reference: userTaskCategoryRef, id: id);
    return doc.data() as UserTaskCategoryModel;
  }

  //جلب جميع انواع المهام  الخاصة بمستخدم معين
  Future<List<UserTaskCategoryModel>> getUserCategories(String userId) async {
    List<Object?>? list = await getAllWhere(
        collectionReference: userTaskCategoryRef,
        field: "userId",
        value: userId);

    return list!.cast<UserTaskCategoryModel>();
  }

  //
  Stream<QuerySnapshot<UserTaskCategoryModel>> getUserCategoriesStream(
      String userId) {
    Stream<QuerySnapshot> stream = queryWhereStream(
        reference: userTaskCategoryRef, field: "userId", value: userId);
    return stream.cast<QuerySnapshot<UserTaskCategoryModel>>();
  }

//جلب نوع مهمة حسب الأسم
  Future<UserTaskCategoryModel> getCategoryByNameForUser(
      {required String name, required String userId}) async {
    DocumentSnapshot doc = await getDocWhereAndWhere(
        collectionReference: userTaskCategoryRef,
        firstField: "name",
        firstValue: name,
        secondField: "userId",
        secondValue: userId);
    return doc.data() as UserTaskCategoryModel;
  }

//جلب نوع مهمة حسب الأسم ستريم
  Stream<DocumentSnapshot<UserTaskCategoryModel>>
      getCategoryByNameForUserStream(
          {required String name, required String userId}) async* {
    Stream<DocumentSnapshot> stream = getDocWhereAndWhereStream(
        collectionReference: userTaskCategoryRef,
        firstField: "name",
        firstValue: name,
        secondField: "userId",
        secondValue: userId);
    dev.log("fdfd");
    yield* stream.cast<DocumentSnapshot<UserTaskCategoryModel>>();
  }

// خاص بجلب جميع التاسكات يلي الها هل الغاتغوري
  Future<List<UserTaskModel>> getTasksByCategory(String folderId) async {
    List<Object?>? list = await getAllWhere(
        collectionReference: usersTasksRef, field: "folderId", value: folderId);
    return list!.cast<UserTaskModel>();
  }

//
// يجب وجود نوع  محدد يرجع هذه القيمة في الكونترولر الأب
//جلب جميع المهام التي لها نفس النوع
  Future<List<QueryDocumentSnapshot<Object?>>> getTasksByCategoryQuery(
      String folderId) async {
    dev.log("1");
    List<QueryDocumentSnapshot<Object?>> list = await getDocsWhere(
        collectionReference: usersTasksRef, field: "folderId", value: folderId);
    return list;
  }

  // اضافة نوع جديد للمهام والتأكد قبل الاضافة من وجود هذا  المستخدم الذي نضيف له هذا النوع بقاعدة البيانات
  Future<void> addCategory(UserTaskCategoryModel taskCategoryModel) async {
    Exception exception;
    bool? exist = await existByOne(
        collectionReference: usersRef,
        filed: "id",
        value: taskCategoryModel.userId);
    if (exist == true) {
      if (await existByOne(
          collectionReference: userTaskCategoryRef,
          filed: "name",
          value: taskCategoryModel.name)) {
        exception =
            Exception("Sorry but there is anthor Category has the same name ");
        throw exception;
      }
      addDoc(reference: userTaskCategoryRef, model: taskCategoryModel);
      dev.log("message");
      return;
    }
    exception = Exception("Sorry the user id cannot found ");
    throw exception;
  }

//تحديث نوع المهام
  updateCategory(
      {required Map<String, dynamic> data, required String id}) async {
    await updateNonRelationalFields(
        reference: userTaskCategoryRef, data: data, id: id);
  }

// حذف صنف محدد من المهام حيث ايضا حذف كل المهام التي لها هذا النوع من المهام  حيث لايمكن إبقاء مهمة بدون نوع لها
  deleteCategory(String categoryId) async {
    WriteBatch batch = fireStore.batch();
    DocumentSnapshot cat =
        await getDocById(reference: userTaskCategoryRef, id: categoryId);
    await deleteDocUsingBatch(documentSnapshot: cat, refbatch: batch);
    List<QueryDocumentSnapshot> listTasks = await getDocsWhere(
        collectionReference: usersTasksRef, field: "folderId", value: cat.id);
    await deleteAllUsingBatch(list: listTasks, refbatch: batch);
    batch.commit();
  }
}
