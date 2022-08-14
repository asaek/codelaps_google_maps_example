import 'package:flutter/foundation.dart';
import 'package:location/location.dart';

class HubicacionPermisoProvider with ChangeNotifier {
  bool _actulizarMapa = false;
  bool get getActulizarMapa => _actulizarMapa;
  void setActulizarMapa(bool value) {
    _actulizarMapa = value;
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
