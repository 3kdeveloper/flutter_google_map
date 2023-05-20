import 'package:flutter/material.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapPolylineNewTest extends StatefulWidget {
  const GoogleMapPolylineNewTest({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GoogleMapPolylineNewTestState createState() =>
      _GoogleMapPolylineNewTestState();
}

class _GoogleMapPolylineNewTestState extends State<GoogleMapPolylineNewTest> {
  int _polylineCount = 1;
  final Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};

  final GoogleMapPolyline _googleMapPolyline =
      GoogleMapPolyline(apiKey: "AIzaSyBQRKX7Lsoa28KmagQ28S8OaXlNd9BxxAk");

  //Polyline patterns
  List<List<PatternItem>> patterns = <List<PatternItem>>[
    <PatternItem>[], //line
    <PatternItem>[PatternItem.dash(30.0), PatternItem.gap(20.0)], //dash
    <PatternItem>[PatternItem.dot, PatternItem.gap(10.0)], //dot
    <PatternItem>[
      //dash-dot
      PatternItem.dash(30.0),
      PatternItem.gap(20.0),
      PatternItem.dot,
      PatternItem.gap(20.0)
    ],
  ];

  final LatLng _mapInitLocation = const LatLng(40.683337, -73.940432);

  final LatLng _originLocation = const LatLng(40.677939, -73.941755);
  final LatLng _destinationLocation = const LatLng(40.698432, -73.924038);

  bool _loading = false;

  _onMapCreated(GoogleMapController controller) {
    setState(() {});
  }

  //Get polyline with Location (latitude and longitude)
  _getPolylinesWithLocation() async {
    _setLoadingMenu(true);
    List<LatLng>? coordinates =
        await _googleMapPolyline.getCoordinatesWithLocation(
            origin: _originLocation,
            destination: _destinationLocation,
            mode: RouteMode.driving);

    setState(() {
      _polylines.clear();
    });
    _addPolyline(coordinates);
    _setLoadingMenu(false);
  }

  //Get polyline with Address
  _getPolylinesWithAddress() async {
    _setLoadingMenu(true);
    List<LatLng>? coordinates =
        await _googleMapPolyline.getPolylineCoordinatesWithAddress(
            origin: '55 Kingston Ave, Brooklyn, NY 11213, USA',
            destination: '8007 Cypress Ave, Glendale, NY 11385, USA',
            mode: RouteMode.driving);

    setState(() {
      _polylines.clear();
    });
    _addPolyline(coordinates);
    _setLoadingMenu(false);
  }

  _addPolyline(List<LatLng>? coordinates) {
    PolylineId id = PolylineId("poly$_polylineCount");
    Polyline polyline = Polyline(
        polylineId: id,
        patterns: patterns[0],
        color: Colors.blueAccent,
        points: coordinates!,
        width: 10,
        onTap: () {});

    setState(() {
      _polylines[id] = polyline;
      _polylineCount++;
    });
  }

  _setLoadingMenu(bool status) {
    setState(() {
      _loading = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Polyline'),
      ),
      body: Container(
        child: LayoutBuilder(
          builder: (context, cont) {
            return Column(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 175,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    polylines: Set<Polyline>.of(_polylines.values),
                    initialCameraPosition: CameraPosition(
                      target: _mapInitLocation,
                      zoom: 15,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: _getPolylinesWithLocation,
                            child: const Text('Polylines with Location')),
                        ElevatedButton(
                            onPressed: _getPolylinesWithAddress,
                            child: const Text('Polylines with Address'))
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _loading
          ? Container(
              color: Colors.black.withOpacity(0.75),
              child: const Center(
                child: Text(
                  'Loading...',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            )
          : Container(),
    );
  }
}
