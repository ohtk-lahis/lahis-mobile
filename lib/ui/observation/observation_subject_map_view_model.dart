import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:podd_app/locator.dart';
import 'package:podd_app/models/entities/observation_definition.dart';
import 'package:podd_app/models/entities/observation_subject.dart';
import 'package:podd_app/services/device_location_service.dart';
import 'package:podd_app/services/observation_record_service.dart';
import 'package:stacked/stacked.dart';

class ObservationSubjectMapViewModel extends BaseViewModel {
  IObservationRecordService observationService =
      locator<IObservationRecordService>();

  final _locationService = const DeviceLocationService();

  ObservationDefinition definition;
  Position? currentPosition;

  /// True while a user-initiated center-on-me request is running.
  bool locating = false;

  GoogleMapController? controller;

  final ReactiveList<ObservationSubjectRecord> _subjects =
      ReactiveList<ObservationSubjectRecord>();

  /// Default camera when the user has not shared location yet
  /// (Vientiane region — LAHIS / SEA deployments).
  static const LatLng defaultCenter = LatLng(17.9757, 102.6331);

  ObservationSubjectMapViewModel(this.definition) {
    // Do not request location on open (Google: request in context of a clear action).
    setBusy(false);
  }

  List<ObservationSubjectRecord> get subjects => _subjects;

  LatLng get cameraTarget {
    if (currentPosition != null) {
      return LatLng(currentPosition!.latitude, currentPosition!.longitude);
    }
    return defaultCenter;
  }

  fetch(double topLeftX, double topLeftY, double bottomRightX,
      double bottomRightY) async {
    _subjects.clear();
    _subjects.addAll(await observationService.fetchAllSubjectRecordsInBounded(
        definition.id, topLeftX, topLeftY, bottomRightX, bottomRightY));
    notifyListeners();
  }

  /// User tapped “Center on my location” — full aligned permission + fix flow.
  Future<void> centerOnUser(BuildContext context) async {
    if (locating) return;
    locating = true;
    notifyListeners();
    try {
      final result = await _locationService.obtainCurrentPosition(context);
      if (result.isSuccess) {
        currentPosition = result.position;
        final target =
            LatLng(currentPosition!.latitude, currentPosition!.longitude);
        await controller?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: target, zoom: 14),
          ),
        );
        notifyListeners();
      }
      // Failures: dialogs already shown by DeviceLocationService when relevant.
    } finally {
      locating = false;
      notifyListeners();
    }
  }
}
