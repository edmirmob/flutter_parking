import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parking_app/core/model/user_model.dart';
import 'package:flutter_parking_app/shared/custom_app_bar.dart';
import 'package:flutter_parking_app/shared/custom_eleveted_button.dart';
import 'package:flutter_parking_app/shared/custom_text_form_filed.dart';

class ProfileUserScreen extends StatefulWidget {
  const ProfileUserScreen({Key key}) : super(key: key);

  @override
  _ProfileUserScreenState createState() => _ProfileUserScreenState();
}

class _ProfileUserScreenState extends State<ProfileUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final firstNameEditingController = new TextEditingController();
  final secondNameEditingController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final userModel = ModalRoute.of(context).settings.arguments as UserModel;
    print('Ovo je test za ID: ${userModel.uid}');

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
        arrowBack: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                    label: Text(userModel.firstName),
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    autofocus: false,
                    textEditingController: secondNameEditingController,
                    keyboardType: TextInputType.name,
                    label: Text(userModel.secondName),
                    validation: (String value) {
                      if (value.isEmpty) {
                        return ("Second Name cannot be Empty");
                      }
                      return null;
                    },
                    icon: Icon(Icons.account_circle),
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    autofocus: true,
                    isEnabled: false,
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
                    hintText: userModel.email,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  CustomElevatedButton(
                    child: Text(
                      'Update user',
                      style: TextStyle(fontSize: 26),
                    ),
                    color: Colors.blue,
                    borderRadius: 20,
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('user')
                          .doc(userModel.uid)
                          .update({
                        "firstName": firstNameEditingController.text,
                        "secondName": secondNameEditingController.text,
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
