import 'dart:async';
import 'dart:typed_data';

import 'package:clippy_flutter/buttcheek.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:ejemplo_google_maps/Providers/providers.dart';
import 'package:ejemplo_google_maps/screens/screens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '/models/locations.dart' as locations;
import 'dart:ui' as ui;

class MapaScreen extends StatefulWidget {
  const MapaScreen({Key? key}) : super(key: key);

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  StreamSubscription? _locationSubscription;
  late GoogleMapController mapController;
  final Location _location = Location();
  static LatLng? _posicionInicial;

  final Map<String, Marker> _markers = {};

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  // Future<Uint8List> getMarker() async {
  //   ByteData byteData = await DefaultAssetBundle.of(context)
  //       .load('assets/markerPersonalisado.png');
  //   return byteData.buffer.asUint8List();
  // }

  Future<Uint8List> getMarkerCustom() async {
    // La mejor forma para hacer el marcador
    ByteData data = await rootBundle.load('assets/markerPersonalisado.png');
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: 100);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();

    // Otra manera de treaer la imagen del marcador personalizada
    // ByteData byteData = await DefaultAssetBundle.of(context)
    //     .load('assets/markerPersonalisado.png');
    // return byteData.buffer.asUint8List();
  }

  // No tiene mucho sentido crear este metodo tal ves sea por el estado del widget googlemaps para inicializar algo
  // mas aun no se para que se hizo asi ya que se puede hacer de otras formas lo unico util es para asignar el controller
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices();
    mapController = controller;
    _customInfoWindowController.googleMapController = controller;

    Uint8List markerData = await getMarkerCustom();

    // BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
    //   const ImageConfiguration(size: Size(0.01, 0.01), devicePixelRatio: 0.1),
    //   "assets/markerPersonalisado.png",
    // );

    //aasolicita la  hubicacionn
    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          icon: BitmapDescriptor.fromBytes(markerData),
          // icon: markerbitmap,
          // infoWindow: InfoWindow(
          //   title: office.name,
          //   snippet: office.address,
          //   anchor: const Offset(0.5, 0),
          //   onTap: () {
          //     print('Tocame para que toques a kyary algun dia ');

          //     Provider.of<HubicacionPermisoProvider>(context, listen: false)
          //         .setOfficeSeleccionada = office;

          //     Navigator.push(
          //       context,
          //       CupertinoPageRoute(
          //         builder: (BuildContext context) => OfficePage(),
          //       ),
          //     );
          //   },
          // ),
          onTap: () {
            _customInfoWindowController.addInfoWindow!(
              MarcadorPersonalizado(office: office),
              LatLng(office.lat, office.lng),
            );
          },
        );
        _markers[office.name] = marker;
      }
    });
  }

  void getCameraLocation() async {
    _locationSubscription = _location.onLocationChanged.listen(
      ((changePositionEvent) {
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
      }),
    );
  }

  void _getUserLocation() async {
    final LocationData _positionUser = await _location.getLocation();
    setState(() {
      _posicionInicial =
          LatLng(_positionUser.latitude!, _positionUser.longitude!);
    });
  }

  @override
  void initState() {
    Provider.of<HubicacionPermisoProvider>(context, listen: false)
        .LocationPermisssion();
    super.initState();
  }

  @override
  void dispose() {
    mapController.dispose();
    if (_locationSubscription != null) {
      _locationSubscription?.cancel();
    }
    _customInfoWindowController.dispose();
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

    if (permiso == true) {
      if (_posicionInicial == null) {
        _getUserLocation();
      }

      // Provider.of<HubicacionPermisoProvider>(context, listen: false)
      //     .LocationPermisssion();
    } else {
      // getCameraLocation();
      // _locationSubscription!.pause();
    }

    return Scaffold(
      body: (permiso == false || _posicionInicial == null)
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
                      strokeWidth: 5,
                    ),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _posicionInicial!,
                    zoom: 18,
                  ),
                  markers: _markers.values.toSet(),
                  compassEnabled: true,
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  onTap: (position) {
                    _customInfoWindowController.hideInfoWindow!();
                  },
                  onCameraMove: (position) {
                    _customInfoWindowController.onCameraMove!();
                  },
                ),
                CustomInfoWindow(
                  controller: _customInfoWindowController,
                  height: 220,
                  width: 300,
                  offset: 40,
                ),
              ],
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 50),
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          child: const Icon(
            Icons.center_focus_strong,
            size: 33,
          ),
          onPressed: () async {
            final bool switchUbicacion =
                Provider.of<HubicacionPermisoProvider>(context, listen: false)
                    .getswitchActivacionUbicacion;

            if (switchUbicacion) {
              getCameraLocation();
              Provider.of<HubicacionPermisoProvider>(context, listen: false)
                  .setSwitchActivacionUbicacion = false;
            } else {
              // _locationSubscription?.cancel();
              _locationSubscription!.pause();
              Provider.of<HubicacionPermisoProvider>(context, listen: false)
                  .setSwitchActivacionUbicacion = true;
            }

            // LocationData localizacion = await _location.getLocation();
            // print(
            //     'Las coordenadas son ${localizacion.latitude} --- ${localizacion.longitude}');
          },
        ),
      ),
    );
  }
}

class MarcadorPersonalizado extends StatelessWidget {
  final locations.Office office;

  const MarcadorPersonalizado({
    Key? key,
    required this.office,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: ButtCheek(
        height: 40,
        child: Container(
          width: 200,
          height: 250,
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 8),
                    child: Image.network(
                      office.image,
                      width: 120,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          office.name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            office.phone,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w300),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      office.address,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w300),
                    ),
                    GestureDetector(
                      child: const Icon(
                        Icons.chevron_right,
                        size: 50,
                      ),
                      onTap: () {
                        Provider.of<HubicacionPermisoProvider>(context,
                                listen: false)
                            .setOfficeSeleccionada = office;

                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (BuildContext context) => OfficePage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
