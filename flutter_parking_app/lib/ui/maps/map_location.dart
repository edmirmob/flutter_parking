import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/model/parking_model.dart';
import '../../shared/custom_app_bar.dart';
import '../../shared/custom_eleveted_button.dart';
import '../parking/add_parking_screen.dart';

class MapLocation extends StatefulWidget {
  @override
  State<MapLocation> createState() => MapLocationState();
}

class MapLocationState extends State<MapLocation> {
  Completer<GoogleMapController> _controller = Completer();
  ParkingModel parking;
  static final CameraPosition _positionInitial = CameraPosition(
    target: LatLng(43.85565892764279, 18.390646514886697),
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
            zoomControlsEnabled: false,
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
              backgroundColor: Colors.orange[300],
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
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: CustomElevatedButton(
                      child: Text(
                        'Next step',
                        style: TextStyle(fontSize: 20),
                      ),
                      color: Color.fromRGBO(108, 99, 255, 1),
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
