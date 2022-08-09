import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 80,
              color: Colors.blueAccent,
              alignment: Alignment.center,
              child: const SafeArea(
                child: Text(
                  'HOla bb',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            const Center(
              child: Text('Hello World'),
            ),
          ],
        ),
      ),
    );
  }
}
