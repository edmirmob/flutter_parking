import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parking_app/services/firebase_service.dart';
import 'package:flutter_parking_app/ui/login/login_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/model/user_model.dart';
import '../../shared/custom_eleveted_button.dart';
import '../../shared/custom_text_form_filed.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  final firstNameEditingController = new TextEditingController();
  final secondNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();
  bool chechController = false;
  final service = FirebaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.blue),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 180,
                        child: Image.asset(
                          "assets/images/logo.png",
                          fit: BoxFit.contain,
                        )),
                    SizedBox(height: 45),
                    CustomTextFormField(
                      autofocus: false,
                      textEditingController: firstNameEditingController,
                      keyboardType: TextInputType.name,
                      validation: (String value) {
                        RegExp regex = new RegExp(r'^.{3,}$');
                        if (value.isEmpty) {
                          return ("First Name cannot be Empty");
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Enter Valid name(Min. 3 Character)");
                        }
                        return null;
                      },
                      icon: Icon(Icons.account_circle),
                      hintText: "First Name",
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 20),
                    CustomTextFormField(
                      autofocus: false,
                      textEditingController: secondNameEditingController,
                      keyboardType: TextInputType.name,
                      validation: (String value) {
                        if (value.isEmpty) {
                          return ("Second Name cannot be Empty");
                        }
                        return null;
                      },
                      icon: Icon(Icons.account_circle),
                      hintText: "Second Name",
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 20),
                    CustomTextFormField(
                      autofocus: false,
                      textEditingController: emailEditingController,
                      keyboardType: TextInputType.emailAddress,
                      validation: (String value) {
                        if (value.isEmpty) {
                          return ("Please Enter Your Email");
                        }
                        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(value)) {
                          return ("Please Enter a valid email");
                        }
                        return null;
                      },
                      icon: Icon(Icons.mail),
                      hintText: "Email",
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 20),
                    CustomTextFormField(
                      autofocus: false,
                      textEditingController: passwordEditingController,
                      validation: (String value) {
                        RegExp regex = new RegExp(r'^.{6,}$');
                        if (value.isEmpty) {
                          return ("Password is required for login");
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Enter Valid Password (Min. 6 Character)");
                        }
                        return null;
                      },
                      icon: Icon(Icons.vpn_key),
                      hintText: "Password",
                      textInputAction: TextInputAction.next,
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    CustomTextFormField(
                      autofocus: false,
                      textEditingController: confirmPasswordEditingController,
                      validation: (String value) {
                        if (confirmPasswordEditingController.text !=
                            passwordEditingController.text) {
                          return "Password don't match";
                        }
                        return null;
                      },
                      icon: Icon(Icons.vpn_key),
                      hintText: "Confirm Password",
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Allow add parking'),
                        Checkbox(
                            value: chechController,
                            activeColor: Colors.grey,
                            onChanged: (bool value) {
                              setState(() {
                                chechController = value;
                              });
                            }),
                      ],
                    ),
                    SizedBox(height: 25),
                    CustomElevatedButton(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 26),
                      ),
                      onPressed: () {
                        service.signUp(
                            emailEditingController.text,
                            passwordEditingController.text,
                            _formKey,
                            postDetailsToFirestore());
                      },
                      color: Colors.blue,
                      borderRadius: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User user = _auth.currentUser;

    UserModel userModel = UserModel();

    userModel.email = emailEditingController.text;
    userModel.uid = user.uid;
    userModel.firstName = firstNameEditingController.text;
    userModel.secondName = secondNameEditingController.text;
    userModel.isClient = chechController;

    await firebaseFirestore
        .collection("user")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false);
  }
}
