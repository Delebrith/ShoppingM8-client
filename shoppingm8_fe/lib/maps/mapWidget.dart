import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shoppingm8_fe/list/product/productCategory.dart';
import 'package:shoppingm8_fe/maps/placesException.dart';
import 'package:shoppingm8_fe/maps/placesProvider.dart';

class MapWidget extends StatefulWidget {
  final Set<ProductCategory> categories;

  MapWidget({Key key, this.categories}) : super(key: key);

  _MapState createState() => _MapState(categories: categories);
}

class _MapState extends State<MapWidget> {
  final Set<ProductCategory> categories;
  Set<Marker> markers;
  LatLng location;


  _MapState({this.categories}) : super() {
    _getMarkers();
  }

  Future<void> _getMarkers() async {
    PlacesProvider provider = await PlacesProvider.build();
    try {
      LatLng _location = await provider.getLocation();
      Set<Marker> _markers = await provider.getPlacesByCategory(categories, _location);

      setState(() {
        this.markers = _markers;
        this.location = _location;
      });
    } on PlacesException catch(exception) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(exception.cause),
        duration: Duration(seconds: 5),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Find shops")),
      body: this.location == null ?
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Text("Finding shops...")
            ]
          )
        ) :
        GoogleMap(
          initialCameraPosition: new CameraPosition(target: location, zoom: 15),
          markers: markers,
        )
    );
  }
}