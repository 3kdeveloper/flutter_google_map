import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class GeoCodingTestScreen extends StatefulWidget {
  const GeoCodingTestScreen({super.key});

  @override
  State<GeoCodingTestScreen> createState() => _GeoCodingTestScreenState();
}

class _GeoCodingTestScreenState extends State<GeoCodingTestScreen> {
  String? address;
  double? lat;
  double? long;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(address ?? 'Address goes here'),
            const SizedBox(height: 20),
            Text('${lat ?? 0.0} ${long ?? 0.0}'),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  List<Location> locations =
                      await locationFromAddress("Gronausestraat 710, Enschede");
                  List<Placemark> placemarks =
                      await placemarkFromCoordinates(52.2165157, 6.9437819);
                  lat = locations.last.latitude;
                  long = locations.last.longitude;
                  address = placemarks.reversed.last.street.toString();
                  setState(() {});
                },
                child: const Text('Convert'))
          ],
        ),
      ),
    );
  }
}
