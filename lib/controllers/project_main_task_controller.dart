// // import 'package:cloud_firestore/cloud_firestore.dart';

// // import '../collectionsrefrences.dart';
// // import '../models/team/Project_main_task_Model.dart';
// // import 'topController.dart';

// import 'package:auth_with_koko/controllers/topController.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../collectionsrefrences.dart';

// class ProjectMainTaskController extends TopController {
//   Future<void> deleteProjectMainTask(String id) async {
//     WriteBatch batch = fireStore.batch();
//     await deleteDocUsingBatch(projectMainTasksRef, id, batch);
//     print("done Main");
//     await Future.delayed(const Duration(seconds: 60));
//     print("start sub");
//     await deleteA11SubTasks(id, batch);
//     batch.commit();
//   }

//   Future<void> deleteA11SubTasks(String mainTaskId, WriteBatch batch) async {
//     await deleteAllUsingBatch(
//         reference: projectSubTasksRef,
//         field: "mainTaskId",
//         value: mainTaskId,
//         refbatch: batch);
//   }
// }
// //   Future<void> deleteProjectMainTasks(String projectId) async {
// //     await deleteAll(projectMainTasksRef, "projectId", projectId);
// //   }

// //   Future<void> deleteAllSubTasks(String mainTaskId) async {
// //     await deleteAll(projectSubTasksRef, "mainTaskId", mainTaskId);
// //   }

// //   Stream<QuerySnapshot<Object?>> getProjectMainTasksSnapshot(String projectId) {
// //     return (query1(
// //         reference: usersTasksRef, field: "projectId", value: projectId));
// //   }

// //   Future<List<ProjectMainTaskModel>> getProjectMainTasks(
// //       String projectId) async {
// //     var ProjectMainTask = (await query(
// //             field: "projectId",
// //             reference: projectMainTasksRef,
// //             value: projectId))
// //         .docs;
// //     List<ProjectMainTaskModel> list = [];
// //     for (var element in ProjectMainTask) {
// //       list.add(element.data());
// //     }
// //     return list;
// //   }

// //   Future<void> addProjectMainTask(ProjectMainTaskModel taskModel) async {
// //     await addDoc(projectMainTasksRef, taskModel);
// //   }

// //   Future<void> deleteProjectMainTask(String id) async {
// //     await delDocById(projectMainTasksRef, id);
// //     await deleteAllSubTasks(id);
// //   }
// // }
