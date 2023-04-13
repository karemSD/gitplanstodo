import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/utils_service.dart';
import 'Task_model.dart';

//الكلاس الخاص بالمهمة الفرعية في البروجيكت
// why used Datetime instead of this.
// because we cant access to the fields in the sons from the abstract class that they inherit from
// so instead of making too much work we did this
class ProjectsubTaskModel extends TaskClass {
  ProjectsubTaskModel(
      {required this.projectId,
      required String mainTaskId,
      String? descriptionParameter,
      required String idParameter,
      required String nameParameter,
      required String statusIdParameter,
      required int importanceParameter,
      required DateTime createdAtParameter,
      required DateTime updatedAtParameter,
      required DateTime startDateParameter,
      required DateTime endDateParameter,
      required String assignedTo}) {
    setMainTaskId = mainTaskId;
    setId = idParameter;
    setName = nameParameter;
    setDescription = descriptionParameter;
    setStatusId = statusIdParameter;
    setimportance = importanceParameter;
    setCreatedAt = createdAtParameter;
    setUpdatedAt = updatedAtParameter;
    setStartDate = startDateParameter;
    setEndDate = endDateParameter;
    setAssignedTo = assignedTo;
  }

  ProjectsubTaskModel.firestoreConstructor(
      {required this.projectId,
      required this.mainTaskId,
      String? descriptionParameter,
      required String idParameter,
      required String nameParameter,
      required String statusIdParameter,
      required int importanceParameter,
      required DateTime createdAtParameter,
      required DateTime updatedAtParameter,
      required DateTime startDateParameter,
      required DateTime endDateParameter,
      required this.assignedTo}) {
    id = idParameter;
    name = nameParameter;
    statusId = statusIdParameter;
    importance = importanceParameter;
    createdAt = createdAtParameter;
    updatedAt = updatedAtParameter;
    startDate = startDateParameter;
    endDate = endDateParameter;
  }

  late String assignedTo;
  //الدوكيومنت اي دي الخاص بالشخص الذي سيتم اسناد المهمة له
  set setAssignedTo(String assignedToParameter) {
    //الشروط الخاصة بالدوكيومنت آي دي الخاص  بالشخص الذي سيتم اسناد المهمة له
    Exception exception;
    //لا يمكن أن يكون الدوكيومنت آي دي الخاص  بالشخص الذي سيتم اسناد المهمة له فارغاً
    if (assignedToParameter.isEmpty) {
      exception = Exception("assigned to id cannot be empty");
      throw exception;
    }
    if (!checkExist("team_members", assignedToParameter)) {
      exception = Exception("assigned to id  is not found");
      throw exception;
    }
    assignedTo = assignedToParameter;
  }

//بروجكت ايدي حسب طلب القائد لرغبات تخص مصلحة المشروع لعامة ضفتاه
  late String projectId;

  ///

  late String mainTaskId;
  //الدوكيومنت آي دي الخاص بالمهمة الأساسية في المشروع التي تندرج بداخلها المهمة الفرعية
  set setMainTaskId(String mainTaskIdParameter) {
    //الشروط الخاصة بالدوكيومنت آي دي الخاص بالمهمة الأساسية
    Exception exception;
    //لا يمكن أن يكون الدوكيومنت آي دي الخاص بالمهمة الأساسية فارغاً
    if (mainTaskIdParameter.isEmpty) {
      exception = Exception("project Main Task id cannot be empty");
      throw exception;
    }
    if (!checkExist("project_main_tasks", mainTaskIdParameter)) {
      exception = Exception("project Main Task id cannot be found");
      throw exception;
    }
    mainTaskId = mainTaskIdParameter;
  }

  @override
  set setDescription(String? descriptionParameter) {
    //يمكن لقائد المشروع أن يضيف الوصف الذي يراه مناسباً بدون قيود
    description = descriptionParameter;
  }

  @override
  set setId(String idParameter) {
    //الشروط الخاصة بالدوكيومينت آي دي الخاص بالمهمة الفرعية
    Exception exception;
    //إذا كان الآي دي فارغ لا يتم قبوله
    if (idParameter.isEmpty) {
      exception = Exception("project sub task id canno't be empty");
      throw exception;
    }
    id = idParameter;
  }

  // TODO:this method is just for demo make the method to make a query in firebase to know that if the task name already been stored in the firebase for this project for this model
  bool taskExist(String taskName) {
    return true;
  }

  @override
  set setName(String? nameParameter) {
    //الشروط الخاصة باسم المهمة الفرعية في المهمة الأساسية في البروجيكت
    Exception exception;
    //لا يمكن أن يكون اسم المهمة الفرعية في المشروع بدون قيمة
    if (nameParameter == null) {
      exception = Exception("project sub task name cannot be null");
      throw exception;
    }
    //لا يمكن أن يكون اسم المهمة الفرعية في المشروع فارغاُ
    if (nameParameter.isEmpty) {
      exception = Exception("project sub task name cannot be empty");
      throw exception;
    }
    //TODO::don't forget to edit here
    //لا يمكن أن تتواجد مهمتان فرعيتان بنفس الاسم في نفس المهممة الأساسية
    // if (taskExist(nameParameter)) {
    //   exception = Exception("task already been added");
    //   throw exception;
    // }
    name = nameParameter;
  }

  @override
  set setStatusId(String statusIdParameter) {
    //الشروط الخاصة بالدوكيومينت آي دي الخاص بالحالة
    Exception exception;
    //يتم رفض الدوكيومينت آي دي الخاص بالحالة اذا كان عديم القيمة
    if (statusIdParameter == null) {
      exception = Exception("project sub task status id cannot be null");
      throw exception;
    }
    //يتم رفض الدوكيومينت آي دي الخاص بالحالة اذا فارغاً
    if (statusIdParameter.isEmpty) {
      exception = Exception("project sub task status id canno't be empty");
      throw exception;
    }
    if (!checkExist("status", statusIdParameter)) {
      exception = Exception("status id is not found");
      throw exception;
    }
    statusId = statusIdParameter;
  }

  @override
  set setimportance(int importanceParameter) {
    //تتراوح قيمة الأهمية بين ال1 وال5
    //الشروط التي تنطبق على الأهمية
    Exception exception;
    //الأهمية لا يمكن أن تكون أقل من واحد
    if (importanceParameter < 1) {
      exception =
          Exception("project sub task importance can't be less than one");
      throw exception;
    }
    //لا يمكن أن تكون للأهمية قيمة أكبر من 5
    if (importanceParameter > 5) {
      exception =
          Exception("project sub task importance can't be bigger than five");
      throw exception;
    }
    importance = importanceParameter;
  }

  @override
  set setCreatedAt(DateTime createdAtParameter) {
    //الشروط الخاصة بتاريخ ووقت إضافة الدوكيومنت الخاص بالمهمة الفرعية
    Exception exception;
    // تاريخ إضافة المهمة يجب ان يكون بنفس تاريخ اليوم الأحسن بنفس الساعة مثل أدناه  تذكر المستخدم غبي المطور أغبى
    DateTime now = firebasetime(
      DateTime.now(),
    );
    if (firebasetime(createdAtParameter).isAfter(now)) {
      exception = Exception(
          "project sub task create time cannot be in the future of the mean time");
      throw exception;
    }
    //تاريخ إضافة الدوكيومنت لا يمكن أن يكون قبل الوقت الحالي تذكر المستخدم غبي المطور أغبى
    if (firebasetime(createdAtParameter).isBefore(now)) {
      exception = Exception(
          "project sub task create time cannot be in the past of the mean time");
      throw exception;
    }
    createdAt = firebasetime(createdAtParameter);
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    //الشروط الخاصة بال التاريخ والوقت لتحديث المهمة الفرعية في البروجيكت
    Exception exception;
    updatedAtParameter = firebasetime(updatedAtParameter);
    //اذا كان تاريخ ووقت التحديث قبل تاريخ ووقت الإضافة يتم رفضه
    // تاريخ إضافة المهمة يجب ان يكون بنفس تاريخ اليوم الأحسن بنفس الساعة مثل أدناه  تذكر المستخدم غبي المطور أغبى

    if (updatedAtParameter.isBefore(getCreatedAt)) {
      exception = Exception(
          "project sub task updating date cannot be before creating date");
      throw exception;
    }
    updatedAt = firebasetime(updatedAtParameter);
  }

  @override
  set setStartDate(DateTime? startDateParameter) {
    //الشروط الخاصة بتاريخ ووقت البداية

    Exception exception;
    //كأيا شخص ذكي بتقول لحالك انو مالازم تاريخ ووقت البداية تقبل تكون عديمة القيمة
    if (startDateParameter == null) {
      exception = Exception("project sub task start date can't be null");
      throw exception;
    }
    //تاريخ ووقت البداية البداية لا يمكن أن يكون قبل التاريخ والوقت الحالي
    //نذكر بأنه لا يمكن لأي شخص بالتفنيات الحالةي السفر عبر الزمن

    DateTime now = firebasetime(DateTime.now());
    if (startDateParameter.isBefore(now)) {
      exception = Exception(
          "project sub task start date must not be before the current day");
      throw exception;
    }
    //تاريخ ووقت بداية المهمة الفرعية لا يمكن أن يكون بعد تاريخ ووقت نهاية المهمة بديهياً
    if (startDateParameter.isBefore(getCreatedAt)) {
      exception = Exception(
          "project main task start date can't be after createdAt date of subtask");
      throw exception;
    }

    startDate = firebasetime(startDateParameter);
  }

  @override
  set setEndDate(DateTime? endDateParameter) {
    //الشروط الخاصة بتاريخ ووقت نهاية المهمة الفرعية في البروجكت
    Exception exception;
    //لا يمكن أن يكون تاريخ ووقت نهاية المهمة الفرعية معدوم القيمة
    if (endDateParameter == null) {
      exception = Exception("project sub task start date can't be null");
      throw exception;
    }
    endDateParameter = firebasetime(endDateParameter);
    //تاريخ ووقت النهاية الخاص بالمهمة الفرعية لا يمكن أن يكون قبل التاريخ والوقت الحالي
    if (endDateParameter.isBefore(
      firebasetime(
        DateTime.now(),
      ),
    )) {
      exception = Exception("end date cannot be before the current date/time");
      throw exception;
    }
    //لا يمكن أن يكون تاريخ ووقت نهاية وبداية المهمة متساويين
    //TODO check this line
    if (getStartDate!.isAtSameMomentAs(endDateParameter)) {
      exception = Exception(
        "main task start date can't be in the same time as end date",
      );
      throw exception;
    }
    //لا يمكن أن يكون هناك فارق أقل من 5 دقائق بين بداية المهمة الفرعية ونهايتها
    if (differeInTime(getStartDate!, endDateParameter).inMinutes < 5) {
      exception = Exception(
          "time between main task start time and end time must be 5 minute of longer");
      throw exception;
    }
    endDate = firebasetime(endDateParameter);
  }

  factory ProjectsubTaskModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return ProjectsubTaskModel.firestoreConstructor(
      projectId: data['projectId'],
      nameParameter: data['name'],
      idParameter: data['id'],
      assignedTo: data['assigned_to'],
      descriptionParameter: data['description'],
      mainTaskId: data['main_task_id'],
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
      'projectId': projectId,
      'name': name,
      'id': id,
      'description': description,
      'mainTaskId': mainTaskId,
      'assignedTo': assignedTo,
      'statusId': statusId,
      'importance': importance,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}
