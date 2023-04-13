import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/utils_service.dart';
import '../tops/Var2TopModel.dart';

class ProjectModel extends Var2TopModel {
  //

  ProjectModel({
    required String mangerId,
    required String id,
    required String name,
    required String imageUrl,
    String? description,
    String? teamId,
    required String stausId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    setMangerId = mangerId;
    setId = id;
    setName = name;
    setImageUrl = imageUrl;
    setDescription = description;
    setTeamId = teamId;
    setStatusId = stausId;
    setCreatedAt = createdAt;
    setUpdatedAt = updatedAt;
    setStartDate = startDate;
    setEndDate = endDate;
  }

  ProjectModel.firestoreConstructor({
    required this.mangerId,
    required String id,
    required String name,
    required this.imageUrl,
    String? description,
    required this.teamId,
    required String statusId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    this.id = id;
    this.name = name;
    this.description = description;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
    this.startDate = startDate;
    this.endDate = endDate;
  }
  late String mangerId;

  late String? teamId;
  final _regex = RegExp(r'^[\p{P}\p{S}\p{N}]+$');
  //ايدي الفريق المسؤول عن هذا المشروع لايمكن ان يكون فارغ
  late String imageUrl;
  set setTeamId(String? teamId) {
    // TODO   //CheckExist(teamId,collectionName);هون منحط الميثود المسؤولة عن التأكد من وجود هل الفريق بالداتا بيز او لأ
    // مجرد مايكون التيم بالداتا بيز معناها هو محقق الشروط
    this.teamId = teamId;
  }

  set setMangerId(String mangerId) {
    // TODO   //CheckExist(teamId,collectionName);هون منحط الميثود المسؤولة عن التأكد من وجود هل القائد بالداتا بيز او لأ
    // مجرد مايكون المانجر بالداتا بيز معناها هو محقق الشروط
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
  set setStatusId(String statusId) {
    // TODO   //CheckExist(statusId,collectionName);هون منحط الميثود المسؤولة عن التأكد من وجود هل الفريق بالداتا بيز او لأ
    // مجرد مايكون التيم بالداتا بيز معناها هو محقق الشروط
    this.statusId = statusId;
  }

  @override
  set setCreatedAt(DateTime createdAt) {
    Exception exception;
    DateTime now = firebasetime(DateTime.now());
    //يأخذ الوقت ويجري عليه التعديلات الخاصة بوقت الفايربيز لتجري عمليات الوقت عليه بدون حدوث اي خطأ في اعدادات الوقت المدخل ثم يرجعه
    if (createdAt.isBefore(now)) {
      exception =
          Exception("created Time Can not be in the past of the mean time");
      throw exception;
    }
    // if (createdAt.isAfter(now)) {
    //   exception =
    //       Exception("created Time Can not in the future of the mean time");
    //   throw exception;
    // }

    this.createdAt = firebasetime(createdAt);
  }

  @override
  set setDescription(String? description) {
    this.description = description;
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

    //هذه الخاصية تستخدم لوضع قيمة لاسم المستخدم وضمان ان هذه القيمة يتم ادخالها حسب الشروط الموضوعة في التطبيق

    if (name.isEmpty) {
      //الشرط الأول لايمكن ان يكون فارغ
      exception = Exception("Team Name cannot be Empty");
      throw exception;
    }
    if (name.length <= 3) {
      //لايمكن ان يكون الاسم مألف من اقل من ثلاث محارف
      exception = Exception("Team Name cannot be less than 3 characters");
      throw exception;
    }

    if (_regex.hasMatch(name)) {
      //لايمكن ان يحوي الاسم اي ارقام او محارف خاصة فقطط احرف
      exception =
          Exception("Team Name cannot contain special characters or numbers");
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
      exception = Exception("created Time Can not be last time before now ");
      throw exception;
    }
    this.updatedAt = updatedAt;
  }

  @override
  set setStartDate(DateTime? startDate) {
    // TODO
    Exception exception;
    startDate = firebasetime(startDate!);
    DateTime now = firebasetime(DateTime.now());
    if (startDate.isBefore(now)) {
      exception = Exception(
          "Please choose any time after start date of project in five minute ");
      throw exception;
    }
    if (startDate.isBefore(getCreatedAt)) {
      exception =
          Exception("start date cannot be before created at of project ");
      throw exception;
    }
    this.startDate = startDate;
  }

  @override
  set setEndDate(DateTime? endDate) {
    // if(getStartDate!=null)
    endDate = firebasetime(endDate!);
    Exception exception;
    if (endDate.isBefore(getStartDate!)) {
      exception = Exception("this time can not be after start time of task");
      throw exception;
    }
    if (getStartDate!.isAtSameMomentAs(endDate)) {
      exception =
          Exception("this time can not be at the same moment of Start time");
      throw exception;
    }

    Duration diff = endDate.difference(getStartDate!);
    if (diff.inMinutes < 5) {
      exception = Exception(
          "the time between start time of task and ending time cannot be less then five minutes");
      throw exception;
    }
    this.endDate = endDate;
  }

  factory ProjectModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;

    return ProjectModel.firestoreConstructor(
      mangerId: data['mangerId'],
      id: data['id'],
      name: data['name'],
      teamId: data['teamId'],
      imageUrl: data['imageUrl'],
      statusId: data['statusId'],
      description: data['description'],
      createdAt: data['createdAt'].toDate(),
      updatedAt: data['updatedAt'].toDate(),
      startDate: data['startDate'].toDate(),
      endDate: data['endDate'].toDate(),
    );
  }
  @override
  //لترحيل البيانات القادمة  من مودل على شكل جيسون (ماب) إلى الداتا بيز
  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['mangerId'] = mangerId;
    data['id'] = id;
    data['teamId'] = teamId;
    data['statusId'] = statusId;
    data['description'] = description;
    data['imageUrl'] = imageUrl;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    return data;
  }
}
