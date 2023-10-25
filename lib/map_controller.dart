import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends GetxController {
  GoogleMapController? mapController;
  Set<Marker> markers = <Marker>{};
  TextEditingController searchController = TextEditingController();
  final searchAddress = "".obs;
  LatLng? searchLatLng;

  CameraPosition initialPosition = const CameraPosition(
    target: LatLng(23.8041, 90.4152), // Dhaka
    zoom: 12.0,
  );

  void _updateCameraPosition(CameraPosition newPosition) {
    mapController!.animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }

  void _addMarker(LatLng latLng, String markerId) {
    final Marker marker = Marker(
      markerId: MarkerId(markerId),
      position: latLng,
      infoWindow: const InfoWindow(title: 'Searched Location'),
    );
    markers.add(marker);
  }

  Future<void> searchAndMoveToLocation(String address) async {
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      Location location = locations.first;
      searchLatLng = LatLng(location.latitude, location.longitude);

      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        searchAddress.value =
            "${placemark.country}, ${placemark.street},${placemark.locality}, ${placemark.subLocality} ";
      }

      _updateCameraPosition(CameraPosition(target: searchLatLng!, zoom: 15.0));
      _addMarker(searchLatLng!, 'searched_location');

      update();
    }
  }

  moveToLocationByTapping(double lat, double long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

    searchLatLng = LatLng(lat, long);
    _updateCameraPosition(CameraPosition(target: searchLatLng!, zoom: 15.0));
    _addMarker(searchLatLng!, 'searched_location');

    Placemark placemark = placemarks.first;
    searchAddress.value =
        "${placemark.country}, ${placemark.street},${placemark.locality}, ${placemark.subLocality} ";

    print("OnTap Address = $searchAddress");
    update();
  }
}
