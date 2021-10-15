import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../../services/firebase_service.dart';
import '../../../shared/custom_eleveted_button.dart';
import '../../../shared/custom_text_form_filed.dart';
import 'sign_up_button.dart';

Widget loginForm(BuildContext context) {
  final _formKey = GlobalKey<FormState>();
  final isObscure = BehaviorSubject<bool>.seeded(true);

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final serviceProvider = Provider.of<FirebaseService>(context);

  return Form(
    key: _formKey,
    child: StreamBuilder<bool>(
        stream: isObscure.stream,
        builder: (context, isVisible) {
          if (isVisible.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
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
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 45),
              CustomTextFormField(
                autofocus: false,
                textEditingController: emailController,
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
              SizedBox(height: 25),
              CustomTextFormField(
                autofocus: false,
                textEditingController: passwordController,
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
                sufixIcon: IconButton(
                    icon: Icon(isVisible.data
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      isObscure.add(!isVisible.data);
                      
                    }),
                hintText: "Password",
                textInputAction: TextInputAction.done,
                obscureText: isVisible.data,
              ),
              SizedBox(height: 35),
              CustomElevatedButton(
                child: Text(
                  'Sign In',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  serviceProvider.signIn(
                    emailController.text,
                    passwordController.text,
                    context,
                    _formKey,
                  );
                },
                color: Color.fromRGBO(108, 99, 255, 1),
                borderRadius: 20,
              ),
              SizedBox(height: 15),
              signUpButton(context)
            ],
          );
        }),
  );
}
