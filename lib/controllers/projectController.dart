import 'package:auth_with_koko/collectionsrefrences.dart';
import 'package:auth_with_koko/controllers/testController.dart';
import 'package:auth_with_koko/models/team/Project_model.dart';
import 'package:auth_with_koko/services/utils_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectController extends TestController {
  Future<void> addProject({required ProjectModel projectModel}) async {
    // الشرط الأول للتأكد من انو مدير هل المشروع موجود بالداتا بيز او لأ بجدول المانجرز
    if (await existByOne(
        collectionReference: managersRef,
        filed: "id",
        value: projectModel.mangerId)) {
      if (projectModel.teamId != null) {
        //الشرط التاني انو اذا كان ضايف تتيم ضغري اول ماانشئ المشروع شوف انو هل التيم يلي ضفتو موجود بالداتا بيز اولا ويكون مدير المشروع هاد هو نفسو مدير هل التيم
        if (await existByTwo(
            collectionReference: teamsRef,
            firstFiled: "id",
            firstvalue: projectModel.teamId,
            secondFiled: "mangerId",
            secondValue: projectModel.mangerId)) {
          //في حال تحقق الشرطين انو المانجر بالداتا بيز والفريق وموجود والمناجر نفسو للتنين بيضيف المشروع
          await addDoc(reference: projectsRef, model: projectModel);
          return;
        } else {
          //في حال كان المانجر موجود بالداتا بيز والمشروع الو فريق بس هل الفريق مالو بالداتا بيز او المدير تبع هل التيم غير مدير المشروع مابيسمحلو يضيف
          Exception exception = Exception(
              "Sorry there is something Wrong about the team or the manger ");
          throw exception;
        }
      }
      {
        //في حال موجود المانجر وتمام بس مافي فريق بيضيف ضغري لانو مسموح هل الشي
        await addDoc(reference: projectsRef, model: projectModel);
        return;
      }
    } else {
      //في حال إعطاء ايدي لمانجر غير موجود بالداتا بيز اصلا
      Exception exception =
          Exception("Sorry the manger of the Project is not exist");
      throw exception;
    }
  }

// لجلب المشروع الخاص بهل الفريق  إن وجد
  Future<ProjectModel?> getProjectOfTeam({required String teamId}) async {
    DocumentSnapshot? porjectDoc = await getDocWhere(
        collectionReference: projectsRef, field: "teamId", value: teamId);
    if (porjectDoc != null) {
      return porjectDoc.data() as ProjectModel;
    }
    return null;
  }

  getProjectOfTeamStream({required String teamId}) {
    Stream<DocumentSnapshot> projectDoc = getDocWhereStream(
        collectionReference: projectsRef, field: "teamId", value: teamId);
    return projectDoc.cast<ProjectModel>();
  }

  //جلب جميع المشاريع الخاصة بهل المانجر
  Future<List<ProjectModel?>?> getProjectsOfManger(String mangerId) async {
    List<Object?>? list = await getAllWhere(
        collectionReference: projectsRef, field: "mangerId", value: mangerId);
    if (list != null && list.isNotEmpty) {
      return list.cast<ProjectModel>();
    }
    return null;
  }

  Stream<QuerySnapshot<ProjectModel>> getProjectsOfMangerStream(
      String mangerId) {
    Stream<QuerySnapshot> projectsStream = queryWhereStream(
        reference: projectsRef, field: "mangerId", value: mangerId);
    return projectsStream.cast<QuerySnapshot<ProjectModel>>();
  }

//جلب المشروع بواسطة الايدي
  Future<ProjectModel?> getProjectById({required String id}) async {
    DocumentSnapshot projectDoc =
        await getDocById(reference: projectsRef, id: id);
    return projectDoc.data() as ProjectModel?;
  }

  getProjectByIdStream({required String id}) {
    Stream<DocumentSnapshot> projectDoc =
        getDocByIdStream(reference: projectsRef, id: id);
    return projectDoc.cast<DocumentSnapshot<ProjectModel>>();
  }

//تحديث معلومات المشروع والشروط الخاصة بهذا العمل
  Future<void> updateProject(
      {required String id, required Map<String, dynamic> data}) async {
    ProjectModel? projectModel = await getProjectById(id: id);

    if (data.containsKey("startDate")) {
      DateTime? newStartDate = data['startDate'] as DateTime;
      if (newStartDate.isAfter(projectModel!.endDate!)) {
        Exception exception = Exception(
            " Start Date Of project cannot be updated cause the new time of start date is after End Date of project");
        throw exception;
      }
      if (projectModel.endDate!.isBefore(firebasetime(DateTime.now()))) {
        Exception exception = Exception(
            "can not update the start date after the end of project  date is passed");
        throw exception;
      }
      if (await existByOne(
          collectionReference: projectMainTasksRef,
          filed: "projectId",
          value: projectModel.id)) {
        Exception exception = Exception("Sorry the project is already Started");
        throw exception;
      }
    }
    if (data.containsKey("teamId")) {
      Exception exception =
          Exception("Sorry the team id  cannot be updated ");
      throw exception;
    }
    await updateNonRelationalFields(reference: projectsRef, data: data, id: id);
  }

//حذف المشروع وجميع المهام الرئيسية والفرعية الخاصة به
  Future<void> deleteProject(String id) async {
    WriteBatch batch = fireStore.batch();
    DocumentSnapshot project =
        //جلب هذا المشروع
        await getDocById(reference: projectsRef, id: id);
    ProjectModel projectModel = project.data() as ProjectModel;
    //حذفه
    deleteDocUsingBatch(documentSnapshot: project, refbatch: batch);
    //حذف الصورة الخاصة بالمشروع من الداتا بيز
    firebaseStorage.refFromURL(projectModel.imageUrl).delete();
    //جلب جميع المهام الرئيسة
    List<DocumentSnapshot> listMainTasks = await getDocsWhere(
        collectionReference: projectMainTasksRef,
        field: "projectId",
        value: id);
    //جلب جميع المهام الفرعية
    List<DocumentSnapshot> listSubTasks = await getDocsWhere(
        collectionReference: projectSubTasksRef, field: "projectId", value: id);
    //حذفهما
    deleteAllUsingBatch(list: listMainTasks, refbatch: batch);
    deleteAllUsingBatch(list: listSubTasks, refbatch: batch);
    batch.commit();
  }
}
//! check name of projects
//! method of get member by oreder of complete subtasks
//! make file of constance 
