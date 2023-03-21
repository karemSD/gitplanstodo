import 'TopModel_model.dart';

abstract class VarTopModel with TopModel {
  late String name;
  set setName(String name);
  @override
  set setCreatedAt(DateTime createdAt);
  @override
  set setUpdatedAt(DateTime updatedAt);
  @override
  set setId(String id);
}

//كلاس للتجربة بس 
// class D extends VarTopModel {
//   @override
//   set setName(String nameParmeter) {
//     //شروط تنحط
//     name = nameParmeter;
//   }

//   @override
//   set setCreatedAt(DateTime createdAt) {
//     // TODO: implement setCreatedAt
//   }
//   @override
//   set setId(String? id) {
//     // TODO: implement setId
//   }
//   @override
//   set setUpdatedAt(DateTime updatedAt) {
//     createdAt = firebasetime(updatedAt);
//   }
// }
