import 'package:cloud_firestore/cloud_firestore.dart';

import '../tops/VarTopModel.dart';

class UserTaskCategoryModel extends VarTopModel {
// لانو ببساطة هيك مارح يمرق عالخصائص ومارح يشوف الشروط كلها عبعضها ورح تفوت الدنيا بالحيط لانو رح يعطي القيمة ضغري للحقل تبع الكائن  // ملاحظة هامة جدا : ليش انا استخدمت حقول جديدة بقلب الباني وما استخدمت this.

  UserTaskCategoryModel(
      {
      //primary kay
      //الايدي الخاص بالفئة وهوه الايدي الذي سوف يوضع تلقائيا من الفاير ستور
      required String id,
      //forgin kay from UserModel
      //الايدي الخاص بالمستخدم وهو نفسو الuid تبع المستخدم
      required String userId,
      //لاسم الخاص بصنف المهام
      required String name,
      //وقت إنشاء هذه النوع من المهام
      required DateTime createdAt,
      //الوقت الذي يمثل تاريخ اي تعديل يحصل على فئة المهام
      required DateTime updatedAt}) {
    setUserId = userId;
    setName = name;
    setId = id;
    setUpdatedAt = updatedAt;
    setCreatedAt = createdAt;
  }

  UserTaskCategoryModel.firestoreConstructor(
      {
      //primary kay
      //الايدي الخاص بالفئة وهوه الايدي الذي سوف يوضع تلقائيا من الفاير ستور
      required String id,
      //forgin kay from UserModel
      //الايدي الخاص بالمستخدم وهو نفسو الuid تبع المستخدم
      required this.userId,
      //لاسم الخاص بصنف المهام
      required String name,
      //وقت إنشاء هذه النوع من المهام
      required DateTime createdAt,
      //الوقت الذي يمثل تاريخ اي تعديل يحصل على فئة المهام
      required DateTime updatedAt}) {
    this.name = name;
    this.id = id;
    this.updatedAt = updatedAt;
    this.createdAt = createdAt;
  }

  //الايدي الخاص بالمستخدم مالك المهمه لايمكن ان يكون فارغ وإلا لمين هل المهمة ؟
  //ملاحظة هامة/// يجب عند إسناد هل الايدي نروح نعمل كويري نشوف هل الايدي موجود او لأ
  late String userId;
//غلاف الغاتغوري اختياري اذا ماحط صورة بتاخد وحدة افتراضية
//  late String imageUrl;

  set setUserId(String userId) {
    // TODO   //CheckExist(userId,collectionName);هون منحط الميثود المسؤولة عن التأكد من وجود هل اليوزر بالداتا بيز او لأ
    //وهون مجرد ماكان موجود معناها الايدي محقق للشروط
    this.userId = userId;
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
    //يأخذ الوقت ويجري عليه التعديلات الخاصة بوقت الفايربيز لتجري عمليات الوقت عليه بدون حدوث اي خطأ في اعدادات الوقت المدخل ثم يرجعه
    Exception exception;
    updatedAt = firebasetime(updatedAt);
    if (updatedAt.isBefore(getCreatedAt)) {
      exception = Exception("updated Time Can not be before created Time ");
      throw exception;
    }
    this.updatedAt = updatedAt;
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

//لاخذ البيانات القادمة من الداتا بيز بشكل جيسون وتحويلها بشكل فوري إلى مودل
  factory UserTaskCategoryModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    Map<String, dynamic>? data = snapshot.data()!;
    return UserTaskCategoryModel(
      id: data['id'],
      userId: data['userId'],
      name: data['name'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }
  //لترحيل البيانات القادمة  من مودل على شكل جيسون (ماب) إلى الداتا بيز
  @override
  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['userId'] = userId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
