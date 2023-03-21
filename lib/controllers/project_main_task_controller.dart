import 'package:cloud_firestore/cloud_firestore.dart';


import '../collectionsrefrences.dart';
import '../models/team/Project_main_task_Model.dart';
import 'topController.dart';

class ProjectMainTaskController extends TopController {
  Future<void> deleteProjectMainTasks(String projectId) async {
    await deleteAll(projectMainTasksRef, "projectId", projectId);
  }

  Future<void> deleteAllSubTasks(String mainTaskId) async {
    await deleteAll(projectSubTasksRef, "mainTaskId", mainTaskId);
  }

  Stream<QuerySnapshot<Object?>> getProjectMainTasksSnapshot(String projectId) {
    return (query1(
        reference: usersTasksRef, field: "projectId", value: projectId));
  }

  Future<List<ProjectMainTaskModel>> getProjectMainTasks(
      String projectId) async {
    var ProjectMainTask = (await query(
            field: "projectId",
            reference: projectMainTasksRef,
            value: projectId))
        .docs;
    List<ProjectMainTaskModel> list = [];
    for (var element in ProjectMainTask) {
      list.add(element.data());
    }
    return list;
  }

  Future<void> addProjectMainTask(ProjectMainTaskModel taskModel) async {
    await addDoc(projectMainTasksRef, taskModel);
  }

  Future<void> deleteProjectMainTask(String id) async {
    await delDoc(projectMainTasksRef, id);
    await deleteAllSubTasks(id);
  }
}
