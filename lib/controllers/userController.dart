import 'package:auth_with_koko/collectionsrefrences.dart';
import 'package:auth_with_koko/controllers/categoryController.dart';
import 'package:auth_with_koko/controllers/manger_controller.dart';
import 'package:auth_with_koko/controllers/team_member_controller.dart';
import 'package:auth_with_koko/controllers/testController.dart';
import 'package:auth_with_koko/models/User/User_model.dart';
import 'package:auth_with_koko/models/User/User_task_Model.dart';
import 'package:auth_with_koko/models/task/UserTaskCategory_model.dart';
import 'package:auth_with_koko/models/team/Manger_model.dart';
import 'package:auth_with_koko/models/team/TeamMembers_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserController extends TestController {
  Future<UserModel> getUserById({required String id}) async {
    DocumentSnapshot doc = await getDocById(reference: usersRef, id: id);
    return doc.data() as UserModel;
  }

  Future<UserModel> getUserOfTask({required String userTaskId}) async {
    DocumentSnapshot userTaskDoc = await usersTasksRef.doc(userTaskId).get();
    UserTaskModel userTaskModel = userTaskDoc.data() as UserTaskModel;
    //القسم الفوقاني بهل الميثود بيستبدل بجلب الميثود عن طريق الايدي بس ليصير موجود كونترولر التاسك يوزر جاهز
    DocumentSnapshot userDoc =
        await getDocById(reference: usersRef, id: userTaskModel.userId);
    return userDoc.data() as UserModel;
  }

  Stream<DocumentSnapshot<UserModel>> getUserOfTaskStream(
      {required String userTaskId}) async* {
    DocumentSnapshot userTaskDoc = await usersTasksRef.doc(userTaskId).get();
    UserTaskModel userTaskModel = userTaskDoc.data() as UserTaskModel;
    //القسم الفوقاني بهل الميثود بيستبدل بجلب الميثود عن طريق الايدي بس ليصير موجود كونترولر التاسك يوزر جاهز
    Stream<DocumentSnapshot> stream =
        getDocByIdStream(reference: usersRef, id: userTaskModel.userId);
    yield* stream.cast<DocumentSnapshot<UserModel>>();
  }

//
  Future<UserModel> getUserOfCategory({required String categoryId}) async {
    TaskCategoryController taskCategoryController =
        Get.put(TaskCategoryController());
    UserTaskCategoryModel userTaskCategoryModel =
        await taskCategoryController.getCategoryById(id: categoryId);
    UserModel userModel = await getUserById(id: userTaskCategoryModel.userId);
    return userModel;
  }

  getUserOfcategoryStream({required String categoryId}) async* {
    TaskCategoryController taskCategoryController =
        Get.put(TaskCategoryController());
    UserTaskCategoryModel userTaskCategoryModel =
        await taskCategoryController.getCategoryById(id: categoryId);
   Stream<DocumentSnapshot> stream= getDocByIdStream(reference: usersRef, id: userTaskCategoryModel.userId);
  yield* stream.cast<DocumentSnapshot<UserModel>>(); 
  }

  ///
  Stream<DocumentSnapshot<UserModel>> getUserByIdStream({required String id}) {
    Stream<DocumentSnapshot> stream =
        getDocByIdStream(reference: usersRef, id: id);
    return stream.cast<DocumentSnapshot<UserModel>>();
  }

  Future<UserModel> getUserWhereMangerIs({required String mangerId}) async {
    MangerController mangerController = Get.put(MangerController());
    ManagerModel managerModel =
        await mangerController.getMangerById(id: mangerId);
    DocumentSnapshot userDoc =
        await getDocById(reference: usersRef, id: managerModel.userId);
    return userDoc.data() as UserModel;
  }

  Stream<DocumentSnapshot<UserModel>> getUserWhereMangerIsStream(
      {required String mangerId}) async* {
    MangerController mangerController = Get.put(MangerController());
    ManagerModel managerModel =
        await mangerController.getMangerById(id: mangerId);
    Stream<DocumentSnapshot> stream =
        getDocByIdStream(reference: usersRef, id: managerModel.userId);
    yield* stream.cast<DocumentSnapshot<UserModel>>();
  }

  Future<UserModel> getUserWhereMemberIs({required String memberId}) async {
    TeamMemberController memberController = Get.put(TeamMemberController());
    TeamMemberModel member =
        await memberController.getMemberById(memberId: memberId);
    DocumentSnapshot userDoc =
        await getDocById(reference: usersRef, id: member.userId);
    return userDoc.data() as UserModel;
  }

  Stream<DocumentSnapshot<UserModel>> getUserWhereMamberIsStream(
      {required String memberId}) async* {
    TeamMemberController memberController = Get.put(TeamMemberController());
    TeamMemberModel member =
        await memberController.getMemberById(memberId: memberId);
    Stream<DocumentSnapshot> stream =
        getDocByIdStream(reference: usersRef, id: member.userId);
    yield* stream.cast<DocumentSnapshot<UserModel>>();
  }

  Future<void> createUser({required UserModel userModel}) async {
    await addDoc(reference: usersRef, model: userModel);
  }

  Future<void> updateUser(
      {required Map<String, dynamic> data, required String id}) async {
    await updateNonRelationalFields(reference: usersRef, data: data, id: id);
  }

  Future<void> deleteUser({required String id}) async {
    MangerController mangerController = Get.put(MangerController());
    WriteBatch batch = fireStore.batch();
    List<DocumentSnapshot> membrs = await getDocsWhere(
        collectionReference: teamMembersRef, field: "userId", value: id);
    List<DocumentSnapshot> listAllSubTasks = [];
    deleteAllUsingBatch(list: membrs, refbatch: batch);
    for (var member in membrs) {
      List<DocumentSnapshot> listOfSubTasks = await getDocsWhere(
          collectionReference: projectSubTasksRef,
          field: "assignedTo",
          value: member.id);
      listAllSubTasks.addAll(listOfSubTasks);
    }
    deleteAllUsingBatch(list: listAllSubTasks, refbatch: batch);
    //  UserModel userModel = await getUserById(id: id);
    // firebaseStorage.refFromURL(userModel.imageUrl).delete();
    ManagerModel? managerModel =
        await mangerController.getMangerWhereUserIs(userId: id);
    await deleteDocUsingBatch(
        documentSnapshot: await usersRef.doc(id).get(), refbatch: batch);

    await mangerController.deleteManger(
        id: managerModel!.id, writeBatch: batch);
  }
}
