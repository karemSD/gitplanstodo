import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: controller,
              onChanged: (value) {
                String s = value;
                print(s);
              },
              onSaved: (newValue) {
                print(newValue);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
                onPressed: () {
                  String s = controller.text;
                  if (s == null) {
                    print(true);
                  } else {
                    print(false);
                  }
                },
                child: Text("submit"))
          ],
        ),
      ),
    );
  }
}
