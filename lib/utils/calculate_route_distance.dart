import 'dart:math' show cos, sqrt, asin;

import 'package:google_maps_flutter/google_maps_flutter.dart';

class CalculateRouteDistance {
  double _routeDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c(((lat2 - lat1) as num) * p) / 2 +
        c((lat1 as num) * p) *
            c((lat2 as num) * p) *
            (1 - c(((lon2 - lon1) as num) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  String calculateRouteDistance(List<LatLng> points, {decimals}) {
    double totalDistance = 0.0;
    double totalDistanceInMeter = 0.0;

    decimals ??= 1;

    for (int i = 0; i < points.length - 1; i++) {
      totalDistance += _routeDistance(
        points[i].latitude,
        points[i].longitude,
        points[i + 1].latitude,
        points[i + 1].longitude,
      );
    }
    totalDistanceInMeter = totalDistance * 1000;
    if (totalDistance < 1.0) {
      return '${totalDistanceInMeter.toStringAsFixed(decimals)} m';
    } else {
      return '${totalDistance.toStringAsFixed(decimals)} km';
    }
  }
}
