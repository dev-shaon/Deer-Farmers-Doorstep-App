import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:size_matter_swt/constants/location_category.dart';
import 'package:size_matter_swt/features/home/model/farms_model.dart';
import 'package:size_matter_swt/features/home/model/ranche_model.dart';
import 'package:size_matter_swt/features/event_list/model/events_model.dart';
import 'package:size_matter_swt/features/home/presentation/widgets/home_controller.dart';
import 'package:size_matter_swt/helpers/color_helper.dart';
import 'package:size_matter_swt/helpers/helpers_method.dart';

class MapMarkerManager {
  final LocationCategory category;
  final Function(
    LatLng destination, {
    required String name,
    required String address,
    required String type,
    required String ownerName,
    required String phone,
    required String itemId,
    bool? initialIsFavourite,
    bool? initialIsVisited,
  })
  showLocationDetails;

  MapMarkerManager({required this.category, required this.showLocationDetails});

  Set<Marker> buildMarkers(dynamic model) {
    if (model is FarmsModel) {
      return _buildFarmsMarkers(model.data?.farms ?? []);
    } else if (model is RancheModel) {
      return _buildRanchesMarkers(model.data?.ranches ?? []);
    } else if (model is EventsModel) {
      return _buildEventsMarkers(model.data?.events ?? []);
    }
    return {};
  }

  Set<Marker> _buildFarmsMarkers(List<Farm> farms) {
    final Set<Marker> markers = {};
    final filter = homeController.selectedPlacesFilter.value;

    final filteredFarms = farms.where((farm) {
      if (filter == 0) return farm.isVisited == true;
      if (filter == 1) return farm.isVisited != true;
      return true;
    }).toList();

    for (var farm in filteredFarms) {
      if (farm.latitude == null || farm.longitude == null) continue;
      final position = LatLng(farm.latitude!, farm.longitude!);
      final hue = colorToHue(hexToColor(farm.markerColor));
      markers.add(
        Marker(
          markerId: MarkerId('farm_${farm.id}'),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(hue),
          infoWindow: InfoWindow(title: farm.name ?? ''),
          onTap: () async {
            final address = await getAddressFromLatLng(position);
            showLocationDetails(
              position,
              name: farm.name ?? '',
              address: address,
              type: 'Farm',
              ownerName: farm.ownerName ?? '',
              phone: farm.phone?.isNotEmpty == true
                  ? farm.phone!
                  : farm.ownerPhone ?? '',
              itemId: farm.id?.toString() ?? '',
              initialIsFavourite: farm.isFavorite,
              initialIsVisited: farm.isVisited,
            );
          },
        ),
      );
    }
    return markers;
  }

  Set<Marker> _buildRanchesMarkers(List<Ranch> ranches) {
    final Set<Marker> markers = {};
    final filter = homeController.selectedPlacesFilter.value;

    final filteredRanches = ranches.where((ranch) {
      if (filter == 0) return ranch.isVisited == true;
      if (filter == 1) return ranch.isVisited != true;
      return true;
    }).toList();

    for (var ranch in filteredRanches) {
      if (ranch.latitude == null || ranch.longitude == null) continue;
      final position = LatLng(ranch.latitude!, ranch.longitude!);
      final hue = colorToHue(hexToColor(ranch.markerColor));
      markers.add(
        Marker(
          markerId: MarkerId('ranch_${ranch.id}'),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(hue),
          infoWindow: InfoWindow(title: ranch.name ?? ''),
          onTap: () async {
            final address = await getAddressFromLatLng(position);
            showLocationDetails(
              position,
              name: ranch.name ?? '',
              address: address,
              type: 'Ranch',
              ownerName: ranch.ownerName ?? '',
              phone: ranch.phone?.isNotEmpty == true
                  ? ranch.phone!
                  : ranch.ownerPhone ?? '',
              itemId: ranch.id?.toString() ?? '',
              initialIsFavourite: ranch.isFavorite,
              initialIsVisited: ranch.isVisited,
            );
          },
        ),
      );
    }
    return markers;
  }

  Set<Marker> _buildEventsMarkers(List<Event> events) {
    final Set<Marker> markers = {};
    final filter = homeController.selectedPlacesFilter.value;

    final filteredEvents = events.where((event) {
      if (filter == 0) return event.isVisited == true;
      if (filter == 1) return event.isVisited != true;
      return true;
    }).toList();

    for (var event in filteredEvents) {
      if (event.latitude == null || event.longitude == null) continue;
      final position = LatLng(event.latitude!, event.longitude!);
      final hue = colorToHue(hexToColor(event.markerColor));
      markers.add(
        Marker(
          markerId: MarkerId('event_${event.id}'),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(hue),
          infoWindow: InfoWindow(title: event.title ?? ''),
          onTap: () async {
            final address = await getAddressFromLatLng(position);
            showLocationDetails(
              position,
              name: event.title ?? '',
              address: address,
              type: 'Event',
              ownerName: event.owner?.name ?? '',
              phone: event.phone?.isNotEmpty == true
                  ? event.phone!
                  : event.owner?.phone ?? '',
              itemId: event.id?.toString() ?? '',
              initialIsFavourite: event.isFavorite,
              initialIsVisited: event.isVisited,
            );
          },
        ),
      );
    }
    return markers;
  }
}
