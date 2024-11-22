import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:provider/provider.dart';
import 'package:rastrobus/entidade/ponto.dart';
import 'package:rastrobus/vm/rotasprevistas_vm.dart';

class Mapa extends StatefulWidget {
  const Mapa({
    super.key,
    this.mostraApenasFiltrados = true,
  });

  final bool mostraApenasFiltrados;

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> with OSMMixinObserver {
  late MapController controller;

  List<Ponto> pontosExibicao = [];
  Map<String, List<GeoPoint>> pontosExibidosPorCor = {};

  @override
  void initState() {
    super.initState();

    controller = MapController(
      initMapWithUserPosition: const UserTrackingOption(
        enableTracking: true,
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
    pontosExibidosPorCor.forEach((cor, pontos) async {
      for (var ponto in pontos) {
        await controller.removeMarker(ponto);
      }
    });

    final vm = Provider.of<RotasPrevistasVIewModel>(context, listen: false);
    List<Ponto> pontos = widget.mostraApenasFiltrados ? vm.rotasExibicao : vm.rotasprevistas;

    Map<String, List<GeoPoint>> pontosPorCor = {};

    for (var ponto in pontos) {
      var cor = _getColorName(ponto.cor);

      pontosPorCor.putIfAbsent(cor, () => []);
      pontosPorCor[cor]!.add(
        GeoPoint(
          latitude: ponto.latitude,
          longitude: ponto.longitude,
        ),
      );
    }
    
    pontosPorCor.forEach((cor, pontos) async {
      await controller.setStaticPosition(pontos, cor);
    });

    if (mounted) {
      //força reload na tela
      setState(() {
        pontosExibidosPorCor = pontosPorCor;
        pontosExibicao = pontos;
      });
    }
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
      onGeoPointClicked: (point) {
        final ponto = findByGeoPoint(pontosExibicao, point);
        if (ponto != null) {
          Navigator.pushNamed(context, "/detalheponto", arguments: ponto.id);
        }
      },
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
        ],
        userLocationMarker: UserLocationMaker(
          personMarker: const MarkerIcon(
            icon: Icon(
              Icons.person_pin,
              color: Colors.blue,
              size: 64,
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

  Ponto? findByGeoPoint(List<Ponto> pontos, GeoPoint geoPoint) {
    return pontos
        .where((p) =>
            p.latitude == geoPoint.latitude &&
            p.longitude == geoPoint.longitude)
        .firstOrNull;
  }
  
  @override
  Future<void> mapIsReady(bool isReady) async {
    if (isReady) {
      await _updateMapWithMarkers();
    }
  }
}
