import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_widget/google_maps_widget.dart';

class GoogleMapWidgetPkgTest extends StatelessWidget {
  // can create a controller, and call methods to update source loc,
  // destination loc, interact with the google maps controller to
  // show/hide markers programmatically etc.
  final mapsWidgetController = GlobalKey<GoogleMapsWidgetState>();

  GoogleMapWidgetPkgTest({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: GoogleMapsWidget(
                apiKey: "AIzaSyBQRKX7Lsoa28KmagQ28S8OaXlNd9BxxAk",
                key: mapsWidgetController,
                sourceLatLng: LatLng(
                  40.484000837597925,
                  -3.369978368282318,
                ),
                destinationLatLng: LatLng(
                  40.48017307700204,
                  -3.3618026599287987,
                ),

                ///////////////////////////////////////////////////////
                //////////////    OPTIONAL PARAMETERS    //////////////
                ///////////////////////////////////////////////////////

                routeWidth: 2,
                sourceMarkerIconInfo: MarkerIconInfo(
                  infoWindowTitle: "This is source name",
                  onTapInfoWindow: (_) {
                    print("Tapped on source info window");
                  },
                ),

                driverMarkerIconInfo: MarkerIconInfo(
                  infoWindowTitle: "Alex",
                  onTapMarker: (currentLocation) {
                    print("Driver is currently at $currentLocation");
                  },
                  assetMarkerSize: Size.square(125),
                ),
                destinationMarkerIconInfo: MarkerIconInfo(
                  infoWindowTitle: "This is destination name",
                  onTapInfoWindow: (_) {
                    print("Tapped on destination info window");
                  },
                ),
                onPolylineUpdate: (p) {
                  print("Polyline updated: ${p.points}");
                },
                updatePolylinesOnDriverLocUpdate: true,
                // mock stream
                driverCoordinatesStream: Stream.periodic(
                  Duration(milliseconds: 500),
                  (i) => LatLng(
                    40.47747872288886 + i / 10000,
                    -3.368043154478073 - i / 10000,
                  ),
                ),
                totalTimeCallback: (time) => print(time),
                totalDistanceCallback: (distance) => print(distance),
              ),
            ),
            // demonstrates how to interact with the controller
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        mapsWidgetController.currentState!.setSourceLatLng(
                          LatLng(
                            40.484000837597925 * (Random().nextDouble()),
                            -3.369978368282318,
                          ),
                        );
                      },
                      child: Text('Update source'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final googleMapsCon = await mapsWidgetController
                            .currentState!
                            .getGoogleMapsController();
                        googleMapsCon.showMarkerInfoWindow(
                          MarkerIconInfo.sourceMarkerId,
                        );
                      },
                      child: Text('Show source info'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
