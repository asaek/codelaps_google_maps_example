import 'dart:async';

import 'package:ejemplo_google_maps/Providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '/models/locations.dart' as locations;

class MapaScreen extends StatefulWidget {
  const MapaScreen({Key? key}) : super(key: key);

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  StreamSubscription? _locationSubscription;
  late GoogleMapController mapController;
  Location _location = Location();

  static CameraPosition initialLocation = CameraPosition(
    target: LatLng(17.966967791336323, -102.21190559219804),
    zoom: 18,
  );

  final Map<String, Marker> _markers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices();
    mapController = controller;

    //aasolicita la  hubicacionn
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

  void getCameraLocation() async {
    _locationSubscription =
        _location.onLocationChanged.listen(((changePositionEvent) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 192.8334901395799,
            tilt: 0,
            zoom: 18,
            target: LatLng(
              changePositionEvent.latitude!,
              changePositionEvent.longitude!,
            ),
          ),
        ),
      );
    }));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    mapController.dispose();
    if (_locationSubscription != null) {
      _locationSubscription?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   getLocationPermission();
    //   // requestPermissionPositionGPS();
    // });

    final permiso =
        Provider.of<HubicacionPermisoProvider>(context, listen: true)
            .getActulizarMapa;

    if (permiso == false) {
      Provider.of<HubicacionPermisoProvider>(context, listen: false)
          .LocationPermisssion();
    }

    return Scaffold(
      body: (permiso == false)
          ? SafeArea(
              child: Column(
                children: [
                  const Text(
                    'Nesecito Permisos de hubicacion para Trabajar XD',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: InkWell(
                      child: Container(
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Text(
                          'Solicitar Permisos De Hubicacion',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      onTap: () => Provider.of<HubicacionPermisoProvider>(
                              context,
                              listen: false)
                          .LocationPermisssion(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Si ya no te lanza la solicitud de permisos, por favor ve a opciones de hubicacion en tu celular y cambia a permitir',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 80),
                  const SizedBox(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 0, 0, 0),
                      strokeWidth: 5,
                    ),
                  ),
                ],
              ),
            )
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: initialLocation,
              markers: _markers.values.toSet(),
              compassEnabled: true,
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 50),
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          child: const Icon(Icons.navigation),
          onPressed: () async {
            getCameraLocation();
            // LocationData localizacion = await _location.getLocation();
            // print(
            //     'Las coordenadas son ${localizacion.latitude} --- ${localizacion.longitude}');
          },
        ),
      ),
    );
  }
}




// getLocationPermission() async {
//   Location location = Location();
//   try {
//     location.requestPermission(); //to lunch location permission popup
//   } on PlatformException catch (e) {
//     if (e.code == 'PERMISSION_DENIED') {
//       print('-----------------------------------------Permission denied');
//     }
//   }
// }

// Future<void> requestPermissionPositionGPS() async {
//   await Permission.location.request();
// }
