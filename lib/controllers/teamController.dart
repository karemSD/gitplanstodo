import 'dart:math';

import 'package:auth_with_koko/collectionsrefrences.dart';
import 'package:auth_with_koko/controllers/testController.dart';

import 'package:auth_with_koko/models/team/Project_model.dart';
import 'package:auth_with_koko/models/team/Team_model.dart';
import 'package:auth_with_koko/models/tops/TopModel_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:rxdart/rxdart.dart';

class TeamController extends TestController {
  addTeam(TeamModel teamModel) async {
    if (await existByOne(
        collectionReference: managersRef,
        filed: "id",
        value: teamModel.mangerId)) {
      await addDoc(reference: teamsRef, model: teamModel);
    } else {
      Exception exception = Exception("Cannot found the manger of team");
      throw exception;
    }
  }

  Stream<DocumentSnapshot<TeamModel>> getTeamByIdStream<t extends TopModel>(
      {required String id}) {
    Stream<DocumentSnapshot> stream = getDocByIdStream(reference: teamsRef, id: id);
    return stream.cast<DocumentSnapshot<TeamModel>>();
  }

  // Stream<List<QuerySnapshot<TeamModel>>> gettt(String teamId) {
  //   Stream streamA = queryWhereStream(
  //       reference: teamsRef, field: "id", value: "3tmbQbukaupjwMeLCrVD");
  //   Stream streamB = queryWhereStream(
  //       reference: teamsRef, field: "id", value: "ewwU95seJpM6vWTFRUwx");
  //  return
  //    Rx.combineLatest2(streamA, streamB, (a, b) => [a, b]);
  // }
//جلب جميع التيمات الخاصة بهل المانجر
  Future<List<TeamModel>> getTeamsOfManger({required String mangerId}) async {
    List<Object?>? list = await getAllWhere(
        collectionReference: teamsRef, field: "mangerId", value: mangerId);
    return list!.cast<TeamModel>();
  }

  //
  Stream<QuerySnapshot<TeamModel>> getTeamsOfMangerStream(
      {required String mangerId}) {
    Stream<QuerySnapshot> stream = queryWhereStream(
        reference: teamsRef, field: "mangerId", value: mangerId);
    return stream.cast<QuerySnapshot<TeamModel>>();
  }

//getTeamOfProject(String teamIdOfproject) {}
// هي نفسها يلي تحت لانو ببساطة وقت بدك مشروع بس بتعطيه الايدي تيم يلي موجود بالكوليكشين تبعو بيقوم بيجيبو
//وهاد حسب تصميم الداتا بيز المتفق عليه
  Future<TeamModel> getTeamById({required String id}) async {
    DocumentSnapshot? documentSnapshot = await getDocWhere(
        collectionReference: teamsRef, field: "id", value: id);
    return documentSnapshot!.data() as TeamModel;
  }

  Future<TeamModel> getTeamOfProject({required ProjectModel project}) async {
    DocumentSnapshot? doc = await getDocWhere(
        collectionReference: teamsRef, field: "id", value: project.teamId);
    return doc!.data() as TeamModel;
  }

 Stream<DocumentSnapshot<TeamModel>> getTeamOfProjectStream({required ProjectModel project}) {
   Stream<DocumentSnapshot> stream= getDocWhereStream(
        collectionReference: teamsRef, field: "id", value: project.teamId);
  return stream.cast<DocumentSnapshot<TeamModel>>();
  }


  updateTeam(String id, Map<String, dynamic> data) {
    if (data.containsKey("mangerId")) {
      Exception exception = Exception("Manger Id cannot be updated");
      throw exception;
    }
    updateNonRelationalFields(reference: teamsRef, data: data, id: id);
  }

  deleteTeam({required String id}) async {
    WriteBatch batch = fireStore.batch();
    //جلب التيم المحدد لهذا الايدي
    DocumentSnapshot team = await getDocById(reference: teamsRef, id: id);
    //حذف ذلك التيم
    await deleteDocUsingBatch(documentSnapshot: team, refbatch: batch);
    //جلب المشروع الذي مستلمه هذا الفريق
    //لانو حسب ماساوينا اخر شي انو الفريق بيستلم مشروع واحد\ حسب كلام راغب كمان
    DocumentSnapshot? project = await getDocWhere(
        collectionReference: projectsRef, field: "teamId", value: id);
    //حذف هذا المشروع
    await deleteDocUsingBatch(documentSnapshot: project, refbatch: batch);
    //جلب جميع الأعضاء التي من هذا الفريق
    List<DocumentSnapshot> listOfMembes = await getDocsWhere(
        collectionReference: teamMembersRef, field: "teamId", value: id);
    //حذف الأعضاء الذي ينمتون لهذا الفريق
    await deleteAllUsingBatch(list: listOfMembes, refbatch: batch);
//جلب جميع المهام الرئيسية التي تنتمي للمشروع السابق الذي تم جلبه
    List<DocumentSnapshot> listOfMainTasks = await getDocsWhere(
        collectionReference: projectMainTasksRef,
        field: "projectId",
        value: project!.id);
    //حذف المهام الرئيسية لهذا المشروع
    await deleteAllUsingBatch(list: listOfMainTasks, refbatch: batch);

    //جلب جميع المهمات الفرعية التي من احد اعضاء هذا الفريق
    List<DocumentSnapshot> listSubTasks = [];
    for (var member in listOfMembes) {
      List<DocumentSnapshot> subTasks = await getDocsWhere(
          collectionReference: projectSubTasksRef,
          field: "assignedTo",
          value: member.id);
      listSubTasks.addAll(subTasks);
    }
    //حذف جميع هذه المهام
    await deleteAllUsingBatch(list: listSubTasks, refbatch: batch);
    batch.commit();
  }
}
