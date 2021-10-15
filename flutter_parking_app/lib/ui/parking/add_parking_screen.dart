import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../common/image_widget.dart';
import '../../core/model/parking_model.dart';
import '../../services/firebase_service.dart';
import '../../shared/custom_app_bar.dart';
import '../../shared/custom_eleveted_button.dart';
import '../../shared/custom_text_form_filed.dart';
import '../home/home_screen.dart';

class AddParkingScreen extends StatefulWidget {
  const AddParkingScreen({Key key}) : super(key: key);

  @override
  _AddParkingScreenState createState() => _AddParkingScreenState();
}

class _AddParkingScreenState extends State<AddParkingScreen> {
  final _formKey = GlobalKey<FormState>();

  final companyEditingController = new TextEditingController();
  final parkingSlotEditingController = new TextEditingController();
  final countryEditingController = new TextEditingController();
  final cityEditingController = new TextEditingController();
  final streetEditingController = new TextEditingController();
  final numberParkingEditingController = new TextEditingController();
  var controller = BehaviorSubject<String>();
  ImageWidget imageWidget;

  @override
  Widget build(BuildContext context) {
    final parkModel = ModalRoute.of(context).settings.arguments as ParkingModel;
    final serviceProvider = Provider.of<FirebaseService>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        arrowBack: true,
        title: "Add parking",
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
                    ImageWidget(uploadFile),
                    SizedBox(height: 45),
                    CustomTextFormField(
                      autofocus: true,
                      textEditingController: companyEditingController,
                      validation: (value) {
                        RegExp regex = new RegExp(r'^.{3,}$');
                        if (value.isEmpty) {
                          return ("First Name cannot be Empty");
                        }
                        if (regex.hasMatch(value)) {
                          return ("Enter Valid name(Min. 3 Character)");
                        }
                        return null;
                      },
                      icon: Icon(Icons.location_city),
                      hintText: 'Name of company',
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 20),
                    CustomTextFormField(
                      autofocus: false,
                      textEditingController: parkingSlotEditingController,
                      validation: (value) {
                        RegExp regex = new RegExp(r'^.{3,}$');
                        if (value.isEmpty) {
                          return ("Name of parking slot cannot be Empty");
                        }
                        if (regex.hasMatch(value)) {
                          return ("Enter Valid name of parking slot(Min. 3 Character)");
                        }
                        return null;
                      },
                      icon: Icon(Icons.account_circle),
                      hintText: "Name of parking slot",
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 20),
                    CustomTextFormField(
                      isEnabled: false,
                      autofocus: false,
                      textEditingController: countryEditingController,
                      validation: (value) {
                        RegExp regex = new RegExp(r'^.{3,}$');
                        if (value.isEmpty) {
                          return ("Country cannot be Empty");
                        }
                        if (regex.hasMatch(value)) {
                          return ("Enter Valid Country(Min. 3 Character)");
                        }
                        return null;
                      },
                      icon: Icon(Icons.location_city),
                      hintText: parkModel.country,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 20),
                    CustomTextFormField(
                      isEnabled: false,
                      autofocus: false,
                      textEditingController: cityEditingController,
                      validation: (value) {
                        RegExp regex = new RegExp(r'^.{3,}$');
                        if (value.isEmpty) {
                          return ("City cannot be Empty");
                        }
                        if (regex.hasMatch(value)) {
                          return ("Enter Valid City(Min. 3 Character)");
                        }
                        return null;
                      },
                      icon: Icon(Icons.location_city_sharp),
                      hintText: parkModel.city,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 20),
                    CustomTextFormField(
                      isEnabled: false,
                      autofocus: false,
                      textEditingController: streetEditingController,
                      validation: (value) {
                        RegExp regex = new RegExp(r'^.{3,}$');
                        if (value.isEmpty) {
                          return ("Street cannot be Empty");
                        }
                        if (regex.hasMatch(value)) {
                          return ("Enter Valid Street(Min. 3 Character)");
                        }
                        return null;
                      },
                      icon: Icon(Icons.streetview_sharp),
                      hintText: parkModel.street,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 20),
                    CustomTextFormField(
                      autofocus: false,
                      textEditingController: numberParkingEditingController,
                      keyboardType: TextInputType.number,
                      validation: (value) {
                        RegExp regex = new RegExp(r'^.{3,}$');
                        if (value.isEmpty) {
                          return ("Number of Parking cannot be Empty");
                        }
                        if (regex.hasMatch(value)) {
                          return ("Enter Valid Number of Parking(Min. 3 Character)");
                        }
                        return null;
                      },
                      icon: Icon(Icons.confirmation_number_sharp),
                      hintText: "Number of Parking",
                      textInputAction: TextInputAction.done,
                    ),
                    SizedBox(height: 30),
                    StreamBuilder<Object>(
                        stream: controller.stream,
                        builder: (context, snapshot) {
                          return CustomElevatedButton(
                            child: Text(
                              'Add parking',
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              serviceProvider.addPargingSlot(
                                  parkingName:
                                      parkingSlotEditingController.text,
                                  companyName: companyEditingController.text,
                                  country: parkModel.country,
                                  city: parkModel.city,
                                  street: parkModel.street,
                                  numOfSlots: int.parse(
                                      numberParkingEditingController.text),
                                  availableNumOfSlots: int.parse(
                                      numberParkingEditingController.text),
                                  image: snapshot?.data);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            },
                            color: Color.fromRGBO(108, 99, 255, 1),
                            borderRadius: 20,
                          );
                        }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> uploadFile(File _storageImage) async {
    FirebaseStorage storage = FirebaseStorage.instance;

    Reference storageReference =
        storage.ref().child('parking/${_storageImage.path}');
    UploadTask uploadTask = storageReference.putFile(_storageImage);
    await uploadTask.then((res) {
      res.ref.getDownloadURL();
    });
    String returnURL;
    await storageReference.getDownloadURL().then((fileURL) {
      returnURL = fileURL;
      controller.add(returnURL);
    });

    return returnURL.toString();
  }
}
