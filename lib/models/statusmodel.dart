import 'package:cloud_firestore/cloud_firestore.dart';

import 'tops/VarTopModel.dart';

class StatusModel extends VarTopModel {
  StatusModel(
      {required String name,
      required DateTime createdAt,
      required DateTime updatedAt,
      required String id}) {
    setCreatedAt = createdAt;
    setName = name;
    setUpdatedAt = updatedAt;
    setId = id;
  }
  StatusModel.firestoreConstructor(
      {required String name,
      required DateTime createdAt,
      required DateTime updatedAt,
      required String id}) {
    this.name = name;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
    this.id = id;
  }
  @override
  set setCreatedAt(DateTime createdAtParamter) {
    Exception exception;
    //يأخذ الوقت ويجري عليه التعديلات الخاصة بوقت الفايربيز لتجري عمليات الوقت عليه بدون حدوث
    // اي خطأ في اعدادات الوقت المدخل ثم يرجعه
    if (createdAtParamter.isBefore(DateTime.now())) {
      exception = Exception("created Time Can not be in the past");
      throw exception;
    }
    createdAt = firebasetime(createdAtParamter);
  }

  @override
  set setId(String id) {
    Exception exception;

    if (id.isEmpty) {
      exception = Exception("status id cannot be empty");
      throw exception;
    }
    this.id = id;
  }

  @override
  set setName(String name) {
    Exception exception;

    //هذه الخاصية تستخدم لوضع قيمة لاسم الفئة وضمان ان هذه القيمة يتم ادخالها حسب الشروط الموضوعة في التطبيق

    if (name.isEmpty) {
      //الشرط الأول لايمكن ان يكون فارغ
      exception = Exception(" status Name cannot be Empty");
      throw exception;
    }
    if (name.length <= 3) {
      //لايمكن ان يكون الاسم مألف من اقل من ثلاث محارف
      exception = Exception("status Name cannot be less than 3 characters");
      throw exception;
    }
    //في حال مرروره على جميع الشروط وعدم رمي اكسيبشن فذلك يعني تحقيقه للشروط المطلوبة وعندها سيتم وضع القيمة
    this.name = name;
  }

  @override
  set setUpdatedAt(DateTime updatedAt) {
    Exception exception;
    updatedAt = firebasetime(updatedAt);
    if (updatedAt.isBefore(getCreatedAt)) {
      exception =
          Exception("updated Time Can not be  before Created time of status ");
      throw exception;
    }
    this.updatedAt = updatedAt;
  }

  factory StatusModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    Map<String, dynamic>? data = snapshot.data()!;
    return StatusModel.firestoreConstructor(
      name: data['name'],
      id: data['id'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }
  @override
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
