

import 'package:auth_with_koko/collectionsrefrences.dart';
import 'package:auth_with_koko/controllers/testController.dart';
import 'dart:developer' as dev;

import 'package:auth_with_koko/models/team/TeamMembers_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeamMemberController extends TestController {
  Future<List<TeamMemberModel>> getMemberWhereUserIs(
      {required String userId}) async {
    List<Object?>? list = await getAllWhere(
        collectionReference: teamMembersRef, field: "userId", value: userId);
    return list!.cast<TeamMemberModel>();
  }

  Stream<QuerySnapshot<TeamMemberModel>> getMemberWhereUserIsStream(
      {required String userId}) {
    Stream<QuerySnapshot> stream = queryWhereStream(
        reference: teamMembersRef, field: "userId", value: userId);
    return stream.cast<QuerySnapshot<TeamMemberModel>>();
  }

  Future<TeamMemberModel> getMemberById({required String memberId}) async {
    DocumentSnapshot doc =
        await getDocById(reference: teamMembersRef, id: memberId);
    return doc.data() as TeamMemberModel;
  }

  Stream<DocumentSnapshot<TeamMemberModel>> getMamberByIdStream(
      {required String memberId}) {
    Stream<DocumentSnapshot> stream = getDocByIdStream(reference: teamMembersRef, id: memberId);
    return stream.cast<DocumentSnapshot<TeamMemberModel>>();
  }

  Future<List<TeamMemberModel>> getMembersInTeamId(
      {required String teamId}) async {
    List<Object?>? list = await getAllWhere(
        collectionReference: teamMembersRef, field: "teamId", value: teamId);
    List<TeamMemberModel> listOfMembers = list!.cast<TeamMemberModel>();
    return listOfMembers;
  }

  Stream<QuerySnapshot<TeamMemberModel>> getMembersInTeamIdStream(
      {required String teamId}) {
    Stream<QuerySnapshot> stream = queryWhereStream(
        reference: teamMembersRef, field: "teamId", value: teamId);
    return stream.cast<QuerySnapshot<TeamMemberModel>>();
  }

 Future<TeamMemberModel> getMemberByTeamIdAndUserId(
      {required String teamId, required String userId}) async {
    DocumentSnapshot doc = await getDocWhereAndWhere(
        collectionReference: teamMembersRef,
        firstField: "teamId",
        firstValue: teamId,
        secondField: "userId",
        secondValue: userId);
    return doc.data() as TeamMemberModel;
  }

Stream<DocumentSnapshot<TeamMemberModel>>  getMemberByTeamIdAndUserIdStream(
      {required String teamId, required String userId}) {
    Stream<DocumentSnapshot> stream = getDocWhereAndWhereStream(
        collectionReference: teamMembersRef,
        firstField: "teamId",
        firstValue: teamId,
        secondField: "userId",
        secondValue: userId);
     return stream.cast<DocumentSnapshot<TeamMemberModel>>();
  }

  Future<void> addMember({required TeamMemberModel teamMemberModel}) async {
    Exception exception;
    if (await existInTowPlaces(
        firstCollectionReference: usersRef,
        firstFiled: "id",
        firstvalue: teamMemberModel.userId,
        secondCollectionReference: teamsRef,
        secondFiled: "id",
        secondValue: teamMemberModel.teamId)) {
      addDoc(reference: teamMembersRef, model: teamMemberModel);
    } else {
      exception = Exception("Sorry but Team Or user of this member not found");
      throw exception;
    }
  }

  Future<void> updateMemeber(
      {required id, required Map<String, dynamic> data}) async {
    Exception exception;
    if (data.containsKey("teamId") || data.containsKey("userId")) {
      exception = Exception("Sorry Team id Or user id  cannot be updated");
      throw exception;
    }
    await updateNonRelationalFields(
        reference: teamMembersRef, data: data, id: id);
  }

  Future<void> deleteMember({required String id}) async {
      WriteBatch batch = fireStore.batch();
 
    DocumentSnapshot member =
        await getDocById(reference: teamMembersRef, id: id);
    List<DocumentSnapshot> listOfSubTasks = await getDocsWhere(
        collectionReference: projectSubTasksRef,
        field: "assignedTo",
        value: id);
    await deleteDocUsingBatch(documentSnapshot: member, refbatch: batch);
    await deleteAllUsingBatch(list: listOfSubTasks, refbatch: batch);
    batch.commit();
  }
}
