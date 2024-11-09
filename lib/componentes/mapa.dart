import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:rastrobus/entidade/ponto.dart';
import 'dart:math';


// ignore: must_be_immutable
class Mapa extends StatefulWidget {
  Mapa({super.key, required this.rotasprevistas, required this.buscarPontoMaisProximo});

  List<Ponto> rotasprevistas = [];
  bool buscarPontoMaisProximo;

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

  // Função que mapeia um valor de string para uma cor no Flutter
  Color _getColorFromEnum(String enumValue) {
    switch (enumValue.toUpperCase()) {
      case '#FF0000':
        return const Color(0xFFFF0000);  // Cor vermelha
      case '#00FF00':
        return const Color(0xFF00FF00);  // Cor verde
      case '#0000FF':
        return const Color(0xFF0000FF);  // Cor azul
      default:
        return Colors.black;  // Cor padrão (preta)
    }
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    super.build(context);


    if (widget.rotasprevistas.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final tema = Theme.of(context);
    final points = <StaticPositionGeoPoint>[];  // Lista de pontos a serem exibidos no mapa

    if(widget.buscarPontoMaisProximo){
      Ponto ponto = findNearestPonto(-48.3688448,-21.6006656 , widget.rotasprevistas); //PEGAR A LOCALIZACAO ATUAL AO INVES DE UMA LOCALIZACAO FIXA
      Color iconColor = _getColorFromEnum(ponto.cor);  // Definindo a cor do marcador

      points.add(
        StaticPositionGeoPoint(
          ponto.id.toString(),
          MarkerIcon(
            icon: Icon(
              Icons.directions_bus, 
              color: iconColor, 
              size: 40,
            ),
          ),
          [GeoPoint(latitude: ponto.latitude, longitude: ponto.longitude)],  
        ),
      );
    }else{
      for (var ponto in widget.rotasprevistas) {
      Color iconColor = _getColorFromEnum(ponto.cor);  // Definindo a cor do marcador

      points.add(
        StaticPositionGeoPoint(
          ponto.id.toString(),
          MarkerIcon(
            icon: Icon(
              Icons.directions_bus, 
              color: iconColor, 
              size: 40,
            ),
          ),
          [GeoPoint(latitude: ponto.latitude, longitude: ponto.longitude)],  
        ),
      );
    }
    }

    // Adicionando os pontos de rotas ao mapa
    

    // Retorna o widget do mapa com as opções configuradas
    return OSMFlutter(
      controller: controller,  // Controlador do mapa
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

  Ponto findNearestPonto(double latitude, double longitude, List<Ponto> pontos) {
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
      cos(_degToRad(lat1)) * cos(_degToRad(lat2)) *
      sin(dLon / 2) * sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return R * c; // Distância em km
}

double _degToRad(double deg) {
  return deg * (pi / 180);
}

  @override
  bool get wantKeepAlive => true;  // Mantém o estado da tela (útil quando a tela é trocada)
}
