import 'dart:developer' as dev;
import 'package:auth_with_koko/controllers/categoryController.dart';
import 'package:auth_with_koko/controllers/manger_controller.dart';
import 'package:auth_with_koko/controllers/projectController.dart';
import 'package:auth_with_koko/controllers/teamController.dart';
import 'package:auth_with_koko/controllers/team_member_controller.dart';
import 'package:auth_with_koko/controllers/userController.dart';
import 'package:auth_with_koko/pages/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/testController.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

TeamController teamController = Get.put(TeamController());
TestController testController = Get.put(TestController());
TaskCategoryController taskCategoryController =
    Get.put(TaskCategoryController());
TeamMemberController teamMemberController = Get.put(TeamMemberController());
MangerController mangerController = Get.put(MangerController());
UserController userController = Get.put(UserController());
// ProjectMainTaskController projectMainTaskController =
//     Get.put(ProjectMainTaskController());
void test() async {
  dev.log("work start");
  print("object");
  await userController.deleteUser(id: "kFogkqy6wWOZ267pZiTH");
  // ManagerModel model = ManagerModel(
  //     id: usersRef.doc().id,
  //     userId: "12345",
  //     createdAt: DateTime.now(),
  //     updatedAt: DateTime.now());
  // ProjectController projectController = Get.put(ProjectController());
//  await mangerController.addManger(model);
  // await mangerController.deleteManger(id: "5js0b0IciOgYaCC6xwKy");

  // TeamMemberModel teamMemberModel =
  //     await teamMemberController.getMemberById(memberId: "");

  // dev.log(list[0].name);
  // UserTaskCategoryModel userTaskCategoryModel = UserTaskCategoryModel(
  //     id: "id2",
  //     userId: "12345",
  //     name: "catss",
  //     createdAt: DateTime.now(),
  //     updatedAt: DateTime.now());
  // await taskCategoryController.addCategory(userTaskCategoryModel);
  //taskCategoryController.deleteCategory("id");
  //var token = await AuthService.getFcmToken();
  // TeamModel teamModel;
  // teamModel = TeamModel(
  //     id: teamsRef.doc().id,
  //     mangerId: "WKCkYyn4MkpUdrb5qQob",
  //     name: "team2",
  //     imageUrl: "dsdasd",
  //     createdAt: DateTime.now(),
  //     updatedAt: DateTime.now());
  // await teamController.addTeam(teamModel);
  //await projectMainTaskController.deleteProjectMainTask("La1Frqxcv0bo6OsPKQMM");
  // ProjectMainTaskModel projectMainTaskModel = ProjectMainTaskModel(
  //     projectId: "fnYDqBItazLXUSn73ioP",
  //     idParameter: projectsRef.doc().id,
  //     createdAtParameter: DateTime.now(),
  //     updatedAtParameter: DateTime.now(),
  //     startDateParameter: DateTime.now(),
  //     endDateParameter: DateTime.now().add(
  //       const Duration(minutes: 15),
  //     ),
  //     nameParameter: "fuck project",
  //     importanceParameter: 4,
  //     statusIdParameter: "12esedf",
  //     descriptionParameter: "fsdfssf");

  // projectMainTasksRef.add(projectMainTaskModel);

  // ProjectModel projectModel = ProjectModel(
  //     id: projectsRef.doc().id,
  //     name: "fuck Project",
  //     description: "dsds",
  //     createdAt: DateTime.now(),
  //     updatedAt: DateTime.now(),
  //     startDate: DateTime.now(),
  //     endDate: DateTime.now().add(
  //       const Duration(minutes: 50),
  //     ),
  //     mangerId: "WKCkYyn4MkpUdrb5qQob",
  //     imageUrl: "hgfgfg",
  //     stausId: "sds",
  //     teamId: "ewwU95seJpM6vWTFRUwx");

  // //await projectController.addProject(projectModel: projectModel);
  // await projectController.deleteProject("NuPHpNiDSqhT5U7NTAag");

  // projectMainTasksRef.add(projectMainTaskModel);
  //projectSubTasksRef.add(projectsubTaskModel);
//  teamController.addTeam(teamModel);
  // UserTaskModel userTaskModel = UserTaskModel(
  //   userId: "sdsds",
  //   folderId: "X1CfGxb5rXGDGHyS3",
  //   idParameter: "sdsdsdasd",
  //   nameParameter: "test task",
  //   statusIdParameter: "statusIdParameter",
  //   importanceParameter: 4,
  //   createdAtParameter: DateTime.now(),
  //   updatedAtParameter: DateTime.now(),
  //   startDateParameter: DateTime.now(),
  //   endDateParameter: DateTime.now().add(
  //     const Duration(minutes: 6),

  // DocumentReference ref = FirebaseFirestore.instance.collection("tasks").doc();
  // await addDoc(teamMembersRef, ref.id, teamMemberModel);
  // DocumentSnapshot<TeamMemberModel> documentSnapshot =//
  //     await getDoc(usersRef, "Vo0a6k8VJPZ9AqLZbfqX");

  // UserModel? userModel2 = documentSnapshot.data();
  // dev.log(userModel.createdAt.toString());
  //dev.log(userTaskModel.id);
  // dev.log(userTaskModel.folderId);

  // List<Object?>? querySnapshot =
  //     await testController.getAll(collectionReference: usersRef);
  // List<UserModel> list = querySnapshot!.cast<UserModel>();
  // dev.log(list[0].email.toString(), name: "number of docs");
  dev.log("work done");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // test();
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthPage(),
    );
  }
}
