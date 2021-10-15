import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/firebase_service.dart';
import '../../shared/custom_eleveted_button.dart';
import '../../shared/custom_text_form_filed.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final firstNameEditingController = new TextEditingController();
  final secondNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();
  bool checkController = false;

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<FirebaseService>(context);
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
                      height: 250,
                      child: Image.asset(
                        "assets/images/city_driver.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text(
                      'Parking app',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 45),
                    CustomTextFormField(
                      autofocus: false,
                      textEditingController: firstNameEditingController,
                      keyboardType: TextInputType.name,
                      validation: (value) {
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
                      validation: (value) {
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
                      validation: (value) {
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
                      validation: (value) {
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
                      validation: (value) {
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
                            value: checkController,
                            activeColor: Color.fromRGBO(108, 99, 255, 1),
                            onChanged: (bool value) {
                              setState(() {
                                checkController = value;
                              });
                            }),
                      ],
                    ),
                    SizedBox(height: 25),
                    CustomElevatedButton(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        serviceProvider.signUp(
                          emailEditingController.text,
                          passwordEditingController.text,
                          _formKey,
                          firstNameEditingController.text,
                          secondNameEditingController.text,
                          checkController,
                          context,
                        );
                      },
                      color: Color.fromRGBO(108, 99, 255, 1),
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
}
