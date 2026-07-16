import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:podd_app/l10n/app_localizations.dart';
import 'package:podd_app/models/entities/observation_definition.dart';
import 'package:podd_app/ui/observation/subject/observation_subject_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

import 'observation_subject_map_view_model.dart';

class ObservationSubjectMapView extends StatelessWidget {
  final ObservationDefinition definition;

  const ObservationSubjectMapView({
    Key? key,
    required this.definition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => ObservationSubjectMapViewModel(definition),
      builder: (context, model, child) => _SubjectMap(),
    );
  }
}

class _SubjectMap extends StackedHookView<ObservationSubjectMapViewModel> {
  final GlobalKey _mapKey = GlobalKey();

  @override
  Widget builder(
      BuildContext context, ObservationSubjectMapViewModel viewModel) {
    final l10n = AppLocalizations.of(context)!;

    var markers = viewModel.subjects
        .where((subject) => subject.gpsLocation != null)
        .map((subject) {
      var latlng =
          subject.gpsLocation!.split(',').map((e) => double.parse(e)).toList();
      return Marker(
        markerId: MarkerId(subject.id.toString()),
        position: LatLng(latlng[1], latlng[0]),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ObservationSubjectView(
                definitionId: viewModel.definition.id.toString(),
                subjectId: subject.id,
              ),
            ),
          );
        },
      );
    });

    onCameraIdle() {
      viewModel.controller?.getVisibleRegion().then((region) {
        // latitude = y axis
        // longitude = x axis

        // convert southwest and northeast to topLeft and bottomRight boundary
        double topLeftX = region.southwest.longitude;
        double topLeftY = region.northeast.latitude;

        double bottomRightX = region.northeast.longitude;
        double bottomRightY = region.southwest.latitude;

        viewModel.fetch(topLeftX, topLeftY, bottomRightX, bottomRightY);
      });
    }

    return Container(
      color: Colors.white,
      constraints: const BoxConstraints(
        minWidth: double.infinity,
        minHeight: double.infinity,
      ),
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              key: _mapKey,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                zoom: viewModel.currentPosition != null ? 14 : 6,
                target: viewModel.cameraTarget,
              ),
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              scrollGesturesEnabled: true,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
              markers: markers.toSet(),
              onMapCreated: (GoogleMapController controller) {
                viewModel.controller = controller;
              },
              onCameraIdle: onCameraIdle,
            ),
          ),
          Positioned(
            right: 12,
            bottom: 24,
            child: FloatingActionButton.extended(
              heroTag: 'observation_center_on_me',
              onPressed: viewModel.locating
                  ? null
                  : () => viewModel.centerOnUser(context),
              icon: viewModel.locating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.my_location),
              label: Text(
                viewModel.locating
                    ? l10n.fieldGettingLocation
                    : l10n.locationCenterOnMe,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
