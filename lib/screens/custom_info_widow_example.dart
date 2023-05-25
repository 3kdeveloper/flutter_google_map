import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter_google_map/constants/export.dart';

class CustomInfoWindowExample extends StatefulWidget {
  const CustomInfoWindowExample({Key? key}) : super(key: key);

  @override
  State<CustomInfoWindowExample> createState() =>
      _CustomInfoWindowExampleState();
}

class _CustomInfoWindowExampleState extends State<CustomInfoWindowExample> {
  late final CustomInfoWindowController _customInfoWindowController;

  final LatLng _latLng = const LatLng(28.7041, 77.1025);
  final double _zoom = 15.0;

  double infoWindowHeight = 50.0;
  double infoWindowwidth = 50.0;

  @override
  void initState() {
    super.initState();
    _customInfoWindowController = CustomInfoWindowController();
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _markers.add(
      Marker(
        markerId: const MarkerId("marker_id"),
        position: _latLng,
        onTap: () {
          _customInfoWindowController.addInfoWindow!(
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text("I am here kamran khan khattak"),
            ),
            _latLng,
          );
        },
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Info Window Example'),
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onTap: (position) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            onMapCreated: (GoogleMapController controller) async {
              _customInfoWindowController.googleMapController = controller;
            },
            markers: _markers,
            initialCameraPosition: CameraPosition(
              target: _latLng,
              zoom: _zoom,
            ),
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            width: infoWindowwidth,
            height: infoWindowHeight,
          ),
        ],
      ),
    );
  }
}
