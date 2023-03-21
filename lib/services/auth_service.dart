import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../collectionsrefrences.dart';
import '../models/User/User_model.dart';


class AuthService {
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final fcmToken = await FirebaseMessaging.instance.getToken();

    usersRef.add(
      UserModel(
          name: googleUser!.displayName!,
          imageUrl: googleUser.photoUrl!,
          tokenFcm: [fcmToken!],
          id: FirebaseAuth.instance.currentUser!.uid,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now()),
    );
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  //مشان ما نعيد استخدام الفنكشن الأساسية يلي بترجع التوكين بكل فنكشن
  //حطيتها ستاتسبك مشان نوصل للإلها من أيا محل بالتطبيق بدون إنشاء نسخة من الكلاس
  static Future<String?> getFcmToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    return fcmToken;
  }
}
