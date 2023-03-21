import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../components/sqaure_Button.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final userEmailController = TextEditingController();

  final passwordController = TextEditingController();

  void signInUser() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userEmailController.text, password: passwordController.text);

    Navigator.pop(context);
  }

  void errorMessage(String message) {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              '$message ❌',
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // logo App
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: SizedBox(
                    width: 250,
                    child: Image.asset('lib/images/KAREM.jpg'),
                  ),
                ),

                //say Hi
                Text(
                  'Nice to see You!',
                  style: GoogleFonts.pacifico(fontSize: 30),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Email field
                myTextFiled(
                  obscureText: false,
                  controller: userEmailController,
                  hinText: 'Email',
                  inputType: TextInputType.emailAddress,
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                // password field

                myTextFiled(
                  obscureText: true,
                  controller: passwordController,
                  hinText: 'Password',
                  inputType: TextInputType.visiblePassword,
                  prefixIcon: const Icon(
                    Icons.key,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                //forget Password

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text(
                        'Forget Password?',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(
                  height: 5,
                ),
                //Login button

                MyButton(
                  onTap: signInUser,
                  buttonText: 'Sign In',
                  color: Colors.deepPurpleAccent,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Or Continue With'),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                // Google icon Sign in
                SquareButtonIcon(
                    imagePath: 'lib/images/google.png',
                    onTap: () {
                      AuthService().signInWithGoogle();
                    }),
                const SizedBox(
                  height: 10,
                ),
                // not registered make am account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account? '),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Make One!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
