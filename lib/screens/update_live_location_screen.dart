import 'package:flutter_google_map/blocs/update_live_location/update_live_location_bloc.dart';

import '../constants/export.dart';

class UpdateLiveLocationScreen extends StatefulWidget {
  const UpdateLiveLocationScreen({Key? key}) : super(key: key);

  @override
  State<UpdateLiveLocationScreen> createState() =>
      _UpdateLiveLocationScreenState();
}

class _UpdateLiveLocationScreenState extends State<UpdateLiveLocationScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UpdateLiveLocationBloc>().add(OnGetLiveLocation());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<Location>(
          stream: context.read<UpdateLiveLocationBloc>().locationStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Location? location = snapshot.data;

              Marker newMarker = Marker(
                markerId: const MarkerId('userMarker'),
                position: LatLng(
                    location?.latitude ?? 0.0, location?.longitude ?? 0.0),
              );
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    location?.latitude ?? 0.0,
                    location?.longitude ?? 0.0,
                  ),
                  zoom: 14,
                ),
                markers: <Marker>{newMarker},
                // other map properties
              );
            } else {
              return const Center(child: Text('Loading...'));
            }
          },
        ),
      ),
    );
  }
}
