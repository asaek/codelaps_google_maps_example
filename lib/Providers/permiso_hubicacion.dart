import 'package:ejemplo_google_maps/models/locations.dart';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';

class HubicacionPermisoProvider with ChangeNotifier {
  bool _actulizarMapa = false;
  bool get getActulizarMapa => _actulizarMapa;
  void setActulizarMapa(bool value) {
    _actulizarMapa = value;
    notifyListeners();
  }

  bool _switchActivacionUbicacion = true;
  bool get getswitchActivacionUbicacion => _switchActivacionUbicacion;
  set setSwitchActivacionUbicacion(bool dato) {
    _switchActivacionUbicacion = dato;
  }

  Office? _officeSeleccionada;
  Office get getOfficeSeleccionada => _officeSeleccionada!;
  set setOfficeSeleccionada(Office dato) {
    _officeSeleccionada = dato;
    notifyListeners();
  }

  Future LocationPermisssion() async {
    Location location = Location();

    final permiso = await location.requestPermission();
    print('Texto del permiso: ${permiso.toString()}');

    if (permiso.toString() == 'PermissionStatus.granted') {
      setActulizarMapa(true);
    }
  }
}

// void getCameraLocation({required Location location}) async {
//   _locationSubscription = location.onLocationChanged.listen(
//     ((changePositionEvent) {
//       mapController.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(
//             bearing: 192.8334901395799,
//             tilt: 0,
//             zoom: 18,
//             target: LatLng(
//               changePositionEvent.latitude!,
//               changePositionEvent.longitude!,
//             ),
//           ),
//         ),
//       );
//     }),
//   );
// }
