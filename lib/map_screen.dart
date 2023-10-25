import 'package:flutter/material.dart';
import 'package:flutter_google_map/map_controller.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mController = Get.put(MapController());
    return Scaffold(
      body: Stack(
        children: [
          GetBuilder<MapController>(builder: (mController) {
            return GoogleMap(
              onMapCreated: (controller) {
                mController.mapController = controller;
              },
              initialCameraPosition: mController.initialPosition,
              markers: mController.markers,
              onTap: (argument) {
                mController.moveToLocationByTapping(
                    argument.latitude, argument.longitude);
                // Get.back();
              },
            );
          }),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: mController.searchController,
                        onSubmitted: (query) {
                          mController.searchAndMoveToLocation(query);
                        },
                        decoration: const InputDecoration(
                          hintText: 'Search for a location',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      mController.searchAndMoveToLocation(
                          mController.searchController.text);
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 80,
            left: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Searched Address:'),
                      Text(mController.searchAddress.value),
                      if (mController.searchLatLng != null)
                        Text(
                            'Latitude: ${mController.searchLatLng!.latitude}, Longitude: ${mController.searchLatLng!.longitude}'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Positioned(
          //   bottom: 16,
          //   right: 16,
          //   child: Column(
          //     children: [
          //       FloatingActionButton(
          //         onPressed: () {
          //           // Implement the functionality you want for this button
          //         },
          //         child: const Icon(Icons.zoom_in),
          //       ),
          //       const SizedBox(height: 16),
          //       FloatingActionButton(
          //         onPressed: () {
          //           // Implement the functionality you want for this button
          //         },
          //         child: const Icon(Icons.zoom_out),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
