import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_parking_app/core/model/parking_model.dart';
import 'package:flutter_parking_app/shared/custom_app_bar.dart';
import 'package:flutter_parking_app/shared/custom_eleveted_button.dart';
import 'package:flutter_parking_app/ui/parking/add_parking_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapLocation extends StatefulWidget {
  @override
  State<MapLocation> createState() => MapLocationState();
}

class MapLocationState extends State<MapLocation> {
  Completer<GoogleMapController> _controller = Completer();
  ParkingModel parking;
  static final CameraPosition _positionInitial = CameraPosition(
    target: LatLng(43.86708145744051, 18.394925231684855),
    zoom: 14.4746,
  );
  MapType type;
  Set<Marker> markers;

  @override
  void initState() {
    type = MapType.hybrid;
    markers = Set.from([]);
    super.initState();
  }

  _getLocation(lat, lang) async {
    List<Placemark> placemark = await placemarkFromCoordinates(lat, lang);
    ParkingModel parkingModel = ParkingModel(
        country: placemark[0].country,
        city: placemark[0].locality,
        street: placemark[0].street);
    parking = parkingModel;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: CustomAppBar(
        title: 'Location',
        arrowBack: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: type,
            initialCameraPosition: _positionInitial,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: markers,
            onTap: (position) {
              Marker mk1 = Marker(
                markerId: MarkerId('1'),
                position: position,
              );
              setState(() {
                _getLocation(position.latitude, position.longitude);
                markers.add(mk1);
              });
            },
          ),
          Positioned(
            right: 5,
            top: 50,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  type =
                      type == MapType.hybrid ? MapType.normal : MapType.hybrid;
                });
              },
              child: Icon(Icons.map),
            ),
          ),
          Positioned(
            bottom: 2,
            child: Container(
              color: Colors.transparent,
              height: 56,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: CustomElevatedButton(
                      child: Text(
                        'Next step',
                        style: TextStyle(fontSize: 26),
                      ),
                      color: Colors.blue,
                      borderRadius: 20,
                      onPressed: () {
                        parking != null
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddParkingScreen(),
                                  settings: RouteSettings(
                                    arguments: parking,
                                  ),
                                ),
                              )
                            : Fluttertoast.showToast(
                                msg: "Add position on map");
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
