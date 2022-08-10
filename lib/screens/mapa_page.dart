import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import '/models/locations.dart' as locations;

class MapaScreen extends StatefulWidget {
  const MapaScreen({Key? key}) : super(key: key);

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  // late GoogleMapController mapController;

  // final LatLng _center = const LatLng(45.521563, -122.677433);

  // void _onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  // }

  final Map<String, Marker> _markers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();

      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
            anchor: const Offset(0.5, 0),
            onTap: () => print('Tocame para que toques a kyary algun dia '),
          ),
        );
        _markers[office.name] = marker;
      }
    });
  }

  @override
  void initState() {
    // await Future.delayed(const Duration(milliseconds: 1000));

    super.initState();
    requestPermissionPositionGPS();
    // setState(() {
    //   // getLocationPermission();

    // });
  }

  @override
  void dispose() {
    // mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   getLocationPermission();
    //   // requestPermissionPositionGPS();
    // });
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: LatLng(0, 0),
          zoom: 2,
        ),
        markers: _markers.values.toSet(),
        compassEnabled: true,
        mapType: MapType.normal,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}

getLocationPermission() async {
  Location location = Location();
  try {
    location.requestPermission(); //to lunch location permission popup
  } on PlatformException catch (e) {
    if (e.code == 'PERMISSION_DENIED') {
      print('-----------------------------------------Permission denied');
    }
  }
}

Future<void> requestPermissionPositionGPS() async {
  await Permission.location.request();
}
