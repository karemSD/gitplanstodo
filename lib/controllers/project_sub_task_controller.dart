// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../collectionsrefrences.dart';
// import '../models/team/Project_main_task_Model.dart';
// import '../models/team/Project_sub_task_Model.dart';
// import 'topController.dart';

// class ProjectMainTaskController extends TopController {
//   Stream<QuerySnapshot<Object?>> getMainTaskSubTasksSnapshot(
//       String mainTaskId) {
//     return (query1(
//       reference: projectMainTasksRef,
//       field: "mainTaskId",
//       value: mainTaskId,
//     ));
//   }

//   Future<List<ProjectsubTaskModel>> getMainTaskSubTasks(
//       String mainTaskId) async {
//     var ProjectsubTask = (await query(
//       field: "mainTaskId",
//       reference: projectMainTasksRef,
//       value: mainTaskId,
//     ))
//         .docs;
//     List<ProjectsubTaskModel> list = [];
//     for (var element in ProjectsubTask) {
//       list.add(element.data());
//     }
//     return list;
//   }

//   Future<void> addProjectSubTask(ProjectMainTaskModel taskModel) async {
//     int x = await exist(
//         field2: "name",
//         field: "projectId",
//         reference: projectSubTasksRef,
//         value2: taskModel.name,
//         value: taskModel.projectId);
//     if (x >= 1) {
//       Exception exception;
//       throw exception = Exception("task already exist");
//     }
//     await addDoc(projectSubTasksRef, taskModel);
//   }

//   Future<void> deleteProjectSubTask(String id) async {
//     await delDocById(projectSubTasksRef, id);
//   }
// }
