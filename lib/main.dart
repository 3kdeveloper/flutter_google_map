import 'package:flutter_google_map/screens/custom_info_widow_example.dart';
import 'package:flutter_google_map/screens/update_live_location_screen.dart';

import 'blocs/update_live_location/update_live_location_bloc.dart';
import 'constants/export.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UpdateLiveLocationBloc()),
      ],
      child: MaterialApp(
        title: 'Flutter Google Map',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const UpdateLiveLocationScreen(),
        // home: const CustomInfoWindowExample(),
        // home: const CustomStyleGoogleMapScreen(),
        // home: const GeoCodingTestScreen(),
        // home: const HomeScreen(),
        // home: const PlacesApiScreen(),
        // home: const GoogleMapPolylineNewTest(),
        // home: GoogleMapWidgetPkgTest(),
      ),
    );
  }
}
