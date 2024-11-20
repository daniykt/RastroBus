import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:rastrobus/entidade/ponto.dart';
import 'dart:math';

import 'package:rastrobus/util/cor.dart';

// ignore: must_be_immutable
class Mapa extends StatefulWidget {
  const Mapa({
    super.key,
    required this.rotasprevistas,
    required this.pontosFiltrados,
    required this.buscarPontoMaisProximo,
  });

  final List<Ponto> pontosFiltrados;
  final List<Ponto> rotasprevistas;
  final bool buscarPontoMaisProximo;

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

  // Função que mapeia um valor de string para uma cor no Flutter
  Color _getColorFromEnum(String enumValue) {
    switch (enumValue.toUpperCase()) {
      case '#FF0000':
        return const Color(0xFFFF0000); // Cor vermelha
      case '#00FF00':
        return const Color(0xFF00FF00); // Cor verde
      case '#0000FF':
        return const Color(0xFF0000FF); // Cor azul
      default:
        return Colors.black; // Cor padrão (preta)
    }
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    super.build(context);
    final tema = Theme.of(context);

    // Lista de pontos a serem exibidos no mapa
    final points = <StaticPositionGeoPoint>[];
    final selecionados = <Ponto>[];

    if (widget.buscarPontoMaisProximo) {
      Ponto ponto = findNearestPonto(
        -48.3688448,
        -21.6006656,
        widget.rotasprevistas,
      );
      // Pega a localização atual ao invés de uma fixa
      Color iconColor =
          _getColorFromEnum(ponto.cor); // Definindo a cor do marcador

      points.add(
        StaticPositionGeoPoint(
          ponto.id.toString(),
          MarkerIcon(
            icon: Icon(
              Icons.location_pin,
              color: iconColor,
              size: 32,
            ),
          ),
          [GeoPoint(latitude: ponto.latitude, longitude: ponto.longitude)],
        ),
      );
    } else {
      for (var ponto in widget.rotasprevistas) {
        points.add(
          buildMarker(ponto, selecionados),
        );
      }
    }

    return OSMFlutter(
      controller: controller, // Controlador do mapa
      onGeoPointClicked: (point) {
        final ponto = findByGeoPoint(widget.rotasprevistas, point);
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
        staticPoints: points, // Adiciona todos os pontos
        userLocationMarker: UserLocationMaker(
          personMarker: const MarkerIcon(
            icon: Icon(
              Icons.person_pin,
              color: Colors.blue,
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

  StaticPositionGeoPoint buildMarker(Ponto ponto, List<Ponto> selecionados) {
    final selected = selecionados.indexWhere((p) => p.id == ponto.id) >= 0;

    return StaticPositionGeoPoint(
      "${ponto.id}",
      MarkerIcon(
        icon: Icon(
          Icons.location_pin,
          size: 32,
          color: selected ? Colors.cyan : _getColorFromEnum(ponto.cor),
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

  Ponto findNearestPonto(
      double latitude, double longitude, List<Ponto> pontos) {
    Ponto? nearestPonto;
    double shortestDistance = double.infinity;

    for (Ponto ponto in pontos) {
      double distance = calculateDistance(
        latitude,
        longitude,
        ponto.latitude,
        ponto.longitude,
      );

      if (distance < shortestDistance) {
        shortestDistance = distance;
        nearestPonto = ponto;
      }
    }

    return nearestPonto!;
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // Raio da Terra em km
    double dLat = _degToRad(lat2 - lat1);
    double dLon = _degToRad(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c; // Distância em km
  }

  double _degToRad(double deg) {
    return deg * (pi / 180);
  }

  @override
  bool get wantKeepAlive => true;
}
