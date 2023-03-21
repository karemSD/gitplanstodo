import 'VarTopModel.dart';

abstract class Var2TopModel extends VarTopModel {
  @override
  set setCreatedAt(DateTime createdAt);
  @override
  set setId(String id);
  @override
  set setName(String name);
  @override
  set setUpdatedAt(DateTime updatedAt);

  late DateTime? startDate;
  set setStartDate(DateTime? startDate);
  DateTime? get getStartDate => startDate;
  // // /////// thereis a comment
  DateTime? endDate;
  set setEndDate(DateTime? endDate);
  get getendDate => endDate;

  late String statusId;
  set setStatusId(String statusId);
  get getstatusId => statusId;

  late String? description;
  set setDescription(String description);
  get getdescription => description;

  Duration differeInTime(DateTime start, DateTime end) {
    Duration diff = end.difference(start);
    return diff;
  }
}

abstract class TaskClass extends Var2TopModel {
  late int importance;
  set setimportance(String importance);
  get getimportance => importance;

  @override
  set setId(String? id);
  @override
  set setName(String name);
  @override
  set setCreatedAt(DateTime createdAt);
  @override
  set setUpdatedAt(DateTime updatedAt);
  @override
  set setDescription(String description);
  @override
  set setStatusId(String statusId);
  @override
  set setStartDate(DateTime? startDate);
  @override
  set setEndDate(DateTime? endDate);
}
