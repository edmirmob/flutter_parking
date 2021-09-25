import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parking_app/services/firebase_service.dart';
import 'package:rxdart/rxdart.dart';

import '../../core/model/parking_model.dart';
import '../../shared/custom_app_bar.dart';

class DetailsParkingScreen extends StatefulWidget {
  const DetailsParkingScreen({Key key}) : super(key: key);

  @override
  _DetailsParkingScreenState createState() => _DetailsParkingScreenState();
}

class _DetailsParkingScreenState extends State<DetailsParkingScreen> {
  final service = FirebaseService();

  @override
  Widget build(BuildContext context) {
    final numberBehavior = BehaviorSubject<int>.seeded(0);
    final parkModel = ModalRoute.of(context).settings.arguments as ParkingModel;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Parking details",
        arrowBack: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Container(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('parking')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data == null) return CircularProgressIndicator();
                  DocumentSnapshot data = snapshot.data.docs[parkModel.index];
                  return Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8)),
                        child: Image.network(
                          data['image'],
                          fit: BoxFit.fill,
                          width: double.infinity,
                          height: 250,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        'Overview',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Icon(Icons.business),
                          SizedBox(width: 10),
                          Text(
                            'Company Name: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('${data['companyName']}'),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_city),
                          SizedBox(width: 10),
                          Text(
                            'City: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('${data['city']}'),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Icon(Icons.flag),
                          SizedBox(width: 10),
                          Text(
                            'Country: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('${data['country']}'),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Icon(Icons.home),
                          SizedBox(width: 10),
                          Text(
                            'Street: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('${data['street']}'),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Icon(Icons.directions_car),
                          SizedBox(width: 10),
                          Text(
                            'Parking space: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('${data['numOfSlots']}'),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Icon(Icons.directions_car),
                          SizedBox(width: 10),
                          Text(
                            'Available parking space: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('${data['availableNumOfSlots']}')
                        ],
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Reserve parking space: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5.0, right: 5.0),
                                  child: Icon(Icons.add),
                                ),
                                style: TextButton.styleFrom(
                                  primary: Colors.blue,
                                  onSurface: Colors.yellow,
                                  side:
                                      BorderSide(color: Colors.blue, width: 2),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))),
                                ),
                                onPressed: () {
                                  service.incrementReservation(
                                      parkModel.id.toString(),
                                      data['availableNumOfSlots'],
                                      data['numOfSlots'],
                                      numberBehavior);
                                },
                              ),
                              StreamBuilder<int>(
                                  stream: numberBehavior.stream,
                                  builder: (context, snapshot) {
                                    return Text(
                                      snapshot.data.toString(),
                                      style: TextStyle(fontSize: 18),
                                    );
                                  }),
                              TextButton(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0),
                                  child: Icon(Icons.remove),
                                ),
                                style: TextButton.styleFrom(
                                  primary: Colors.blue,
                                  onSurface: Colors.yellow,
                                  side:
                                      BorderSide(color: Colors.blue, width: 2),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))),
                                ),
                                onPressed: () {
                                  service.decrementReservation(
                                      parkModel.id.toString(),
                                      data['availableNumOfSlots'],
                                      data['numOfSlots'],
                                      numberBehavior);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
