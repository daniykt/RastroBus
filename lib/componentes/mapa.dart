import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:rastrobus/entidade/ponto.dart';
import 'package:rastrobus/util/cor.dart';

class Mapa extends StatefulWidget {
  const Mapa({
    super.key,
  });

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> with AutomaticKeepAliveClientMixin {
  late MapController controller;

  @override
  void initState() {
    super.initState();

    controller = MapController(
      //posição
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

    final pontos = <Ponto>[
      Ponto(
        id: 1,
        numero: 1,
        bairro: "Centro",
        cor: "#0000FF",
        endereco: "Rua Cesário Mota",
        latitude: -21.602840,
        longitude: -48.366340,
      ),
    ];

    final selecionados = <Ponto>[];

    return OSMFlutter(
      controller: controller,
      onGeoPointClicked: (point) {
        final ponto = findByGeoPoint(pontos, point);

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
        staticPoints: [
          buildMarker(0, pontos, selecionados),
        ],
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
