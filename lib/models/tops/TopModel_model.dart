// abstract class
import 'package:auth_with_koko/collectionsrefrences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

mixin TopModel {
  /////// thereis a comment
  late String id;
  set setId(String id);
  /*ملاحظة هامة الميكسين مابتساويلك get افتراضية من عندها لهيك منعمل وحدة نحنا
  بينما الكلاس ابستركت هو بيساويها افتراضية بولادو وبيطلع الحقلل تلقائي عند الولاد
  */
  get getId => id;
  /////// thereis a comment
  late DateTime createdAt;
  set setCreatedAt(DateTime createdAt);
  DateTime get getCreatedAt => createdAt;
  // // /////// thereis a comment
  late DateTime updatedAt;
  set setUpdatedAt(DateTime updatedAt);
  DateTime get getUpdatedAt => updatedAt;

  Future<bool> checkExists(String docId, String collectionName) async {
    Exception exception;
    DocumentSnapshot docSnap =
        await fireStore.collection(collectionName).doc(docId).get();
    if (!docSnap.exists) {
      exception = Exception("categore task user id  is not found");
      throw exception;
    }
    return docSnap.exists;
  }

  Future<void> checkDocumentExistence(
      String docId, String collectionName) async {
    Exception exception;

    bool documentExists = await checkExists(collectionName, docId);
    if (!documentExists) {
      exception = Exception("categore task user id  is not found");
      throw exception;
    }
  }

//مهمتها الذهاب لقاعدة البيانات والتأكد هل هذا الايدي موجود فعليا في  الكوليكشين المطلوبة
  DateTime firebasetime(DateTime dateTime) {
    //هنا حيث نستقبل الوقت الممدخل ونتأكد من سلامة البيانات وانها تتدخل بشكل صحيح ومن ثم نرجع تلك القيمة للكائن
    DateTime newDate = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      0,
      0,
    );
    return newDate;
  }

  Map<String, dynamic> toFirestore();

  //TODO write this function
  bool checkExist(String collectionName, String id) {
    return true;
  }
}
