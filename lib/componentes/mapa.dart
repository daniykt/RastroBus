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

    // Obtendo o ViewModel com as rotas previstas
    final vm = Provider.of<RotasPrevistasVIewModel>(context);

    if (vm.rotasprevistas.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final tema = Theme.of(context);
    final points = <StaticPositionGeoPoint>[];  // Lista de pontos a serem exibidos no mapa

    // Adicionando os pontos de rotas ao mapa
    for (var ponto in vm.rotasprevistas) {
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

  @override
  bool get wantKeepAlive => true;  // Mantém o estado da tela (útil quando a tela é trocada)
}
