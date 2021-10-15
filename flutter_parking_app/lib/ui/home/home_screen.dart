import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/model/parking_model.dart';
import '../../core/model/user_model.dart';
import '../../services/firebase_service.dart';
import '../../shared/custom_app_bar.dart';
import '../details/details_parking_screen.dart';
import '../maps/map_location.dart';
import '../profile/profile_user_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  ParkingModel parking;
  FirebaseStorage storage = FirebaseStorage.instance;
  bool isAlowed = false;

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection("user")
        .doc(user.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());

      setState(() {
        isAlowed = loggedInUser.isClient;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<FirebaseService>(context);
    return Scaffold(
        appBar: CustomAppBar(
          title: "Home",
          actions: [
            IconButton(
                color: Colors.white,
                onPressed: () {
                  serviceProvider.signOut(context);
                },
                icon: Icon(Icons.logout)),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileUserScreen(),
                    settings: RouteSettings(
                      arguments: UserModel(
                        uid: user.uid,
                        firstName: loggedInUser.firstName,
                        secondName: loggedInUser.secondName,
                        email: loggedInUser.email,
                      ),
                    ),
                  ),
                );
              },
              icon: Icon(Icons.person_sharp),
              color: Colors.white,
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: serviceProvider.readParkingItems(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      if (snapshot.data == null)
                        return CircularProgressIndicator();
                      DocumentSnapshot data = snapshot.data.docs[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsParkingScreen(),
                                settings: RouteSettings(
                                  arguments: ParkingModel(
                                      id: snapshot.data.docs[index].id,
                                      index: index),
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 120,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      child: data['image'] != null
                                          ? Image.network(data['image'],
                                              fit: BoxFit.cover)
                                          : Image.asset(
                                              'assets/images/photo_pic.png',
                                              fit: BoxFit.cover),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${data['city']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '${data['street']}',
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '${data['availableNumOfSlots']} slots available',
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.orange),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: isAlowed == true
            ? FloatingActionButton(
                backgroundColor: Color.fromRGBO(108, 99, 255, 1),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MapLocation()));
                },
                child: Icon(Icons.add),
              )
            : null);
  }
}
