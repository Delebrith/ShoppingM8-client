import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:shoppingm8_fe/common/roundButtonWidget.dart';
import 'dart:math' as math;

import 'package:url_launcher/url_launcher.dart';

//based on https://medium.com/flutter-community/add-a-custom-info-window-to-your-google-map-pins-in-flutter-2e96fdca211a
class PlaceInfoContentWidget extends StatelessWidget {
  final PlacesSearchResult placesSearchResult;

  const PlaceInfoContentWidget({Key key, this.placesSearchResult})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return placesSearchResult != null
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 65,
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: placesSearchResult.icon != null
                          ? NetworkImage(placesSearchResult.icon)
                          : null
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            placesSearchResult.name,
                            style: TextStyle(color: Colors.blueGrey, fontSize: 16),
                          ),
                          Text(
                            placesSearchResult.vicinity ?? "",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Transform.rotate(
                        angle: math.pi / 2,
                        child: RoundButtonWidget(
                          color: Colors.blue,
                          icon: Icons.navigation,
                          radius: 28,
                          margin: 0,
                          onPressed: () => _navigateViaGoogleMapsApp(placesSearchResult),
                        ),
                    )
                  )
                ]
            ),
          )
        : Padding(
            padding: EdgeInsets.all(20),
            child: Text("No information"),
          );
  }

  _navigateViaGoogleMapsApp(PlacesSearchResult placesSearchResult) async {
    var mapsUrl = "google.navigation:q=${placesSearchResult.geometry.location.lat},${placesSearchResult.geometry.location.lng}&mode=w";
    if (await canLaunch(mapsUrl)) {
      await launch(mapsUrl);
    } else {
      Fluttertoast.showToast(msg: "Could not lauch Google Maps application", backgroundColor: Colors.deepOrangeAccent);
    }
  }
}
