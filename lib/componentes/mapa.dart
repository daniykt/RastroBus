import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:provider/provider.dart';
import 'package:rastrobus/vm/rotasprevistas_vm.dart';

class Mapa extends StatefulWidget {
  const Mapa({super.key});

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> with AutomaticKeepAliveClientMixin {
  late MapController controller;

  @override
  void initState() {
    super.initState();
    controller = MapController(
      initMapWithUserPosition: const UserTrackingOption(
        enableTracking: true,
        unFollowUser: false,
      ),
    );
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    super.build(context);
    final tema = Theme.of(context);

    final vm = Provider.of<RotasPrevistasVIewModel>(context);
    final points = <StaticPositionGeoPoint>[];

    // Adicionando pontos no mapa
    for (var ponto in vm.rotasprevistas) {
      points.add(
        StaticPositionGeoPoint(
          ponto.id.toString(),
          const MarkerIcon(
            icon: Icon(
              Icons.location_pin,
              color: Colors.red,
              size: 40,
            ),
          ),
          [GeoPoint(latitude: ponto.latitude, longitude: ponto.longitude)],
        ),
      );
    }

    return OSMFlutter(
      controller: controller,
      onGeoPointClicked: (point) {},
      osmOption: OSMOption(
        zoomOption: const ZoomOption(
          initZoom: 17,
          minZoomLevel: 2,
          maxZoomLevel: 19,
          stepZoom: 1.0,
        ),
        staticPoints: points,
        userLocationMarker: UserLocationMaker(
          personMarker: MarkerIcon(
            icon: Icon(
              Icons.location_pin,
              color: tema.colorScheme.primary,
              size: 32,
            ),
          ),
          directionArrowMarker: const MarkerIcon(
            icon: Icon(
              Icons.double_arrow,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
