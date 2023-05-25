import '../../constants/export.dart';

part 'update_live_location_event.dart';
part 'update_live_location_state.dart';

class UpdateLiveLocationBloc
    extends Bloc<UpdateLiveLocationEvent, UpdateLiveLocationState> {
  UpdateLiveLocationBloc() : super(UpdateLiveLocationState()) {
    on<OnGetLiveLocation>((event, emit) {
      startListeningForLocationChanges();
    });
  }

  final _locationController = StreamController<Location>();
  Stream<Location> get locationStream => _locationController.stream;

  Future<void> startListeningForLocationChanges() async {
    LocationPermission permission;
    await Geolocator.isLocationServiceEnabled().then((serviceEnabled) async {
      if (serviceEnabled == true) {
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

        Geolocator.getPositionStream().listen((Position position) {
          Location location = Location(
            latitude: position.latitude,
            longitude: position.longitude,
            timestamp: DateTime.now(),
          );

          // Emit the updated location through the stream
          _locationController.add(location);
        });
      } else {
        print('Please enable location service');
      }
    });
  }
}
