import 'package:auth_with_koko/collectionsrefrences.dart';
import 'package:auth_with_koko/controllers/testController.dart';
import 'package:auth_with_koko/models/team/Manger_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MangerController extends TestController {
  addManger(ManagerModel model) async {
    if (await existByOne(
        collectionReference: usersRef, filed: "id", value: model.userId)) {
      addDoc(reference: managersRef, model: model);
    } else {
      Exception exception = Exception("user Id Not Found");
      throw exception;
    }
  }

  Future<ManagerModel> getMangerById({required String id}) async {
    DocumentSnapshot mangerDoc =
        await getDocById(reference: managersRef, id: id);
    return mangerDoc.data() as ManagerModel;
  }

  Stream<DocumentSnapshot<ManagerModel>> getMangerByIdStream(
      {required String id}) {
    Stream<DocumentSnapshot> stream =
        getDocByIdStream(reference: managersRef, id: id);
    return stream.cast<DocumentSnapshot<ManagerModel>>();
  }

  Future<ManagerModel> getMangerOfTeam(String mangerId) async {
    DocumentSnapshot? doc = await getDocWhere(
        collectionReference: managersRef, field: "id", value: mangerId);
    return doc!.data() as ManagerModel;
  }

  Stream<DocumentSnapshot<ManagerModel>> getMangerOfTeamStream(
      String mangerId) {
    Stream<DocumentSnapshot> docStream = getDocWhereStream(
        collectionReference: managersRef, field: "id", value: mangerId);
    return docStream.cast<DocumentSnapshot<ManagerModel>>();
  }

  Future<ManagerModel?> getMangerWhereUserIs({required String userId}) async {
    DocumentSnapshot? doc = await getDocWhere(
        collectionReference: managersRef, field: "userId", value: userId);
    return doc!.data() as ManagerModel;
  }

  Stream<DocumentSnapshot<ManagerModel>> getMangerWhereUserIsStream(
      String userId) {
    Stream<DocumentSnapshot> doc = getDocWhereStream(
        collectionReference: managersRef, field: "userId", value: userId);
    return doc.cast<DocumentSnapshot<ManagerModel>>();
  }

  Future<ManagerModel?> getMangerOfProject(String mangerId) async {
    DocumentSnapshot? doc = await getDocWhere(
        collectionReference: managersRef, field: "id", value: mangerId);
    return doc!.data() as ManagerModel;
  }

  Stream<DocumentSnapshot<ManagerModel>> getMangerOfProjectStream(
      String mangerId) {
    Stream<DocumentSnapshot> doc = getDocWhereStream(
        collectionReference: managersRef, field: "id", value: mangerId);
    return doc.cast<DocumentSnapshot<ManagerModel>>();
  }

  Future<void> updateManger(String id, Map<String, dynamic> data) async {
    if (data.containsKey("userId")) {
      Exception exception = Exception("userId cannot be updated");
      throw exception;
    }

    updateNonRelationalFields(reference: managersRef, data: data, id: id);
  }

  Future<void> deleteManger(
      {required String id, WriteBatch? writeBatch}) async {
    WriteBatch batch = fireStore.batch();
    if (writeBatch != null) {
      batch = writeBatch;
    }

    //جلب المانجر
    DocumentSnapshot? doc = await getDocWhere(
        collectionReference: managersRef, field: "id", value: id);
    //جلب جميع التيمات يلي الهن المناجر هاد
    List<DocumentSnapshot?>? teams = await getDocsWhere(
        collectionReference: teamsRef, field: "mangerId", value: id);
    //حذف المانجر
    await deleteDocUsingBatch(documentSnapshot: doc, refbatch: batch);
    //حذف التيمات يلي جبناهن
    await deleteAllUsingBatch(list: teams, refbatch: batch);

    List<DocumentSnapshot> members = [];
    //اضافة جميع اضاء هذه التيمات الى ليست الاعضاء
    for (var team in teams) {
      DocumentSnapshot? documentSnapshot = await getDocWhere(
          collectionReference: teamMembersRef,
          field: "teamId",
          value: team!.id);
      members.add(documentSnapshot!);
    }
    //حذف جميع الاعضاء الذي تم جلبهم
    await deleteAllUsingBatch(list: members, refbatch: batch);
    //جلب جميع البروجكتات يلي مشترك فيها واحد من التيمات يلي الها المانجر هاد
    List<DocumentSnapshot?> listProjects = [];
    for (var team in teams) {
      print("it passed");
      List<DocumentSnapshot?>? projectDos = await getDocsWhere(
          collectionReference: projectsRef, field: "teamId", value: team!.id);
      listProjects.addAll(projectDos);
    }
    //حذف جميع البروجكتات التي تم جليها
    await deleteAllUsingBatch(list: listProjects, refbatch: batch);
    //جلب جميع المهمات الرئيسية التي تنتمي لاحد المشاريع التي لها التيم الذي له هل المانجر الذي يحذف
    List<DocumentSnapshot> listMainTasks = [];
    for (var project in listProjects) {
      List<DocumentSnapshot> mainTasks = await getDocsWhere(
          collectionReference: projectMainTasksRef,
          field: "projectId",
          value: project!.id);
      listMainTasks.addAll(mainTasks);
    }
    //حذف جميع المهام الرئيسية التي تم جلبها قبل قليل
    await deleteAllUsingBatch(list: listMainTasks, refbatch: batch);
    //جلب جميع المهام التي تتبع لأحد المهام الرئيسية التي سوف يتم حذفها
    List<DocumentSnapshot> listSubTasks = [];
    for (var mainTask in listMainTasks) {
      List<DocumentSnapshot> subTasks = await getDocsWhere(
          collectionReference: projectSubTasksRef,
          field: "mainTaskId",
          value: mainTask.id);
      listSubTasks.addAll(subTasks);
    }
    //حذف جميع المهام الفرعية التي تتبع لأي مهمة رئيسة من المهام السابقة
    await deleteAllUsingBatch(list: listSubTasks, refbatch: batch);
    batch.commit();
  }
}
