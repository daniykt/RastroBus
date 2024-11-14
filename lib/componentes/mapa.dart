import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:rastrobus/entidade/ponto.dart';
import 'package:rastrobus/util/cor.dart';

class Mapa extends StatefulWidget {
  final List<Ponto> pontosFiltrados;

  const Mapa({super.key, required this.pontosFiltrados});

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> with AutomaticKeepAliveClientMixin {
  late MapController controller;

  late List<Ponto> pontosFiltrados;

  @override
  void initState() {
    super.initState();

    // Atribua diretamente os pontosFiltrados que foram passados para o widget
    pontosFiltrados = widget.pontosFiltrados;

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

    // Agora use diretamente os pontosFiltrados que já foram passados do RotaPage
    final selecionados = <Ponto>[];

    return OSMFlutter(
      controller: controller,
      onGeoPointClicked: (point) {
        final ponto = findByGeoPoint(
            pontosFiltrados, point); // Use a lista de pontosFiltrados

        if (ponto == null) {
          return;
        }

        Navigator.pushNamed(
          context,
          "/detalheponto",
          arguments: ponto.id,
        );
      },
      osmOption: OSMOption(
        zoomOption: const ZoomOption(
          initZoom: 17,
          minZoomLevel: 2,
          maxZoomLevel: 19,
          stepZoom: 1.0,
        ),
        staticPoints: pontosFiltrados
            .map((ponto) => buildMarker(
                pontosFiltrados.indexOf(ponto), pontosFiltrados, selecionados))
            .toList(),
        userLocationMarker: UserLocationMaker(
          personMarker: MarkerIcon(
            icon: Icon(
              Icons.directions_bus,
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

  StaticPositionGeoPoint buildMarker(
    int index,
    List<Ponto> pontos,
    List<Ponto> selecionados,
  ) {
    final ponto = pontos[index];

    final selected = selecionados.indexWhere((p) => p.id == ponto.id) >= 0;

    return StaticPositionGeoPoint(
      "${ponto.id}",
      MarkerIcon(
        icon: Icon(
          Icons.bus_alert,
          size: 32,
          color: selected ? Colors.cyan : HexColor.fromHex(ponto.cor),
        ),
      ),
      [
        GeoPoint(
          latitude: ponto.latitude,
          longitude: ponto.longitude,
        ),
      ],
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
  bool get wantKeepAlive => true;
}