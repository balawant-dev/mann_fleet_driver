import 'package:url_launcher/url_launcher.dart';

/// Opens Google Maps navigation to the destination.
Future<void> openMapsNavigation({
  required double destLat,
  required double destLng,
}) async {
  final navigationUri = Uri.parse(
    'https://www.google.com/maps/dir/?api=1'
    '&destination=$destLat,$destLng'
    '&travelmode=driving',
  );

  if (await canLaunchUrl(navigationUri)) {
    await launchUrl(navigationUri, mode: LaunchMode.externalApplication);
    return;
  }

  final fallbackUri = Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=$destLat,$destLng',
  );
  await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
}
