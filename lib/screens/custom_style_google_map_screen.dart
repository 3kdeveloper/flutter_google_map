import 'package:flutter/services.dart';
import 'package:flutter_google_map/constants/export.dart';

class CustomStyleGoogleMapScreen extends StatefulWidget {
  const CustomStyleGoogleMapScreen({super.key});

  @override
  State<CustomStyleGoogleMapScreen> createState() =>
      _CustomStyleGoogleMapScreenState();
}

class _CustomStyleGoogleMapScreenState
    extends State<CustomStyleGoogleMapScreen> {
  String mapTheme = '';
  late final Completer<GoogleMapController> _controller;
  static const CameraPosition _kTokyo = CameraPosition(
    target: LatLng(35.6762, 139.6503),
    zoom: 16,
  );
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  List<Marker> markers = [];
  List<Marker> allMarkers = const [
    Marker(
      markerId: MarkerId('1'),
      position: LatLng(35.6762, 139.6503),
      infoWindow: InfoWindow(title: 'Tokyo'),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = Completer();
    getGoogleMapTheme(file: 'silver');
    markers.addAll(allMarkers);
    addCustomMarkerIcon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _kTokyo,
          onMapCreated: (controller) {
            controller.setMapStyle(mapTheme);
            _controller.complete(controller);
          },
          markers: Set.of(markers),
        ),
      ),
    );
  }

  //TODO Use this method inside the relevant BLOC
  Future<void> getGoogleMapTheme({required String file}) async {
    final resourcePath = 'assets/json/google_map_theme/$file.json';
    await rootBundle.loadString(resourcePath).then((value) {
      mapTheme = value;
      // setState(() {});
    });
  }

  void addCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'assetName')
        .then((icon) {
      markerIcon = icon;
      setState(() {});
    });
  }
}
