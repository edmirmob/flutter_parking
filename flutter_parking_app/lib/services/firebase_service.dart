import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';

import '../ui/home/home_screen.dart';
import '../ui/login/login_screen.dart';

class FirebaseService {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  void getParking() {
    db.collection('parking').snapshots();
  }

  void getUser() {
    db.collection('user').snapshots();
  }

  void signIn(String email, String password, BuildContext context,
      GlobalKey<FormState> _formKey) async {
    if (_formKey.currentState.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                Fluttertoast.showToast(msg: "Login Successful"),
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                ),
              })
          .catchError((e) {
        Fluttertoast.showToast(
          msg: '${e.message}',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
        );
      });
    }
  }

  Future<void> signUp(
      String email,
      String password,
      GlobalKey<FormState> _formKey,
      String firstname,
      secondName,
      bool isClient,
      BuildContext context) async {
    // UserModel userModel = UserModel();
    if (_formKey.currentState.validate()) {
      final User currentUser = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password))
          .user;
      FirebaseFirestore.instance
          .collection("user")
          .doc(currentUser.uid)
          .set(
            {
              "uid": currentUser.uid,
              "firstName": firstname,
              "secondName": secondName,
              "email": email,
              "isClient": isClient,
            },
          )
          .then(
            (value) => Navigator.pushAndRemoveUntil(
                (context),
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false),
          )
          .catchError((e) {
            Fluttertoast.showToast(
              msg: '${e.message}',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
            );
          });
    }
  }

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  Future<void> updateUser(
      {String firstName,
      String secondName,
      String userId,
      BuildContext context}) async {
    DocumentReference documentReferencer = db.collection('user').doc(userId);

    Map<String, dynamic> data = <String, dynamic>{
      "firstName": firstName,
      "secondName": secondName,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => {
              Fluttertoast.showToast(msg: "Edit Successful"),
            })
        .catchError(
          (e) => Fluttertoast.showToast(
            msg: '${e.message}',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
          ),
        );
  }

  Future<void> addPargingSlot(
      {String parkingName,
      String companyName,
      String country,
      String city,
      String street,
      int numOfSlots,
      int availableNumOfSlots,
      String image}) async {
    DocumentReference documentReferencer = db.collection('parking').doc();

    Map<String, dynamic> data = <String, dynamic>{
      "parkingName": parkingName,
      "companyName": companyName,
      "country": country,
      "city": city,
      "street": street,
      "numOfSlots": numOfSlots,
      "availableNumOfSlots": availableNumOfSlots,
      "image": image
    };

    await documentReferencer
        .set(data)
        .whenComplete(
          () => Fluttertoast.showToast(msg: "Item add Successful"),
        )
        .catchError(
          (e) => Fluttertoast.showToast(
            msg: '${e.message}',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
          ),
        );
  }

  Stream<QuerySnapshot> readParkingItems() {
    var data = FirebaseFirestore.instance.collection('parking').snapshots();

    return data;
  }

  void incrementReservation(String id, int availableSlots, int capacity,
      BehaviorSubject<int> number) {
    if (availableSlots <= capacity && availableSlots > 0 && number.value >= 0) {
      FirebaseFirestore.instance.collection('parking').doc(id).update(
        {'availableNumOfSlots': FieldValue.increment(-1)},
      );

      number.add(number.value + 1);
    } else {
      Fluttertoast.showToast(
          msg: 'No more available slots', toastLength: Toast.LENGTH_SHORT);
    }
    return;
  }

  void decrementReservation(String id, int availableSlots, int capacity,
      BehaviorSubject<int> number) {
    if (availableSlots < capacity && availableSlots >= 0 && number.value != 0) {
      FirebaseFirestore.instance.collection('parking').doc(id).update(
        {'availableNumOfSlots': FieldValue.increment(1)},
      );
      FirebaseFirestore.instance.collection("parking").get();

      number.add(number.value - 1);
    } else {
      Fluttertoast.showToast(
        msg: 'Can\'t change reservation',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
    return;
  }
}
