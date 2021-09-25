import 'package:flutter/material.dart';
import 'package:flutter_parking_app/services/firebase_service.dart';
import 'package:flutter_parking_app/shared/custom_eleveted_button.dart';
import 'package:flutter_parking_app/shared/custom_text_form_filed.dart';
import 'package:flutter_parking_app/ui/registracion/registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  final service = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                        height: 200,
                        child: Image.asset(
                          "assets/images/logo.png",
                          fit: BoxFit.contain,
                        )),
                    SizedBox(height: 45),
                    CustomTextFormField(
                      autofocus: false,
                      textEditingController: emailController,
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
                    SizedBox(height: 25),
                    CustomTextFormField(
                      autofocus: false,
                      textEditingController: passwordController,
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
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                    ),
                    SizedBox(height: 35),
                    CustomElevatedButton(
                      child: Text(
                        'SignIn',
                        style: TextStyle(fontSize: 26),
                      ),
                      onPressed: () {
                        service.signIn(
                          emailController.text,
                          passwordController.text,
                          context,
                          _formKey,
                        );
                      },
                      color: Colors.blue,
                      borderRadius: 20,
                    ),
                    SizedBox(height: 15),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Don't have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegistrationScreen()));
                            },
                            child: Text(
                              "SignUp",
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          )
                        ])
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
