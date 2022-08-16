import 'package:ejemplo_google_maps/Providers/providers.dart';
import 'package:ejemplo_google_maps/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(AppHerbalifeProvider());
  // requestPermissionPositionGPS();
}

class AppHerbalifeProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HubicacionPermisoProvider()),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: MapaScreen(),
    );
  }
}
