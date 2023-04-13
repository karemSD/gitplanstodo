import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/utils_service.dart';
import 'Task_model.dart';
//TODO use the firebase time

//الكلاس الخاص بالمهمة الأساسية في البروجيكت
class ProjectMainTaskModel extends TaskClass {
  //الباني الخاص بالكلاس
  ProjectMainTaskModel({
    required String projectId,
    required String descriptionParameter,
    required String idParameter,
    required String nameParameter,
    required String statusIdParameter,
    required int importanceParameter,
    required DateTime createdAtParameter,
    required DateTime updatedAtParameter,
    required DateTime startDateParameter,
    required DateTime endDateParameter,
  }) {
    setProjectId = projectId;
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

  ProjectMainTaskModel.firestoreConstructor({
    //الاي دي الخاص بالمشروع الذي تندرج تحته المهمة الأساسية
    //foreign key
    required this.projectId,
    //وصف المهمة الأساسية في المشروع
    String? descriptionParameter,
    //الاي دي الخاص بالمهمة الأساسية في المشروع
    //primary key
    required String idParameter,
    //اسم المهمة الأساسية في المشروع
    required String nameParameter,
    //اي دي الحالة الخاصة بالمهمة الأساسية
    //foreign key
    required String statusIdParameter,
    //أهمية المشروع تتراوح بين واحد وخمسة
    required int importanceParameter,
    //تاريخ إنشاء المهمة الأساسية
    required DateTime createdAtParameter,
    //تاريخ تعديل المهمة الأساسية
    required DateTime updatedAtParameter,
    //تاريخ بدء المهمة الأساسية
    required DateTime startDateParameter,
    //تاريخ انتهاء المهمة الأساسية
    required DateTime endDateParameter,
  }) {
    id = idParameter;
    description = descriptionParameter;
    name = nameParameter;
    statusId = statusIdParameter;
    importance = importanceParameter;
    createdAt = createdAtParameter;
    updatedAt = updatedAtParameter;
    startDate = startDateParameter;
    endDate = endDateParameter;
  }

  late String projectId;
  //اي دي الدوكيومنت الخاص بالمشروع الذي يتضمن المهمة الأساسية

  @override
  set setId(String idParameter) {
    //الشروط الخاصة بالدوكيومينت آي دي الخاص بالمهمة الأساسية
    Exception exception;
    //إذا كان الإي دي بدون قيمة لا يتم قبوله
    // if (idParameter == null) {
    //   exception = Exception("main task id cannot be null");
    //   throw exception;
    // }
    //إذا كان الآي دي فارغ لا يتم قبوله
    if (idParameter.isEmpty) {
      exception = Exception("main task id canno't be empty");
      throw exception;
    }
    id = idParameter;
  }

  // TODO:this method is just for demo make the method to make a query in firebase to know that if the task name already been stored in the firebase for this project for this model


  @override
  set setName(String nameParameter) {
    //الشروط الخاصة باسم المهمة الأساسية في البروجيكت
    Exception exception;
    //لا يمكن أن يكون اسم المهمة الأساسية في المشروع بدون قيمة
    // if (nameParameter == null) {
    //   exception = Exception("main task name cannot be null");
    //   throw exception;
    // }
    //لا يمكن ان يكون اسم المهمة الأساسية الخاصة بالمشروع فارغاً
    if (nameParameter.isEmpty) {
      exception = Exception("main task name cannot be empty");
      throw exception;
    }
    //لا يمكن أن تتواجد مهمتان أساسيتان بنفس الاسم في نفس البروجيكت
    //TODO: write the function taskExist
    // if (taskExist(nameParameter)) {
    //   exception = Exception("task already been added");
    //   throw exception;
    // }
    name = nameParameter;
  }

  set setProjectId(String projectIdParameter) {
    //قواعد إضافة الاي دي الخاص بالدوكيومنت الخاص بالبروجيكت الذي يحتوي المهمة
    Exception exception;
    //لا يمكن لآي دي الدوكيومنت الخاص بالبروجيكت أن يكون بدون قيمة
    // if (projectIdParameter == null) {
    //   exception = Exception("project id cannot be null");
    //   throw exception;
    // }
    //لا يمكن لآي دي الدوكيومنت الخاص بالبروجيكت أن يكون فارغاُ
    if (projectIdParameter.isEmpty) {
      exception = Exception("project id cannot be empty");
      throw exception;
    }
    if (!checkExist("projects", projectIdParameter)) {
      exception = Exception("project id is not where to be found");
      throw exception;
    }
    projectId = projectIdParameter;
  }

  @override
  set setDescription(String? descriptionParameter) {
    //يمكن لقائد المشروع أن يضيف الوصف الذي يراه مناسباً بدون قيود
    description = descriptionParameter;
  }

  @override
  set setStatusId(String statusIdParameter) {
    //الشروط الخاصة بالدوكيومينت آي دي الخاص بالحالة
    Exception exception;
    //يتم رفض الدوكيومينت آي دي الخاص بالحالة اذا فارغاً
    if (statusIdParameter.isEmpty) {
      exception = Exception("main task status id canno't be empty");
      throw exception;
    }
    if (!checkExist("status", statusIdParameter)) {
      exception = Exception("project id is not where to be found");
      throw exception;
    }
    statusId = statusIdParameter;
  }

  @override
  set setimportance(int importanceParameter) {
    //تتراوح قيمة الأهمية بين ال1 وال5
    //الشروط التي تنطبق على الأهمية
    Exception exception;
    //لا يمكن ان تكون الأهمية عديمة القيمة إن أراد قائد الفريق إضافة مهمة بدون أهمية يضيفها بنجمة واحدة
    // if (importanceParameter == null) {
    //   exception = Exception("main task importance can't be null");
    //   throw exception;
    // }
    //الأهمية لا يمكن أن تكون أقل من صفر أو تساويه
    if (importanceParameter <= 0) {
      exception = Exception("main task importance can't be less than zero");
      throw exception;
    }
    //لا يمكن أن تكون للأهمية قيمة أكبر من 5
    if (importanceParameter > 5) {
      exception = Exception("main task importance can't be bigger than five");
      throw exception;
    }
    importance = importanceParameter;
  }

  @override
  set setCreatedAt(DateTime createdAtParameter) {
    //الشروط الخاصة بتاريخ ووقت إضافة الدوكيومنت الخاص بالمهمة
    Exception exception;
    DateTime now = firebasetime(
      DateTime.now(),
    );
    // تاريخ إضافة المهمة يجب ان يكون بنفس تاريخ اليوم الأحسن بنفس الساعة مثل أدناه  تذكر المستخدم غبي المطور أغبى
    if (firebasetime(createdAtParameter).isAfter(now)) {
      exception = Exception("main task create time cannot be in the future");
      throw exception;
    }
    //تاريخ إضافة الدوكيومنت لا يمكن أن يكون قبل الوقت الحالي تذكر المستخدم غبي المطور أغبى
    if (firebasetime(createdAtParameter).isBefore(now)) {
      exception =
          Exception("project main task create time cannot be in the past");
      throw exception;
    }
    createdAt = firebasetime(createdAtParameter);
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    //الشروط الخاصة بال التاريخ والوقت لتحديث المهمة الأساسية في البروجيكت
    Exception exception;
    updatedAtParameter = firebasetime(updatedAtParameter);
    //اذا كان تاريخ ووقت التحديث قبل تاريخ ووقت الإضافة يتم رفضه
    if (updatedAtParameter.isBefore(createdAt)) {
      exception =
          Exception("task updating date cannot be before creating date");
      throw exception;
    }
    updatedAt = firebasetime(updatedAtParameter);
  }

  // TODO:this method is just for demo make the method to make a query in firebase to know that if there is another task in the same time for this model
  bool dateduplicated(DateTime starttime) {
    return true;
  }

  @override
  set setStartDate(DateTime? startDateParameter) {
    //الشروط الخاصة بتاريخ ووقت البداية
    Exception exception;
    if (startDateParameter == null) {
      //كأيا شخص ذكي بتقول لحالك انو مالازم تاريخ ووقت البداية تقبل تكون عديمة القيمة
      exception = Exception("main task start date can't be null");
      throw exception;
    }
    //TODO check this line
    //تاريخ ووقت البداية البداية لا يمكن أن يكون قبل التاريخ والوقت الحالي
    //نذكر بأنه لا يمكن لأي شخص بالتفنيات الحالةي السفر عبر الزمن
    startDateParameter = firebasetime(startDateParameter);
    DateTime now = firebasetime(DateTime.now());
    if (startDateParameter.isBefore(now)) {
      exception = Exception(
          "project main task start date must not be before the current day");
      throw exception;
    }
    //تاريخ ووقت بداية المهمة الأساسية لا يمكن أن يكون بعد تاريخ ووقت نهاية المهمة بديهياً

    //لا يمكن أن يكون هناك فارق أقل من 5 دقائق بين بداية المهمة الأساسية ونهايتها

    //TODO هل يجب ان نحذر قائد الفريق  من وجود مهام في نفس الوقت

    // startDateParameter = firebasetime(startDateParameter);
    // if (dateduplicated(startDateParameter)) {
    //   //TODOfix thie line to use the method right
    //   exception = Exception("start date can't be after end date");
    //   throw exception;
    // }
    startDate = firebasetime(startDateParameter);
  }

  @override
  set setEndDate(DateTime? endDateParameter) {
    //الشروط الخاصة بتاريخ ووقت نهاية المهمة الأساسية في البروجكت
    Exception exception;
    //لا يمكن أن يكون تاريخ ووقت نهاية المهمة معدوم القيمة
    if (endDateParameter == null) {
      exception = Exception("main task start date can't be null");
      throw exception;
    }
// TODO تم التعديل  وتزبيط الشروط
    endDateParameter = firebasetime(endDateParameter);
    DateTime now = DateTime.now();
    //تاريخ ووقت النهاية الخاص بالمهمة الأساسية لا يمكن أن يكون قبل التاريخ والوقت الحالي
    if (endDateParameter.isBefore(now)) {
      exception = Exception("end date cannot be before the current date/time");
      throw exception;
    }
    //لا يمكن أن يكون تاريخ ووقت نهاية وبداية المهمة متساويين
    if (endDateParameter.isAtSameMomentAs(getStartDate!)) {
      exception =
          Exception("end date cannot be in the same time of StartDate of task");
      throw exception;
    }
    if (differeInTime(getStartDate!, endDateParameter).inMinutes < 5) {
      exception = Exception(
          "the time between the ending time and the time of StartDate of task less then five minutes");
      throw exception;
    }

    endDate = endDateParameter;
  }

  factory ProjectMainTaskModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return ProjectMainTaskModel.firestoreConstructor(
      nameParameter: data['name'],
      idParameter: data['id'],
      descriptionParameter: data['description'],
      projectId: data['project_id'],
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
      'projectId': projectId,
      'statusId': statusId,
      'importance': importance,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}
