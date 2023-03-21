import 'package:cloud_firestore/cloud_firestore.dart';

import '../tops/VarTopModel.dart';

class TeamModel extends VarTopModel {
  //الصورة سوف تكون اختيارية حيث يمكن للمستخدم اختيار صورة للبروفايل الخاص به وفي حال لم يختار سوف  يوضع له صورة افتراضية
  late String imageUrl;
  //forgin kay from MangerModel
  // الايدي الخاص بقائد الفريق  لايمكن ان يكون فارغ لانه لايوجد قائد بدون فريق
  late String mangerId;

  TeamModel({
    required String id,
    required String mangerId,
    required String name,
    required String imageUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) {
    setId = id;
    setmangerId = mangerId;
    setName = name;
    setImageUrl = imageUrl;
    setCreatedAt = createdAt;
    setUpdatedAt = updatedAt;
  }
  TeamModel.firestoreConstructor({
    required String id,
    required this.mangerId,
    required String name,
    required this.imageUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) {
    this.id = id;
    this.name = name;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
  }

  set setmangerId(String mangerId) {
    // TODO   //CheckExist(mangerId,collectionName);هون منحط الميثود المسؤولة عن التأكد من وجود هل القائد بالداتا بيز او لأ
    //وهون مجرد ماكان موجود معناها الايدي محقق للشروط
    this.mangerId = mangerId;
  }

  set setImageUrl(String imageUrl) {
    Exception exception;
    if (imageUrl.isEmpty) {
      //الشرط الأول لايمكن ان يكون فارغ
      exception = Exception("imageUrl cannot be Empty");
      throw exception;
    }
    this.imageUrl = imageUrl;
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
  set setName(String name) {
    Exception exception;

    //هذه الخاصية تستخدم لوضع قيمة لاسم الفئة وضمان ان هذه القيمة يتم ادخالها حسب الشروط الموضوعة في التطبيق

    if (name.isEmpty) {
      //الشرط الأول لايمكن ان يكون فارغ
      exception = Exception("Name cannot be Empty");
      throw exception;
    }
    if (name.length <= 3) {
      //لايمكن ان يكون الاسم مألف من اقل من ثلاث محارف
      exception = Exception("Name cannot be less than 3 characters");
      throw exception;
    }
    //في حال مرروره على جميع الشروط وعدم رمي اكسيبشن فذلك يعني تحقيقه للشروط المطلوبة وعندها سيتم وضع القيمة
    this.name = name;
  }

  @override
  set setCreatedAt(DateTime createdAt) {
    Exception exception;
    createdAt = firebasetime(createdAt);
    DateTime now = firebasetime(DateTime.now());
    //يأخذ الوقت ويجري عليه التعديلات الخاصة بوقت الفايربيز لتجري عمليات الوقت عليه بدون حدوث
    // اي خطأ في اعدادات الوقت المدخل ثم يرجعه
    if (createdAt.isBefore(now)) {
      exception = Exception("created Time Can not be last time before now ");
      throw exception;
    }
    this.createdAt = createdAt;
  }

  @override
  set setUpdatedAt(DateTime updatedAt) {
    Exception exception;
    updatedAt = firebasetime(updatedAt);
    if (updatedAt.isBefore(getCreatedAt)) {
      exception = Exception("updatedAt Time Can not before created Time ");
      throw exception;
    }
    this.updatedAt = updatedAt;
  }

// لاخذ الداتا القادمة من الجيسون وتحويلها  إلى داتا مودل
  factory TeamModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return TeamModel.firestoreConstructor(
      id: data['id'],
      mangerId: data['mangerId'],
      name: data['name'],
      imageUrl: data['imageUrl'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }
  @override
  // لترحيل بيانات المودل إلى الداتا بيز بالشكل المطلوب كجيسين
  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['mangerId'] = mangerId;
    data['name'] = name;
    data['imageUrl'] = imageUrl;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
