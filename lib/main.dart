import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Position? _position;
  static const platform = MethodChannel('example.com/channel');

  Future<void> _generateRandomNumber() async {
    try {
      Timer.periodic(
        const Duration(milliseconds: 500),
        (Timer t) async => await platform.invokeMethod('updateLatitudeLongitude'),
      );
    } on PlatformException {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'LOCALIZATION',
            ),
            Text(
              'Latitude: ${_position?.latitude}',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              'Longitude: ${_position?.longitude}',
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(height: 50),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: _generateRandomNumber,
                  child: const Icon(Icons.android),
                ),
                FloatingActionButton(
                  onPressed: () async {
                    await _determinePosition();
                    final LocationSettings locationSettings = LocationSettings(
                      accuracy: LocationAccuracy.high,
                      distanceFilter: 1,
                    );
                    StreamSubscription<Position> positionStream =
                        Geolocator.getPositionStream(locationSettings: locationSettings)
                            .listen((Position? position) {
                      setState(() {
                        _position = position;
                      });
                    });
                  },
                  child: const Icon(Icons.gps_fixed),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
