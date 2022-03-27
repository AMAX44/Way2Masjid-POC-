// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'masjid_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Maps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Map Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  GoogleMapController? _controller;
  bool _invokedLocationService = false;
  bool _invokedLocationPermission = false;
  final markers = <MarkerId, Marker>{};
  TextEditingController searchController = TextEditingController();
  BitmapDescriptor? custom;
  List<MasjidData> listOfMasjidData = [];
  Query? _masjidQuery;
  Query? get attendanceQuery => _masjidQuery;

  var collectionReference =
      FirebaseFirestore.instance.collection('masjidLocation');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _determinePermission();
    _customMarker();
  }

  Future<void> _determinePermission() async {
    bool serviceEnabled;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        showDialogForLocationService(context);
        return;
      }
    } else {
      _askPermission();
    }
  }

  _askPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        //TODO: Need to work on openAppSettings for web currently not supported
        if (!kIsWeb) {
          showDialogForLocationPermission(context);
        }
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      showDialogForLocationPermission(context);
      return;
    }
  }

  _validateLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if ((permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always ||
            permission == LocationPermission.unableToDetermine) &&
        _controller != null) {
      Position position = await Geolocator.getCurrentPosition();

      _currentLocation = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 16,
      );

      _controller!
          .animateCamera(CameraUpdate.newCameraPosition(_currentLocation));

      _calculateDistance();
      // globalMasjidList();
      // _fetchMasjid();
    }
  }

  // _fetchMasjid() async {
  //   List<Map> masjidList = [
  //     {
  //       'name': 'F-6 Masjid Colony',
  //       'masjidLat': 19.055096789739395,
  //       'masjidLan': 72.92539797665624
  //     },
  //     {
  //       'name': 'Sunni Jama Masjid',
  //       'masjidLat': 19.05141821882685,
  //       'masjidLan': 72.92206847712556
  //     },
  //     {
  //       'name': 'Madarsa Misbahul Uloom',
  //       'masjidLat': 19.0498355953037,
  //       'masjidLan': 72.9126248998243
  //     },
  //     {
  //       'name': 'Masjid Aqsa',
  //       'masjidLat': 19.055143342773494,
  //       'masjidLan': 72.91668038752269
  //     },
  //     {
  //       'name': 'Govandi Station Masjid',
  //       'masjidLat': 19.0554560415087,
  //       'masjidLan': 72.9161622421539
  //     },
  //     {
  //       'name': 'Masjid-E-Ayesha',
  //       'masjidLat': 19.066646737453667,
  //       'masjidLan': 72.89929650265583
  //     },
  //     {
  //       'name': 'Sunni Masjid',
  //       'masjidLat': 19.065191516617386,
  //       'masjidLan': 72.89710021254561
  //     },
  //   ];

  //   final firebaseMasjidCollection = FirebaseFirestore.instance;
  //   for (var element in masjidList) {
  //     final geo = Geoflutterfire();
  //     GeoFirePoint point = geo.point(
  //         latitude: element['masjidLat'], longitude: element['masjidLan']);
  //     firebaseMasjidCollection
  //         .collection('masjidLocation')
  //         .add({'position': point.data, 'name': element['name']});
  //   }
  // }

  // Future<void> _updatedMarkers() async {
  //   QuerySnapshot? snapshot =
  //       await FirebaseFirestore.instance.collection('masjidLocation').get();

  //   List<MasjidData> masjidDataList = [];
  //   for (var i = 0; i < snapshot.docs.length; i++) {
  //     DocumentSnapshot doc = snapshot.docs[i];
  //     MasjidData data = MasjidData.fromJson(
  //       doc.data() as Map<String, dynamic>,
  //     );
  //     masjidDataList.add(data);
  //     GeoPoint geoPoint = data.position['geopoint'];
  //     _addMarker(geoPoint.latitude, geoPoint.longitude, data.name);
  //   }
  // }

  Future<void> _updateMarkers() async {
    // Read the data from the cloud Firestore Firebase
    for (var document in listOfMasjidData) {
      final GeoPoint point = document.position['geopoint'];
      _addMarker(
        point.latitude,
        point.longitude,
        document.name,
      );
    }
  }

  Future<void> _customMarker() async {
    custom = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/mosque2.png');
  }

  Future<void> _addMarker(double lat, double lng, String data) async {
    final id = MarkerId(lat.toString() + lng.toString());
    final _marker = Marker(
      markerId: id,
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: data),
      icon: custom!,
    );
    setState(() {
      markers[id] = _marker;
    });
  }

  Future<void> _calculateDistance() async {
    final geo = Geoflutterfire();

    Position position = await Geolocator.getCurrentPosition();
    GeoFirePoint point =
        geo.point(latitude: position.latitude, longitude: position.longitude);

    // var collectionReference =
    //     FirebaseFirestore.instance.collection('masjidLocation');
    double radius = 1;
    String field = 'position';

    Stream<List<DocumentSnapshot>> stream =
        geo.collection(collectionRef: collectionReference).within(
              center: point,
              radius: radius,
              field: field,
            );
    stream.listen(
      (List<DocumentSnapshot> list) {
        listOfMasjidData.clear();
        for (var i = 0; i < list.length; i++) {
          DocumentSnapshot doc = list[i];
          MasjidData data =
              MasjidData.fromJson(doc.data() as Map<String, dynamic>);

          listOfMasjidData.add(data);
        }

        _updateMarkers();
      },
    );
  }

  showDialogForLocationPermission(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Location Permission Required to Function'),
        content: const Text('Turn on Location permission'),
        actions: [
          FlatButton(
            textColor: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
              // Container();
              showDialogForLocationPermission(context);
              return;
            },
            child: const Text('Cancel'),
          ),
          FlatButton(
            textColor: Colors.black,
            onPressed: () async {
              Navigator.of(context).pop();
              _invokedLocationPermission = true;
              await Geolocator.openAppSettings();
            },
            child: const Text('Allow now'),
          )
        ],
      ),
    );
  }

  showDialogForLocationService(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Location Services'),
        content: const Text('Allow Way2Masjid to Enable Location'),
        actions: [
          FlatButton(
            textColor: Colors.black,
            onPressed: () async {
              Navigator.of(context).pop();
              _invokedLocationService = true;
              await Geolocator.openLocationSettings();
            },
            child: const Text('Go to Location Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (_invokedLocationService) {
        if (await Geolocator.isLocationServiceEnabled()) {
          _askPermission();
        }
        _invokedLocationService = false;
      } else if (_invokedLocationPermission) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          _validateLocation();
        }
        _invokedLocationPermission = false;
      }
    }
  }

  CameraPosition _currentLocation = const CameraPosition(
    target: LatLng(
      19.055096789739395,
      -122.085749655962,
    ),
    zoom: 15,
  );

  Widget _buildSearchBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 25.0,
                  spreadRadius: 2.5,
                  offset: Offset(
                    0,
                    0,
                  ),
                )
              ],
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              color: Colors.white,
            ),
            margin: const EdgeInsets.all(15.0),
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: searchController,
                    onChanged: (value) {
                      // print(value);
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search Mosques....',
                      contentPadding: const EdgeInsets.all(12),
                      suffixIcon: IconButton(
                        onPressed: () => _clearSearch(),
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 25.0,
                spreadRadius: 2.5,
                offset: Offset(
                  0,
                  0,
                ),
              )
            ],
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            color: Colors.blue,
          ),
          margin: const EdgeInsets.only(top: 15.0, right: 15),
          width: 50,
          height: 50,
          child: IconButton(
            icon: const Icon(Icons.send),
            color: Colors.white,
            onPressed: () {
              _searchMasjid();
            },
          ),
        ),
      ],
    );
  }

  void _clearSearch() {
    searchController.text = '';
    listOfMasjidData.clear();
    _calculateDistance();
  }

  Future _searchMasjid() async {
    String value = searchController.text;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('masjidLocation')
        .where(
          'searchableName',
          arrayContains: value.toLowerCase(),
        )
        .get();
    listOfMasjidData.clear();
    for (QueryDocumentSnapshot doc in snapshot.docs) {
      MasjidData data = MasjidData.fromJson(
        doc.data() as Map<String, dynamic>,
      );
      setState(() {
        listOfMasjidData.add(data);
        _updateMarkers();
      });
      // print(doc.data());
    }
  }

  Widget _buildGoogleMap(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        markers: Set<Marker>.of(markers.values),
        mapType: MapType.normal,
        initialCameraPosition: _currentLocation,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          _validateLocation();
        },
      ),
    );
  }

  Widget _buildContainer() {
    // final dbMasjid = FirebaseFirestore.instance;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: InkWell(
        //     onTap: () {},
        //     child: Container(
        //       height: 50,
        //       width: 100,
        //       decoration: BoxDecoration(
        //         color: Colors.white,
        //         borderRadius: BorderRadius.circular(10),
        //       ),
        //       child: Padding(
        //         padding: const EdgeInsets.all(2.0),
        //         child: Row(
        //           children: const [
        //             Icon(
        //               Icons.list,
        //               color: Colors.blue,
        //             ),
        //             SizedBox(
        //               width: 5,
        //             ),
        //             Text(
        //               'View List',
        //               style: TextStyle(color: Colors.blue),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            height: 120,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: listOfMasjidData.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 350,
                  width: 290,
                  child: InkWell(
                    onTap: () {
                      final GeoPoint point =
                          listOfMasjidData[index].position['geopoint'];
                      _gotoLocation(point.latitude, point.longitude);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      child: SizedBox(
                        height: 200,
                        width: 190,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  listOfMasjidData[index].image,
                                  height: 250,
                                  width: 100,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      listOfMasjidData[index].name,
                                    ),
                                    const SizedBox(height: 10),
                                    RatingBarIndicator(
                                      rating: listOfMasjidData[index].rating,
                                      itemBuilder: (context, index) =>
                                          const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5,
                                      itemSize: 20.0,
                                      direction: Axis.horizontal,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController? controller = _controller;
    controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, long),
          zoom: 20,
          tilt: 50.0,
          bearing: 45,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            _buildGoogleMap(context),
            _buildSearchBar(),
            _buildContainer(),
          ],
        ),
      ),
    );
  }
}
