import 'package:android_metadata/android_metadata.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as loc;
import 'package:shoppingm8_fe/list/product/productCategory.dart';
import 'package:shoppingm8_fe/maps/placesException.dart';


class PlacesProvider {
  GoogleMapsPlaces _connector;

  PlacesProvider._(apiKey) {
    _connector = GoogleMapsPlaces(apiKey: apiKey);
  }

  static Future<String> _loadApiKey() async {
    Map<String, String> metadata = await AndroidMetadata.metaDataAsMap;
    return metadata["com.google.android.geo.API_KEY"];
  }

  static Future<PlacesProvider> build() async {
    return PlacesProvider._(await _loadApiKey());
  }

  Future<LatLng> getLocation() async {
    loc.Location location = new loc.Location();
    
    bool _serviceEnabled;
    loc.PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return Future.value(null);
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return Future.value(null);
      }
    }
    loc.LocationData locationData = await location.getLocation();
    return LatLng(locationData.latitude, locationData.longitude);
  }

  Future<Set<PlacesSearchResult>> _getPlacesByType(String type, LatLng location, int radius) async {
    PlacesSearchResponse response =
        await _connector.searchNearbyWithRadius(new Location(location.latitude, location.longitude), radius, type: type);
    if (!response.isOkay && response.status != "ZERO_RESULTS") {
      throw PlacesException("Could not get shops list");
    }
    
    return response.results.toSet();
  }

  Future<Set<PlacesSearchResult>> getPlacesByCategory(Set<ProductCategory> categories, location, {radius = 1000}) async {
    Set<String> types = {};
    for (ProductCategory category in categories) {
      types.addAll(ProductCategoryHepler.getGooglePlaceType(category));
    }

    if (location == null) {
      throw PlacesException("Could not get location");
    }
    
    Set<PlacesSearchResult> places = {};
    for (String type in types) {
      places.addAll(await _getPlacesByType(type, location, radius));
    }

    return places;
  }
}