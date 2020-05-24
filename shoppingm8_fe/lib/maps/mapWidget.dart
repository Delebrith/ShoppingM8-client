import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:shoppingm8_fe/list/product/productCategory.dart';
import 'package:shoppingm8_fe/maps/placeInfoContentWidget.dart';
import 'package:shoppingm8_fe/maps/placeInfoPanelWidget.dart';
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
  PlacesSearchResult currentPlace;
  double placeInfoPosition = -100;

  _MapState({this.categories}) : super() {
    _getMarkers();
  }

  Future<void> _getMarkers() async {
    PlacesProvider provider = await PlacesProvider.build();
    try {
      LatLng _location = await provider.getLocation();
      Set<PlacesSearchResult> _places =
          await provider.getPlacesByCategory(categories, _location);
      Set<Marker> _markers = _places
          .map((r) => new Marker(
              markerId: new MarkerId(r.geometry.location.toString()),
              position: new LatLng(r.geometry.location.lat, r.geometry.location.lng),
              onTap: () => _setCurrentPlace(r)))
          .toSet();

      setState(() {
        this.markers = _markers;
        this.location = _location;
      });
    } on PlacesException catch (exception) {
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
      body: this.location == null
          ? Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  CircularProgressIndicator(),
                  Text("Finding shops...")
                ]))
          : Stack(children: <Widget>[
              GoogleMap(
                initialCameraPosition:
                    new CameraPosition(target: location, zoom: 15),
                markers: markers,
                myLocationEnabled: true,
              ),
              PlaceInfoPanelWidget(
                placesSearchResult: currentPlace,
                position: placeInfoPosition,
              )
            ]
      ),
    );
  }

  void _setCurrentPlace(r) {
    if (currentPlace == r) {
      print(r);
      setState(() {
        currentPlace = null;
        placeInfoPosition = -100;
      });
    } else {
      print(r);
      setState(() {
        currentPlace = r;
        placeInfoPosition = 0;
      });
    }
  }
}
