import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';

import '../../services/auth_service.dart';
import '../../services/utils_service.dart';
import '../tops/VarTopModel.dart';

class UserModel extends VarTopModel {
  //اسم المستخدم الذي يظهر للأخرين في التطبيق

  late String imageUrl;
  //اليوزر نيم الخاص بكل مستخدم والذي لايمكن ان يتكرر بين اي مستخدم وهو لغرض تمكين المستخدمين الاخرين من البحث عن مستخدم اخر بواسطته
  late String? userName;

  //والذي يمثل شرح قصير عن المستخدم ويمكن للمستخدمين الاخرين رؤيته بالبروفايل الخاص بهذا المستخدم
  late String? bio;
  //  الايميل الخاص بالمستخدم  ويطلب في حال اراد المستخدم تسجيل الدخول بشكل غير انونمسيلي ولذلك يمكن ان يكون فارغ
  //ملاحظة هامة  :   //  ماذا يحدث للايميل في حال تم تسجيل الدخول بواسطة فيسبوك او جوجل ؟؟؟؟
  late String? email;

  /*التوكين مسجينغ وهو خاص بكل تطبيق بالجهاز حيث كل نسخة  مختلفة للتطبيق على كل جهاز لها توكين مسجينغ خاص به ونستخدمه
   وتم وضعه كمصفوفة لانه من الممكن ان يكون المستخدم له عدة اجهزة لنفس الحساب وبالتالي عدة توكين مسيجينغ لنفس الشخص
*/
  late List<String?> tokenFcm = [];

  //يستخدم لجعل المستخدم قادر على إدخال احرف فقط اي بدون ارقام او محارف خاصة

//الباني
  UserModel(
      {required String name,
      // البحث عنه حاليا شلنا الريكويرد اليوزر نيم  لانو المستخدم ممكن عند إنشاء التطبيق  لايريد إنشاءه فهو للاستخدام الشخصي مثلا او  ولا يريد لاحد  إيجاده مثلا متل التلغرام
      String? userName,
      //الصورة سوف تكون اختيارية حيث يمكن للمستخدم اختيار صورة للبروفايل الخاص به وفي حال لم يختار سوف  يوضع له صورة افتراضية
      required String imageUrl,
      String? email,
      //شلنا الريكويرد البيو لانو المستخدم ممكن مابدو هلئ يحط مثلا ايا فقرة شرح عنو او ايا شي بيخليها فاضية يعني مالها ريكويرد
      String? bio,
      required this.tokenFcm,
      //primary kay
      //id الخاص بالمستخدم سوف يكون (uid) المقدم من فايربيز اوزنتيكيشن
      required String id,
      //وقت إنشاء حساب المستخدم
      required DateTime createdAt,
      //الوقت الذي بمثل تاريخ إي تعديل حصل على الحساب
      //ملاحظة هامة  :   //  هل تاريخ التعديل عند إنشاء الحساب ياخد قيمة ابتدائية لتاريخ إنشاء الحساب أو يبقى فارغ حتى يجري السمتخدم اي تعديل وعندها ياخذ قيمة ؟
      required DateTime updatedAt}) {
    setBio = bio;
    setEmail = email;
    setUserName = userName;
    setImageUrl = imageUrl;
    setName = name;
    setId = id;
    setCreatedAt = createdAt;
    setUpdatedAt = updatedAt;

    addTokenFcm();
  }
  UserModel.firestoreConstructor(
      {required String name,
      // البحث عنه حاليا شلنا الريكويرد اليوزر نيم  لانو المستخدم ممكن عند إنشاء التطبيق  لايريد إنشاءه فهو للاستخدام الشخصي مثلا او  ولا يريد لاحد  إيجاده مثلا متل التلغرام
      this.userName,
      //الصورة سوف تكون اختيارية حيث يمكن للمستخدم اختيار صورة للبروفايل الخاص به وفي حال لم يختار سوف  يوضع له صورة افتراضية
      required this.imageUrl,
      this.email,
      //شلنا الريكويرد البيو لانو المستخدم ممكن مابدو هلئ يحط مثلا ايا فقرة شرح عنو او ايا شي بيخليها فاضية يعني مالها ريكويرد
      this.bio,
      required this.tokenFcm,
      //primary kay
      //id الخاص بالمستخدم سوف يكون (uid) المقدم من فايربيز اوزنتيكيشن
      required String id,
      //وقت إنشاء حساب المستخدم
      required DateTime createdAt,
      //الوقت الذي بمثل تاريخ إي تعديل حصل على الحساب
      //ملاحظة هامة  :   //  هل تاريخ التعديل عند إنشاء الحساب ياخد قيمة ابتدائية لتاريخ إنشاء الحساب أو يبقى فارغ حتى يجري السمتخدم اي تعديل وعندها ياخذ قيمة ؟
      required DateTime updatedAt}) {
    this.name = name;
    this.id = id;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
    addTokenFcm();
  }

  RegExp regEx = RegExp(r"(?=.*[0-9])\w+");
  RegExp regEx2 = RegExp(r'[^\w\d\u0600-\u06FF\s]');
  @override
  set setName(String name) {
    Exception exception;

    //هذه الخاصية تستخدم لوضع قيمة لاسم المستخدم وضمان ان هذه القيمة يتم ادخالها حسب الشروط الموضوعة في التطبيق

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
    if (regEx.hasMatch(name) || regEx2.hasMatch(name)) {
      exception = Exception('name can include letters only ');
      throw exception;
    }

    this.name = name;
  }

  set setUserName(String? userName) {
    Exception exception;
    if (userName == null) {
      this.userName = userName;
      return;
    }
    if (userName.isEmpty) {
      //الشرط الأول لايمكن ان يكون فارغ
      exception = Exception("username cannot be Empty");
      throw exception;
    }
    if (userName.length <= 3) {
      //لايمكن ان يكون اليوزرنيم مألف من اقل من ثلاث محارف
      exception = Exception("username cannot be less than 3 characters");
      throw exception;
    }
    if (userName.length >= 20) {
      //لايمكن ان يكون اليوزرنيم مألف من اكثر من عشرين محارف
      exception = Exception("username cannot be more than 20 characters");
      throw exception;
    }
    this.userName = userName;
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

  set setEmail(String? email) {
    //هذه الخاصية تستخدم لوضع قيمة لايميل المستخدم  وضمان انها تحقق جميع الشروط الخاصة بأي ايميل صحيح متل احتوائه على (@gmail .com والعديد من الشروط الأخرى)

    if (email != null) {
      if (!EmailValidator.validate(email)) {
        //وفي ذلك الهدف نستخدم الباكج  email_validator
        throw Exception("Enter a valid email");
      }
      this.email = email;
    } else {
      this.email = email;
    }
    //في حال تحقيقه الشروط لن يرمي اكسيبشن وبذلك تدخل القيمة بشكل سليم
  }

  set setBio(String? bio) {
    this.bio = bio;
  }
/*
ملاحظة كان ممكن حط متل هيك واختصر عحالي ساوي كائن من نوع اكسيبشن بس مو انا بدي ارمي رسالة الاكسبيشن بالدبياج باستخدام بكج Logger
فوقتها رح احتاج الكائن لاطبع الرسالة تبعو بشكل فوري 
 throw Exception("token fcm is not valid should contain :");
*/

  void addTokenFcm() async {
    Exception exception;

    String? tokenFcm = await AuthService.getFcmToken();
    if (!tokenFcm!.contains(":")) {
      //في حال عدم احتوائه على هذ الكاركتر الذي من المفترض وجوده بكل توكين فهذا يعني انه توكين غير صالح للاستخدام
      exception = Exception("token fcm is not valid should contain :");
      throw exception;
    }
    if (tokenFcm.contains(" ")) {
      //من خصائصه ايضا انه من المستحيل احتواء التوكين على سبيسات
      exception =
          Exception("token fcm is not valid should not have empty spaces");
      throw exception;
    }

    //اضافة القيمة إلى المصفوفة الخاصة بالتوكين الخاص بأجهزة المستخدم
    this.tokenFcm.add(tokenFcm);
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
  set setCreatedAt(DateTime createdAt) {
    Exception exception;
    createdAt = firebasetime(createdAt);

    DateTime now = firebasetime(DateTime.now());
    if (createdAt.isBefore(now)) {
      exception =
          Exception("created Time Can not be in the past of the mean time");
      throw exception;
    }
    if (createdAt.isAfter(now)) {
      exception =
          Exception("created Time Can not be in the future of the mean time");
      throw exception;
    }

    this.createdAt = createdAt;
  }

  @override
  set setUpdatedAt(DateTime updatedAt) {
    Exception exception;
    updatedAt = firebasetime(updatedAt);
    if (updatedAt.isBefore(getCreatedAt)) {
      exception = Exception(
          "updated Time Can not be before created time of user account");
      throw exception;
    }
    this.updatedAt = updatedAt;
  }

//لاخذ البيانات القادمة من الداتا بيز بشكل جيسون وتحويلها بشكل فوري إلى مودل
  factory UserModel.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    Map<String, dynamic> data = snapshot.data()!;

    // عملنا هل الحركة لانو اجباري البيانات كمصفوفة بالداتا بيز توضع كمصفوفة داينيميك لهيك لما تجي منحولها لليست سترينغ ونضعها ضمن المودل
    //List<dynamic> list = data['tokenFcm'].cast<String>();
    // List<String> listString = list.cast<String>();
    //
    // Timestamp dateTimeCreatedAt = data['createdAt'];
    // Timestamp dateTimeUpdatedAt = data['updatedAt'];
    //
    
    //
    return UserModel.firestoreConstructor(
      name: data['name'],
      userName: data['userName'],
      bio: data['bio'],
      imageUrl: data['imageUrl'],
      email: data['email'],
      tokenFcm: data['tokenFcm'].cast<String>(),
      // TODO 
      //id: snapshot.id,
      id: data['id'],
      createdAt: data['createdAt'].toDate(),
      updatedAt: data['updatedAt'].toDate(),
    );
  }
  //لترحيل البيانات القادمة  من مودل على شكل جيسون (ماب) إلى الداتا بيز
  @override
  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['userName'] = userName;
    data['bio'] = bio;
    data['imageUrl'] = imageUrl;
    data['email'] = email;
    data['tokenFcm'] = tokenFcm;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
