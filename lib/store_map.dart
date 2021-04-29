import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// London
const LatLng INITIAL_POSITION = LatLng(51.5074, 0.1278);
const CameraPosition INITIAL_CAMERA_POSITION =
CameraPosition(target: INITIAL_POSITION, zoom: 18);
// Between 0 and 359 = colors in 360 degrees
const double HUE_COLOR = 180.0;

class HomePage extends StatefulWidget {
  final String title;

  HomePage({Key? key, required this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Stream<QuerySnapshot> _stores;
  final Completer<GoogleMapController> _mapController = Completer();

  BitmapDescriptor _markerIcon =
  BitmapDescriptor.defaultMarkerWithHue(HUE_COLOR);

  void _setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, 'images/marker.png')
        .then((value) =>
        setState(
              () {
            _markerIcon = value;
          },
        ));
  }

  void _fetchStores() {
    _stores = FirebaseFirestore.instance.collection('ice_cream_stores')
        .orderBy('name')
        .snapshots();
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      _setCustomMarkerIcon();
    }
    _fetchStores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title + _stores .length.toString()),
        ),
        body: GoogleMap(
          initialCameraPosition: INITIAL_CAMERA_POSITION,
          markers: [
            Marker(
                markerId: MarkerId('london'),
                position: INITIAL_POSITION,
                icon: _markerIcon)
          ].toSet(),
        ));
  }
}
