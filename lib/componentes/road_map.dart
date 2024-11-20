import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:provider/provider.dart';
import 'package:rastrobus/entidade/ponto.dart';
import 'package:rastrobus/vm/rotasprevistas_vm.dart';

class RoadMap extends StatefulWidget {
  final Ponto target;
  final GeoPoint userPoint;

  const RoadMap({
    super.key,
    required this.target,
    required this.userPoint,
  });

  @override
  State<RoadMap> createState() => _RoadMapState();
}

class _RoadMapState extends State<RoadMap> with OSMMixinObserver {
  late MapController controller;

  Map<String, List<GeoPoint>> pontosExibidosPorTag = {};

  @override
  void initState() {
    super.initState();

    controller = MapController(
      initMapWithUserPosition: const UserTrackingOption(
        enableTracking: false,
        unFollowUser: false,
      ),
    );

    controller.addObserver(this);
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  Color _getColor(String colorHex) {
    switch (colorHex.toUpperCase()) {
      case '#FF0000':
        return Colors.red;
      case '#00FF00':
        return Colors.green;
      case '#0000FF':
        return Colors.blue;
      default:
        return Colors.black;
    }
  }

  String _getColorName(String colorHex) {
    switch (colorHex.toUpperCase()) {
      case '#FF0000':
        return "vermelho";
      case '#00FF00':
        return "verde";
      case '#0000FF':
        return "azul";
      default:
        return "preto";
    }
  }

  Future<void> _updateMapWithMarkers() async {
    pontosExibidosPorTag.forEach((cor, pontos) async {
      for (var ponto in pontos) {
        await controller.removeMarker(ponto);
      }
    });

    Map<String, List<GeoPoint>> pontosPorTag = {};

    _addTargetPoint(pontosPorTag);
    _addUserPoint(pontosPorTag);

    pontosPorTag.forEach((cor, pontos) async {
      await controller.setStaticPosition(pontos, cor);
    });

    controller.drawRoad(
      widget.userPoint,
      GeoPoint(
        latitude: widget.target.latitude,
        longitude: widget.target.longitude,
      ),
      roadOption: RoadOption(
        roadColor: _getColor(widget.target.cor),
      ),
    );

    if (mounted) {
      //força reload na tela
      setState(() {
        pontosExibidosPorTag = pontosPorTag;
      });
    }
  }

  void _addUserPoint(Map<String, List<GeoPoint>> map) {
    final user = widget.userPoint;

    map.putIfAbsent("usuario", () => []);
    map["usuario"]!.add(user);
  }

  void _addTargetPoint(Map<String, List<GeoPoint>> map) {
    final ponto = widget.target;

    var cor = _getColorName(ponto.cor);

    map.putIfAbsent(cor, () => []);
    map[cor]!.add(
      GeoPoint(
        latitude: ponto.latitude,
        longitude: ponto.longitude,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OSMFlutter(
      controller: controller, // Controlador do mapa
      key: const Key("mapa"),
      mapIsLoading: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text("Aguarde enquanto carregamos o mapa..."),
          ],
        ),
      ),
      osmOption: OSMOption(
        zoomOption: const ZoomOption(
          initZoom: 17,
          minZoomLevel: 2,
          maxZoomLevel: 19,
          stepZoom: 1.0,
        ),
        staticPoints: [
          StaticPositionGeoPoint(
            "azul",
            const MarkerIcon(
              icon: Icon(
                Icons.location_pin,
                color: Colors.blue,
                size: 40,
              ),
            ),
            [],
          ),
          StaticPositionGeoPoint(
            "vermelho",
            const MarkerIcon(
              icon: Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 40,
              ),
            ),
            [],
          ),
          StaticPositionGeoPoint(
            "verde",
            const MarkerIcon(
              icon: Icon(
                Icons.location_pin,
                color: Colors.green,
                size: 40,
              ),
            ),
            [],
          ),
          StaticPositionGeoPoint(
            "usuario",
            const MarkerIcon(
              icon: Icon(
                Icons.person_pin,
                color: Colors.blue,
                size: 32,
              ),
            ),
            [],
          ),
        ],
      ),
    );
  }

  @override
  Future<void> mapIsReady(bool isReady) async {
    if (isReady) {
      await _updateMapWithMarkers();
    }
  }
}
