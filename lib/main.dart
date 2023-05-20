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
    return MaterialApp(
      title: 'Flutter Google Map',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      // home: const CustomStyleGoogleMapScreen(),
      // home: const GeoCodingTestScreen(),
      home: const HomeScreen(),
      // home: const PlacesApiScreen(),
      // home: const GoogleMapPolylineNewTest(),
      // home: GoogleMapWidgetPkgTest(),
    );
  }
}
