import 'dart:async';
import 'package:auth_with_koko/controllers/categoryController.dart';
import 'package:auth_with_koko/controllers/teamController.dart';
import 'package:auth_with_koko/controllers/team_member_controller.dart';
import 'package:auth_with_koko/models/task/UserTaskCategory_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  TeamMemberController teamMemberController = Get.put(TeamMemberController());
  TeamController teamController = Get.put(TeamController());
  TaskCategoryController taskCategoryController =
      Get.put((TaskCategoryController()));
  void logOut() {
    FirebaseAuth.instance.signOut();
  }

  // final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        const Padding(
          padding: EdgeInsets.only(top: 22),
          child: Text(
            'LogOut',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(onPressed: logOut, icon: const Icon(Icons.logout))
      ]),
      body: Center(
        child: StreamBuilder<DocumentSnapshot<UserTaskCategoryModel>>(
          builder: ((context, snapshot) {
            return Text("hi babs   ${snapshot.data!.data()!.name} ");
          }),
          stream: taskCategoryController.getCategoryByNameForUserStream(
              userId: "12345", name: "catse"),
        ),
      ),
    );
  }
}
