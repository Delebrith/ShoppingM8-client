import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:shoppingm8_fe/maps/placeInfoContentWidget.dart';

//based on https://medium.com/flutter-community/add-a-custom-info-window-to-your-google-map-pins-in-flutter-2e96fdca211a
class PlaceInfoPanelWidget extends StatefulWidget {
  double position;
  PlacesSearchResult placesSearchResult;

  PlaceInfoPanelWidget({this.position, this.placesSearchResult});

  @override
  State<StatefulWidget> createState() => _PlaceInfoPanelWidgetState();
}

class _PlaceInfoPanelWidgetState extends State<PlaceInfoPanelWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      bottom: widget.position,
      right: 0,
      left: 0,
      duration: Duration(milliseconds: 250),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            margin: EdgeInsets.all(30),
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(50)),
              boxShadow: <BoxShadow>[
                BoxShadow(blurRadius: 20, color: Colors.grey.withOpacity(0.5))
              ],
            ),
            child: PlaceInfoContentWidget(
              placesSearchResult: widget.placesSearchResult,
            )),
      ),
    );
  }
}
