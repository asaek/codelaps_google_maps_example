import 'package:ejemplo_google_maps/Providers/permiso_hubicacion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OfficePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final officeSelecionada =
        Provider.of<HubicacionPermisoProvider>(context, listen: true)
            .getOfficeSeleccionada;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            officeSelecionada.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(
            width: double.infinity,
          ),
          Image.network(
            officeSelecionada.image,
            scale: 0.5,
          ),
        ],
      ),
    );
  }
}
