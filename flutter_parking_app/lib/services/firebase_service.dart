import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parking_app/ui/home/home_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';

class FirebaseService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  void getParking() {
    _db.collection('parking').snapshots();
  }

  void getUser() {
    _db.collection('user').snapshots();
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
        print(e);
        Fluttertoast.showToast(
          msg: '${e.message}',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
        );
      });
    }
  }

  void signUp(String email, String password, GlobalKey<FormState> _formKey,
      dynamic postDetailsToFirestore) async {
    if (_formKey.currentState.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore()})
          .catchError((e) {
        Fluttertoast.showToast(
          msg: '${e.message}',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
        );
      });
    }
  }

  void incrementReservation(
      String id, int currentSpace, int capacity, BehaviorSubject<int> number) {
    if (currentSpace <= capacity && currentSpace > 1) {
      FirebaseFirestore.instance.collection('parking').doc(id).update(
        {'availableNumOfSlots': FieldValue.increment(-1)},
      );

      number.add(number.value + 1);
    }
    return;
  }

  void decrementReservation(
      String id, int currentSpace, int capacity, BehaviorSubject<int> number) {
    if (currentSpace < capacity && currentSpace >= 0) {
      FirebaseFirestore.instance.collection('parking').doc(id).update(
        {'availableNumOfSlots': FieldValue.increment(1)},
      );
      FirebaseFirestore.instance.collection("parking").get();

      number.add(number.value - 1);
    }
    return;
  }
}
