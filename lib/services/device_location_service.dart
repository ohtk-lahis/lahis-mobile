import 'dart:async';
import 'dart:io' show Platform;

import 'package:app_settings/app_settings.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:podd_app/l10n/app_localizations.dart';

/// Outcome of a one-shot foreground location request.
class DeviceLocationResult {
  final Position? position;
  final DeviceLocationFailure? failure;

  const DeviceLocationResult._({this.position, this.failure});

  factory DeviceLocationResult.success(Position position) =>
      DeviceLocationResult._(position: position);

  factory DeviceLocationResult.failed(DeviceLocationFailure failure) =>
      DeviceLocationResult._(failure: failure);

  bool get isSuccess => position != null;
}

enum DeviceLocationFailure {
  /// Device location services (GPS/network) are off.
  serviceDisabled,

  /// User declined the system permission dialog (can ask again).
  permissionDenied,

  /// User blocked permission permanently / "Don't ask again".
  permissionDeniedForever,

  /// User dismissed the in-app rationale without continuing.
  rationaleDeclined,

  /// No fix within [timeLimit].
  timeout,

  /// Unexpected platform / plugin error.
  unknown,
}

/// Google-aligned **foreground**, user-initiated location access:
///
/// 1. Ensure location services are on (else explain + open settings)
/// 2. [checkPermission]
/// 3. If denied → in-app rationale → [requestPermission]
/// 4. If deniedForever → explain + open app settings
/// 5. Then one-shot [Geolocator.getCurrentPosition] (no background)
///
/// Does **not** request `ACCESS_BACKGROUND_LOCATION` / Always.
class DeviceLocationService {
  const DeviceLocationService();

  static LocationSettings locationSettings({
    Duration timeLimit = const Duration(seconds: 8),
  }) {
    // Prefer Android LocationManager over FusedLocationProvider to avoid
    // main-thread Binder hangs seen when Fused stops NMEA updates.
    if (!kIsWeb && Platform.isAndroid) {
      return AndroidSettings(
        accuracy: LocationAccuracy.high,
        forceLocationManager: true,
        timeLimit: timeLimit,
      );
    }
    return LocationSettings(
      accuracy: LocationAccuracy.high,
      timeLimit: timeLimit,
    );
  }

  /// Full flow with dialogs. Call only after a clear user action
  /// (e.g. "Use current location").
  Future<DeviceLocationResult> obtainCurrentPosition(
    BuildContext context, {
    Duration timeLimit = const Duration(seconds: 8),
    bool allowRetryAfterSettings = true,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    // 1) Services enabled?
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!context.mounted) {
        return DeviceLocationResult.failed(DeviceLocationFailure.serviceDisabled);
      }
      await _showServiceDisabledDialog(context, l10n);
      return DeviceLocationResult.failed(DeviceLocationFailure.serviceDisabled);
    }

    // 2) Permission state
    var permission = await Geolocator.checkPermission();

    // 3) Permanently denied → settings (no system prompt will appear)
    if (permission == LocationPermission.deniedForever) {
      if (!context.mounted) {
        return DeviceLocationResult.failed(
            DeviceLocationFailure.permissionDeniedForever);
      }
      await _showOpenSettingsDialog(
        context,
        l10n,
        title: l10n.locationPermissionDeniedForeverTitle,
        body: l10n.locationPermissionDeniedForeverBody,
      );
      return DeviceLocationResult.failed(
          DeviceLocationFailure.permissionDeniedForever);
    }

    // 4) Not yet granted → rationale then system dialog
    if (permission == LocationPermission.denied) {
      if (!context.mounted) {
        return DeviceLocationResult.failed(
            DeviceLocationFailure.permissionDenied);
      }
      final proceed = await _showRationaleDialog(context, l10n);
      if (!proceed) {
        return DeviceLocationResult.failed(
            DeviceLocationFailure.rationaleDeclined);
      }
      if (!context.mounted) {
        return DeviceLocationResult.failed(
            DeviceLocationFailure.permissionDenied);
      }

      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return DeviceLocationResult.failed(
            DeviceLocationFailure.permissionDenied);
      }
      if (permission == LocationPermission.deniedForever) {
        if (context.mounted) {
          await _showOpenSettingsDialog(
            context,
            l10n,
            title: l10n.locationPermissionDeniedForeverTitle,
            body: l10n.locationPermissionDeniedForeverBody,
          );
        }
        return DeviceLocationResult.failed(
            DeviceLocationFailure.permissionDeniedForever);
      }
    }

    // 5) One-shot foreground fix
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings(timeLimit: timeLimit),
      );
      return DeviceLocationResult.success(position);
    } on TimeoutException {
      return DeviceLocationResult.failed(DeviceLocationFailure.timeout);
    } on LocationServiceDisabledException {
      if (context.mounted) {
        await _showServiceDisabledDialog(context, l10n);
      }
      return DeviceLocationResult.failed(DeviceLocationFailure.serviceDisabled);
    } on PermissionDeniedException {
      // Race: revoked between check and get
      return DeviceLocationResult.failed(
          DeviceLocationFailure.permissionDenied);
    } catch (_) {
      return DeviceLocationResult.failed(DeviceLocationFailure.unknown);
    }
  }

  String messageFor(DeviceLocationFailure failure, AppLocalizations l10n) {
    switch (failure) {
      case DeviceLocationFailure.serviceDisabled:
        return l10n.locationServiceIsDisabled;
      case DeviceLocationFailure.permissionDenied:
      case DeviceLocationFailure.rationaleDeclined:
        return l10n.locationPermissionDenied;
      case DeviceLocationFailure.permissionDeniedForever:
        return l10n.locationPermissionDeniedForeverBody;
      case DeviceLocationFailure.timeout:
        return l10n.locationTimeout;
      case DeviceLocationFailure.unknown:
        return l10n.locationCouldNotGet;
    }
  }

  Future<bool> _showRationaleDialog(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.locationRationaleTitle),
        content: Text(l10n.locationRationaleBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.locationRationaleNotNow),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.locationRationaleContinue),
          ),
        ],
      ),
    );
    return result == true;
  }

  Future<void> _showServiceDisabledDialog(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.locationServiceDisabledTitle),
        content: Text(l10n.locationServiceIsDisabled),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.locationRationaleNotNow),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              AppSettings.openAppSettings(type: AppSettingsType.location);
            },
            child: Text(l10n.locationOpenSettings),
          ),
        ],
      ),
    );
  }

  Future<void> _showOpenSettingsDialog(
    BuildContext context,
    AppLocalizations l10n, {
    required String title,
    required String body,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.locationRationaleNotNow),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // App details: user can enable Location for this app.
              AppSettings.openAppSettings();
            },
            child: Text(l10n.locationOpenSettings),
          ),
        ],
      ),
    );
  }
}
