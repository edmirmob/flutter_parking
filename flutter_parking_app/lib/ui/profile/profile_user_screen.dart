import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/model/user_model.dart';
import '../../services/firebase_service.dart';
import '../../shared/custom_app_bar.dart';
import '../../shared/custom_eleveted_button.dart';
import '../../shared/custom_text_form_filed.dart';
import '../home/home_screen.dart';

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
    final serviceProvider = Provider.of<FirebaseService>(context);
    firstNameEditingController.text = userModel.firstName.toString();
    secondNameEditingController.text = userModel.secondName.toString();

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
                        "assets/images/profile_det.png",
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
                    label: Text('First name'),
                    hintText: 'Edit first name',
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    autofocus: false,
                    textEditingController: secondNameEditingController,
                    keyboardType: TextInputType.name,
                    label: Text('Second name'),
                    hintText: 'Edit second name',
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
                    hintText: userModel.email ?? 'Email empty',
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  CustomElevatedButton(
                    child: Text(
                      'Update user',
                      style: TextStyle(fontSize: 20),
                    ),
                    color: Color.fromRGBO(108, 99, 255, 1),
                    borderRadius: 20,
                    onPressed: () {
                      serviceProvider.updateUser(
                          userId: userModel.uid,
                          firstName: firstNameEditingController.text.isNotEmpty
                              ? firstNameEditingController.text
                              : userModel.firstName,
                          secondName: secondNameEditingController.text.isEmpty
                              ? userModel.secondName
                              : secondNameEditingController.text);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
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
