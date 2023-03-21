import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../tops/TopModel_model.dart';

class TeamMemberModel with TopModel {
  TeamMemberModel(
      {
      //primary kay
      //الايدي الخاص بالفئة وهوه الايدي الذي سوف يوضع تلقائيا من الفاير ستور
      required String id,
      //forgin kay from UserModel
      //الايدي الخاص بالمستخدم وهو نفسو الuid تبع المستخدم
      required String userId,
      required String teamId,
      //وقت إنشاء هذه النوع من المهام
      required DateTime createdAt,
      //الوقت الذي يمثل تاريخ اي تعديل يحصل على فئة المهام
      required DateTime updatedAt}) {
    setUserId = userId;
    setTeamId = teamId;
    setId = id;
    setCreatedAt = createdAt;
    setUpdatedAt = updatedAt;
  }
  TeamMemberModel.firestoreConstructor(
      {
      //primary kay
      //الايدي الخاص بالفئة وهوه الايدي الذي سوف يوضع تلقائيا من الفاير ستور
      required String id,
      //forgin kay from UserModel
      //الايدي الخاص بالمستخدم وهو نفسو الuid تبع المستخدم
      required this.userId,
      required this.teamId,
      //وقت إنشاء هذه النوع من المهام
      required DateTime createdAt,
      //الوقت الذي يمثل تاريخ اي تعديل يحصل على فئة المهام
      required DateTime updatedAt}) {
    this.id = id;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
  }

  //forgin kay from UserModel
  //الايدي الخاص بالمستخدم مالك المهمه لايمكن ان يكون فارغ وإلا لمين هل المهمة ؟
  //ملاحظة هامة/// يجب عند إسناد هل الايدي نروح نعمل كويري نشوف هل الايدي موجود او لأ
  late String userId;
//forgin kay from TeamModel
//ايدي الفريق الذي ينتمي إليه لذلك لايمكن ان يكون فارغ
  late String teamId;

  set setTeamId(String teamId) {
    // TODO   //CheckExist(teamId,collectionName);هون منحط الميثود المسؤولة عن التأكد من وجود هل الفريق بالداتا بيز او لأ
    //وهون مجرد ماكان موجود معناها الايدي محقق للشروط
    this.teamId = teamId;
  }

  set setUserId(String userId) {
    // TODO   //CheckExist(userId,collectionName);هون منحط الميثود المسؤولة عن التأكد من وجود هل اليوزر بالداتا بيز او لأ
    //وهون مجرد ماكان موجود معناها الايدي محقق للشروط
    this.userId = userId;
  }

  @override
  set setId(String id) {
    Exception exception;
//للتاكد من انه ليس فاضي
    if (id.isEmpty) {
      exception = Exception("id cannot be empty");
      throw exception;
    }

    this.id = id;
  }

  @override
  set setCreatedAt(DateTime createdAt) {
    Exception exception;
    //يأخذ الوقت ويجري عليه التعديلات الخاصة بوقت الفايربيز لتجري عمليات الوقت عليه بدون حدوث
    // اي خطأ في اعدادات الوقت المدخل ثم يرجعه
    createdAt = firebasetime(createdAt);
    DateTime mow = firebasetime(DateTime.now());
    if (createdAt.isBefore(mow)) {
      exception = Exception("created Time Can not be last time before now ");
      throw exception;
    }
    this.createdAt = createdAt;
  }

  @override
  set setUpdatedAt(DateTime updatedAt) {
    //يأخذ الوقت ويجري عليه التعديلات الخاصة بوقت الفايربيز لتجري عمليات الوقت عليه بدون حدوث اي خطأ في اعدادات الوقت المدخل ثم يرجعه

    Exception exception;
    updatedAt = firebasetime(updatedAt);
    if (updatedAt.isBefore(getCreatedAt)) {
      exception = Exception("updatedAt Time Can not be  before created time ");
      throw exception;
    }
    this.updatedAt = updatedAt;
  }

  //لاخذ البيانات القادمة من الداتا بيز بشكل جيسون وتحويلها بشكل فوري إلى مودل
  factory TeamMemberModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;

    return TeamMemberModel(
      id: data['id'],
      userId: data['userId'],
      teamId: data['teamId'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }
  @override
  //لترحيل البيانات القادمة  من مودل على شكل جيسون (ماب) إلى الداتا بيز
  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['teamId'] = teamId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
