import 'dart:developer' as dev;
import 'package:auth_with_koko/collectionsrefrences.dart';
import 'package:auth_with_koko/controllers/topController.dart';
import 'package:auth_with_koko/models/team/Team_model.dart';
import 'package:auth_with_koko/pages/auth_page.dart';
import 'package:auth_with_koko/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'models/tops/TopModel_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

Future<void> addDoc(CollectionReference collectionReference, String docId,
    TopModel topModel) async {
  await collectionReference.add(topModel);
}

Future<void> updateDoc(CollectionReference collectionReference, String docId,
    Map<String, dynamic> data) async {
  // it works pretty
  await collectionReference.doc(docId).update(data);
}

Future<void> setDoc(CollectionReference collectionReference, String docId,
    TopModel topModel) async {
  // it works pretty
  // Map<String, dynamic> data = topModel.toFirestore();
  await collectionReference.doc(docId).set(topModel);
}

Future<void> deleteDoc(
    CollectionReference collectionReference, String docId) async {
  await collectionReference.doc(docId).delete();
}

Future<dynamic> getDoc(
    CollectionReference collectionReference, String docId) async {
  dynamic d = await collectionReference.doc(docId).get();
  return d;
}

TopController topController = Get.put(TopController());

void test() async {
  dev.log("work start");
  var token = await AuthService.getFcmToken();
  TeamModel teamModel;
  teamModel = TeamModel(
      id: teamsRef.doc().id,
      mangerId: "dsdsda",
      name: "dsdsdsd",
      imageUrl: "dsdasd",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now());
  // TeamMemberModel teamMemberModel = TeamMemberModel(
  //     teamId: "dsdasda",
  //     createdAt: DateTime.now(),
  //     updatedAt: DateTime.now(),
  //     id: "dfdfdfdf",
  //     userId: "dsdasd");
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

  DocumentReference ref = FirebaseFirestore.instance.collection("tasks").doc();
  await addDoc(teamsRef, ref.id, teamModel);
  // DocumentSnapshot<UserModel> documentSnapshot =//
  //     await getDoc(usersRef, "Vo0a6k8VJPZ9AqLZbfqX");

  // UserModel? userModel2 = documentSnapshot.data();
  // dev.log(userModel.createdAt.toString());
  //dev.log(userTaskModel.id);
  // dev.log(userTaskModel.folderId);
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
      home: const AuthPage(),
    );
  }
}
