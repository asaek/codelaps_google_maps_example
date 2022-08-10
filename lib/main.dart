import 'package:ejemplo_google_maps/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  // requestPermissionPositionGPS();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: MapaScreen(),
    );
  }
}

getLocationPermission() async {
  Location location = Location();
  try {
    location.requestPermission(); //to lunch location permission popup
  } on PlatformException catch (e) {
    if (e.code == 'PERMISSION_DENIED') {
      print('Permission denied');
    }
  }
}

Future<void> requestPermissionPositionGPS() async {
  await Permission.location.request();
}
