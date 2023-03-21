import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  void logOut() {
    FirebaseAuth.instance.signOut();
  }

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        const Padding(
          padding: EdgeInsets.only(top: 22),
          child: Text(
            'LogOut',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(onPressed: logOut, icon: const Icon(Icons.logout))
      ]),
      body: Center(
        child: Text(
          "LOGGED IN!  ${user.email!}",
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
