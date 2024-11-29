import 'package:geolocator/geolocator.dart';
import 'package:open_geocoder/model/geo_address.dart';
import 'package:open_geocoder/open_geocoder.dart';

Future<Address?> getAddressWithLatLng(Position position) async {
  final geoLatLang = await OpenGeocoder.getAddressWithLatLong(
    latitude: position.latitude,
    longitude: position.longitude,
  );

  if (geoLatLang != null) {
    return geoLatLang.address; // Corrigido para retornar o endereço diretamente
  }

  return null;
}