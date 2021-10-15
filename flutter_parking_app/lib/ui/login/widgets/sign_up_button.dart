import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../registracion/registration_screen.dart';

Widget signUpButton(BuildContext context) {
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
    Text("Don't have an account? "),
    GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => RegistrationScreen()));
      },
      child: Text(
        "Sign Up",
        style: TextStyle(
            color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 15),
      ),
    )
  ]);
}
