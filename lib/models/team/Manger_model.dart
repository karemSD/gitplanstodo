import 'package:cloud_firestore/cloud_firestore.dart';

import '../tops/TopModel_model.dart';

class ManagerModel with TopModel {
  //الايدي الخاص بالمستخدم الذي هو القائد لايمكن ان يكون فارغ وإلا مين هو ؟
  //ملاحظة هامة/// يجب عند إسناد هل الايدي نروح نعمل كويري نشوف هل الايدي موجود او لأ
  late String userId;

  ManagerModel({
    //primary kay
    //الايدي الخاص بقائد الفريق  وهوه الايدي الذي سوف يوضع تلقائيا من الفاير ستور
    required String id,
    //forgin kay from UserModel
    //الايدي الخاص بالمستخدم وهو نفسو الuid تبع المستخدم
    required String userId,
    //الوقت الذي أنشأ المستخدم أول فريق له وكان مديراً عليه
    required DateTime createdAt,
    //الوقت الذي يمثل أي تعديل يحصل على قائد الفريق
    required DateTime updatedAt,
  }) {
    setUserId = userId;
    setId = id;
    setCreatedAt = createdAt;
    setUpdatedAt = updatedAt;
  }
  ManagerModel.firestoreConstructor({
    //primary kay
    //الايدي الخاص بقائد الفريق  وهوه الايدي الذي سوف يوضع تلقائيا من الفاير ستور
    required String id,
    //forgin kay from UserModel
    //الايدي الخاص بالمستخدم وهو نفسو الuid تبع المستخدم
    required this.userId,
    //الوقت الذي أنشأ المستخدم أول فريق له وكان مديراً عليه
    required DateTime createdAt,
    //الوقت الذي يمثل أي تعديل يحصل على قائد الفريق
    required DateTime updatedAt,
  }) {
    this.id = id;
    this.updatedAt = updatedAt;
    this.createdAt = createdAt;
  }

  set setUserId(String userId) {
    // TODO //CheckUser(userId);هون منحط الميثود المسؤولة عن التأكد من وجود هل اليوزر بالداتا بيز او لأ
    //وهون مجرد ماكان موجود معناها الايدي محقق للشروط
    this.userId = userId;
  }

  @override
  set setCreatedAt(DateTime createdAt) {
    Exception exception;
    //يأخذ الوقت ويجري عليه التعديلات الخاصة بوقت الفايربيز لتجري عمليات الوقت عليه بدون حدوث
    // اي خطأ في اعدادات الوقت المدخل ثم يرجعه
    if (createdAt.isBefore(DateTime.now())) {
      exception = Exception("created Time Can not be last time before now ");
      throw exception;
    }
    this.createdAt = firebasetime(createdAt);
  }

  @override
  set setId(String id) {
    Exception exception;

    if (id.isEmpty) {
      exception = Exception("id cannot be empty");
      throw exception;
    }

    this.id = id;
  }

  @override
  set setUpdatedAt(DateTime updatedAt) {
    //يأخذ الوقت ويجري عليه التعديلات الخاصة بوقت الفايربيز لتجري عمليات الوقت عليه بدون حدوث اي خطأ في اعدادات الوقت المدخل ثم يرجعه
    Exception exception;
    updatedAt = firebasetime(updatedAt);
    if (updatedAt.isBefore(getCreatedAt)) {
      exception = Exception(" updated time Can not be  before created Time ");
      throw exception;
    }
    this.updatedAt = updatedAt;
  }

  //لاخذ البيانات القادمة من الداتا بيز بشكل جيسون وتحويلها بشكل فوري إلى مودل
  factory ManagerModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return ManagerModel.firestoreConstructor(
      id: data['id'],
      userId: data['userId'],
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
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
