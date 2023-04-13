import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'dart:developer' as dev;
import '../../services/utils_service.dart';
import '../team/Task_model.dart';

//الكلاس الخاصة بالمهمة الخاصة بالمستخدم
class UserTaskModel extends TaskClass {
  //باني خاص بالصف الخاص بمهمة المستخدم
  UserTaskModel({
    required String userId,
    required String folderId,
    DocumentReference? taskFatherRef,
    String? descriptionParameter,
    required String idParameter,
    required String nameParameter,
    required String statusIdParameter,
    required int importanceParameter,
    required DateTime createdAtParameter,
    required DateTime updatedAtParameter,
    required DateTime? startDateParameter,
    required DateTime endDateParameter,
  }) {
    setUserId = userId;
    setFolderId = folderId;
    setTaskFatherId = taskFatherRef;
    //TODO الخاصيات يلي فوق هل السطر انا حطيتن
    setId = idParameter;
    setName = nameParameter;
    setDescription = descriptionParameter;
    setStatusId = statusIdParameter;
    setimportance = importanceParameter;
    setCreatedAt = createdAtParameter;
    setUpdatedAt = updatedAtParameter;
    setStartDate = startDateParameter;
    setEndDate = endDateParameter;
  }
  UserTaskModel.firestoreConstructor({
    required this.userId,
    required this.folderId,
    this.taskFatherRef,
    String? descriptionParameter,
    required String idParameter,
    required String nameParameter,
    required String statusIdParameter,
    required int importanceParameter,
    required DateTime createdAtParameter,
    required DateTime updatedAtParameter,
    required DateTime startDateParameter,
    required DateTime endDateParameter,
  }) {
    id = idParameter;
    name = nameParameter;
    statusId = statusIdParameter;
    importance = importanceParameter;
    createdAt = createdAtParameter;
    updatedAt = updatedAtParameter;
    startDate = startDateParameter;
    endDate = endDateParameter;
  }

  late String userId;
  //اي دي الدوكيومينت الخاص المستخدم الذي يملك المهمة

  late String folderId;
  //اي دي  الدوكيومينت الخاص بالمجلد التي تكون المهمة موجودة بداخله

  late DocumentReference? taskFatherRef;
  //الريفرينس للمهمة الأب إن وجدت

  set setUserId(String userIdParameter) {
    //قواعد إضافة الاي دي الخاص بالدوكيومنت الخاص بالمستخدم الذي يملك المهمة
    Exception exception;
    //لا يمكن لآي دي الدوكيومنت الخاص بالمستخدم  أن يكون فارغ
    if (userIdParameter.isEmpty) {
      exception = Exception("task user id  cannot be empty");
      throw exception;
    }

    if (!checkExist("categoreis", "")) {
      exception = Exception("task user id  is not found");
      throw exception;
    }
    userId = userIdParameter;
  }

  void setFolderIdSync(String folderIdParameter) {
    Exception exception;

    if (folderIdParameter.isEmpty) {
      exception = Exception("folder id cannot be Empty");
      throw exception;
    }

    folderId = folderIdParameter;
  }

  set setFolderId(String folderIdParameter) {
    //قواعد إضافة الاي دي الخاص بالدوكيومنت الخاص بالمستخدم الذي يملك المهمة
    // checkDocumentExistence(folderIdParameter, "users_tasks");
    //setFolderIdSync(folderIdParameter);

    Exception exception;
    //لا يمكن لآي دي الدوكيومنت الخاص بالمستخدم أن يكون فارغ
    if (folderIdParameter.isEmpty) {
      //TODO كان اكسيبشن برسالة فاضية انت بتحذر الايرور وبتربح خلاط
      exception = Exception("folder id cannot be Empty");
      throw exception;
    }
    // if ( !checkExist("categoreis", folderIdParameter)) {
    //   exception = Exception("categore task user id  is not found");
    //   throw exception;
    // }
    folderId = folderIdParameter;
  }

  //TODO (حكي نور ) لا يوجد قيود على إضافة
  set setTaskFatherId(DocumentReference? taskFatherRefParameter) {
    //TODO  هون ماكان محطوط ميثود checkExsit يعني التكاملية المرجعية عم تبكي بالزاوية
    Exception exception;
    if (taskFatherRefParameter != null) {
      if (!checkExist("user_task", taskFatherRefParameter.id)) {
        exception = Exception("the Main task of user not found");
        throw exception;
      }
      taskFatherRef = taskFatherRefParameter;
    } else {
      taskFatherRef = taskFatherRefParameter;
    }
  }
  // TODO:this method is just for demo make the method to make a query in firebase to know that if the task name already been stored in the firebase for this project for this model

  bool taskExist(String taskName) {
    return false;
  }

  @override
  set setName(String? nameParameter) {
    //الشروط الخاصة باسم المهمة
    Exception exception;
    //لا يمكن أن يكون اسم المهمة بدون قيمة
    if (nameParameter == null) {
      exception = Exception("task name cannot be null");
      throw exception;
    }
    //لا يمكن ان يكون اسم المهمة فارغاً
    if (nameParameter.isEmpty) {
      exception = Exception("task name cannot be empty");
      throw exception;
    }
    //لا يمكن ان يكون اسم المهمة مكرراً في نفس المجلد
    if (taskExist(nameParameter)) {
      exception = Exception("task already been added");
      throw exception;
    }
    name = nameParameter;
  }

  @override
  set setDescription(String? descriptionParameter) {
    description = descriptionParameter;
  }

  @override
  set setId(String idParameter) {
    //الشروط الخاصة بالدوكيومينت آي دي الخاص بالمهمة
    Exception exception;
    //إذا كان الإي دي بدون قيمة لا يتم قبوله
    // if (idParameter == null) {
    //   exception = Exception("task id cannot be null");
    //   throw exception;
    // }
    //إذا كان الآي دي فارغ لا يتم قبوله
    if (idParameter.isEmpty) {
      exception = Exception("user task id canno't be empty");
      throw exception;
    }
    id = idParameter;
  }

  @override
  set setStatusId(String statusIdParameter) {
    //الشروط الخاصة بالدوكيومينت آي دي الخاص بالحالة
    Exception exception;
    //يتم رفض الدوكيومينت آي دي الخاص بالحالة اذا كان عديم القيمة
    // if (statusIdParameter == null) {
    //   exception = Exception("status id cannot be null");
    //   throw exception;
    // }
    //يتم رفض الدوكيومينت آي دي الخاص بالحالة اذا فارغاً
    if (statusIdParameter.isEmpty) {
      exception = Exception("task status id canno't be empty");
      throw exception;
    }
    statusId = statusIdParameter;
  }

  @override
  set setimportance(int? importanceParameter) {
    //الشروط التي تنطبق على الأهمية
    Exception exception;
    //لا يمكن ان تكون الأهمية عديمة القيمة إن أراد المستخدم إضافة مهمة بدون أهمية يضيفها بنجمة واحدة
    if (importanceParameter == null) {
      exception = Exception("importance can't be null");
      throw exception;
    }
    //الأهمية لا يمكن أن تكون أقل من صفر أو تساويه
    if (importanceParameter <= 0) {
      exception = Exception("importance can't be less than zero");
      throw exception;
    }
    //الأهمية لا يمكن أن تكون أكبر من 5 وهي مهم جداً
    if (importanceParameter > 5) {
      exception = Exception("importance can't be bigger than five");
      throw exception;
    }
    importance = importanceParameter;
  }

  @override
  set setCreatedAt(DateTime createdAtParameter) {
    //الشروط الخاصة بتاريخ ووقت إضافة الدوكيومنت الخاص بالمهمة
    Exception exception;
    DateTime now = firebasetime(DateTime.now());

    // تاريخ إضافة المهمة يجب ان يكون بنفس تاريخ اليوم الأحسن بنفس الساعة مثل أدناه  تذكر المستخدم غبي المطور أغبى
    if (firebasetime(createdAtParameter).isAfter(now)) {
      exception = Exception();
      throw exception;
    }
    //تاريخ إضافة الدوكيومنت لا يمكن أن يكون قبل الوقت الحالي تذكر المستخدم غبي المطور أغبى
    if (firebasetime(createdAtParameter).isBefore(now)) {
      exception = Exception();
      throw exception;
    }
    createdAt = firebasetime(createdAtParameter);
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    //الشروط الخاصة بال التاريخ والوقت لتحديث المهمة
    Exception exception;

    //  updatedAtParameter = firebasetime(updatedAtParameter);
    //اذا كان تاريخ ووقت التحديث قبل تاريخ ووقت الإضافة يتم رفضه

    if (updatedAtParameter.isBefore(getCreatedAt)) {
      exception =
          Exception("task updating date cannot be before creating date");

      throw exception;
    }

    updatedAt = firebasetime(updatedAtParameter);
  }

  // TODO:this method is just for demo make the method to make a query in firebase to know that if there is another task in the same time for this model

  bool dateduplicated(DateTime starttime) {
    return false;
  }

  @override
  set setStartDate(DateTime? startDateParameter) {
    //الشروط الخاصة بتاريخ ووقت البداية
    Exception exception;

    if (startDateParameter == null) {
      //متل أيا عاقل حتقول لحالك انو وقت البداية مالازم يكون عديم القيمة برابو أخي
      exception = Exception("start date can't be null");
      throw exception;
    }
    // DateTime now = DateTime(
    //     DateTime.now().year,
    //     DateTime.now().month,
    //     DateTime.now().day,
    //     DateTime.now().hour,
    //     DateTime.now().minute,
    //     0,
    //     0,
    //     0);
    //مابتوقع فينك ترجع بالزمن لحتى تبلش بمهمة سو مالازم يكون وقت المهمة يبدأ قبل التاريخ والوقت الحالي ولهيك عملنا المقارنة بوقت الإنشاء يلي بناء عليه وانو هو مستحيل يكون قبل الوقت هلئ اشتغلنا
    if (startDateParameter.isBefore(createdAt)) {
      exception = Exception("end date cannot be before the Created date/time");
      throw exception;
    }
    //TODO check this line
    //التحقق من وجود مهمات بنفس الوقت لإبلاغ المستخدم عنها
    startDateParameter = firebasetime(startDateParameter);
    if (dateduplicated(startDateParameter)) {
      //TODOfix thie line to use the method right
      exception = Exception("start date can't be after end date");
      throw exception;
    }

    startDate = firebasetime(startDateParameter);
  }

  @override
  set setEndDate(DateTime? endDateParameter) {
    //الشروط الخاصة بتاريخ ووقت انتهاء المهمة
    Exception exception;
    //لا يمكن لتاريخ ووقت المهمة أن يكون عديم الوقت
    if (endDateParameter == null) {
      exception = Exception("end date can't be null");
      throw exception;
    }
    //TODO check this line
    endDateParameter = firebasetime(endDateParameter);
//TODO اتفقنا مانقارن الوقت  النهاية بالوقت الحالي وونقارن البداية بالوقت الحالي وبناء عليه نمشي
    // if (endDateParameter.isBefore(DateTime.now())) {
    //   exception = Exception("end date cannot be before the current date/time");
    //   throw exception;
    // }
    //تاريخ ووقت نهاية المهمة لا يمكن أن يكون بنفس تاريخ ووقت بداية المهمة
    if (endDateParameter.isAtSameMomentAs(startDate!)) {
      exception = Exception(
        "main task start date can't be in the same time as end date",
      );
    }
    //لا يمكن أن يكون هناك فارق أقل من 5 دقائق بين بداية المهمة الأساسية ونهايتها
    if (differeInTime(getStartDate!, endDateParameter).inMinutes < 5) {
      exception = Exception(
          "time between task start time and end time must be 5 minute or longer");
      throw exception;
    }
    endDateParameter = firebasetime(endDateParameter);
    if (endDateParameter.isBefore(getStartDate!)) {
      exception = Exception("start date can't be after end date");
      throw exception;
    }
    endDate = firebasetime(endDateParameter);
  }

  // bool CompareDates(DateTime startDate, DateTime endDate) {
  //   startDate = firebasetime(startDate);
  //   endDate = firebasetime(endDate);
  //   return startDate == endDate;
  // }

  factory UserTaskModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    Map<String, dynamic>? data = snapshot.data()!;
    return UserTaskModel.firestoreConstructor(
      nameParameter: data['name'],
      idParameter: data['id'],
      descriptionParameter: data['description'],
      userId: data['userId'],
      folderId: data['folderId'],
      taskFatherRef: data['taskFatherRef'],
      statusIdParameter: data['statusId'],
      importanceParameter: data['importance'],
      createdAtParameter: data['createdAt'].toDate(),
      updatedAtParameter: data['updatedAt'].toDate(),
      startDateParameter: data['startDate'].toDate(),
      endDateParameter: data['endDate'].toDate(),
    );
  }
  @override
  Map<String, dynamic> toFirestore() {
    
    return {
      'name': name,
      'id': id,
      'description': description,
      'userId': userId,
      'folderId': folderId,
      'taskFatherRef': taskFatherRef,
      'statusId': statusId,
      'importance': importance,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}
