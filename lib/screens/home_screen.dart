import 'package:geocoding/geocoding.dart';

import '../constants/export.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Completer<GoogleMapController> _controller;
  // CalculateRouteDistance calculateRouteDistance = CalculateRouteDistance();
  String googleApiKey = 'AIzaSyBQRKX7Lsoa28KmagQ28S8OaXlNd9BxxAk';
  final Set<Polyline> polyLines = {};
  List<LatLng> polylineCoordinates = [];
  late final StreamSubscription<Position> positionStream;
  Position? position;
  String location = '';

  static const CameraPosition _kTakhtiNasrati = CameraPosition(
    target: LatLng(33.0033, 71.0825),
    zoom: 13,
  );
  List<LatLng> points = [
    const LatLng(33.0033, 71.0825),
    const LatLng(32.9881, 71.0847),
  ];

  List<Marker> markers = [];
  List<Marker> allMarkers = [
    Marker(
      markerId: const MarkerId('1'),
      position: const LatLng(33.0033, 71.0825),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      infoWindow: const InfoWindow(title: 'Takhti Nasrati'),
    ),
    Marker(
      markerId: const MarkerId('2'),
      position: const LatLng(32.9881, 71.0847),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
      infoWindow: const InfoWindow(title: 'Zarki Nasrati'),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = Completer();
    markers.addAll(allMarkers);
    _getUserCurrentLocation();
    _drawPolyline(
      source: const LatLng(33.0033, 71.0825),
      destination: const LatLng(32.9881, 71.0847),
    );
  }

  @override
  void dispose() {
    positionStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _kTakhtiNasrati,
              onMapCreated: (controller) => _controller.complete(controller),
              markers: Set.of(markers),
              polylines: polyLines,
            ),
            Container(
              height: size.height * 0.1,
              width: double.infinity,
              color: Colors.white,
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'Current Position: ${position?.latitude}, ${position?.longitude}'),
                  Text('Location: ${location}'),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          GoogleMapController controller = await _controller.future;
          controller
              .animateCamera(CameraUpdate.newCameraPosition(_kTakhtiNasrati));
          setState(() {});
        },
        child: const Icon(Icons.location_searching),
      ),
    );
  }

  Future<void> _getUserCurrentLocation() async {
    LocationPermission permission;

    await Geolocator.isLocationServiceEnabled().then((serviceEnabled) async {
      if (serviceEnabled == true) {
        permission = await Geolocator.checkPermission();
        logger.wtf(permission);
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

        /// This code is listen for live location changes
        await Geolocator.getCurrentPosition().then((value) {
          positionStream = Geolocator.getPositionStream(
                  locationSettings:
                      const LocationSettings(accuracy: LocationAccuracy.high))
              .listen((currentPosition) async {
            logger.wtf(currentPosition);

            if (currentPosition.latitude != position?.latitude &&
                currentPosition.longitude != position?.longitude) {
              position = currentPosition;
              List<Placemark> placeMarks = await placemarkFromCoordinates(
                  currentPosition.latitude, currentPosition.longitude);
              location =
                  '${placeMarks.reversed.last.locality} ${placeMarks.reversed.last.administrativeArea}';
              setState(() {});
              logger
                  .wtf('Position ${position?.latitude} ${position?.longitude}');
            } else {
              logger.e('position is not changed');
            }
          });
        });
      } else {
        logger.e('Location Service Disabled');
      }
    });
  }

  Future<void> _drawPolyline({
    required LatLng source,
    required LatLng destination,
  }) async {
    try {
      polyLines.add(Polyline(
        polylineId: const PolylineId('POLYLINE_ID'),
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        width: 6,
        points: [source, destination],
      ));
    } catch (e) {
      logger.e(e.toString());
    }
  }

  // Request location permission and listen for location updates
  // Future<void> listenForLocationChanges() async {
  //   await Geolocator.checkPermission().then((permission) {
  //     if (permission == LocationPermission.denied) {
  //       // Handle permission denied
  //     } else if (permission == LocationPermission.deniedForever) {
  //       // Handle permission permanently denied
  //     } else {
  //       // Permission granted, start listening for location updates
  //       Geolocator.getPositionStream().listen((position) {
  //         // Handle each location update received
  //         logger.w('Stream Latitude: ${position.latitude}');
  //         logger.w('Stream Longitude: ${position.longitude}');
  //       });
  //     }
  //   });
  // }
}
