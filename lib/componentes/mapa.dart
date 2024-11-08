import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:provider/provider.dart';
import 'package:rastrobus/vm/rotasprevistas_vm.dart';
import 'package:geolocator/geolocator.dart';

class Mapa extends StatefulWidget {
  const Mapa({super.key});

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> with AutomaticKeepAliveClientMixin {
  late MapController controller;
   GeoPoint? userLocation;

  @override
  void initState() {
    super.initState();
    controller = MapController(
      initMapWithUserPosition: const UserTrackingOption(
        enableTracking: true,  
        unFollowUser: false,  
      ),
    );
    _getCurrentPosition(); // Chama a função para obter a posição atual
  }

  // Função para obter a posição atual do usuário
  Future<void> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verifica se o serviço de localização está ativado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Solicita ao usuário para ativar o serviço de localização
      return Future.error('O serviço de localização está desativado.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied)
 {
        // As permissões são negadas, retorna um erro
        return Future.error('As permissões de localização foram negadas');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // As permissões são negadas permanentemente, retorna um erro
      return Future.error(
        'As permissões de localização são negadas permanentemente, não podemos solicitar permissões.',

      );
    } 

     // Função para atualizar a posição do usuário
  void updateLocation(Position position) {
    setState(() {
      userLocation = GeoPoint(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    });
  }

    // Quando as permissões são concedidas, obtém a posição atual do usuário
    Geolocator.getPositionStream().listen((Position position) {
      // Quando as permissões são concedidas, obtém a posição atual do usuário
    Geolocator.getPositionStream().listen((Position position) {
      // Atualiza a variável _userLocation com a nova posição
      updateLocation(position);
    });
  });

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // ... (código existente)

    return OSMFlutter(
      controller: controller,
      osmOption: OSMOption( 
    zoomOption: const ZoomOption(
      initZoom: 17,
      minZoomLevel: 2,
      maxZoomLevel: 19,
      stepZoom: 1.0,
    ),
      userLocationMarker: UserLocationMaker(
        personMarker: const MarkerIcon(
          icon: Icon(
            Icons.location_history,
            color: Colors.red, 
            size: 48, 
          ),
        ),
        directionArrowMarker: const MarkerIcon(
          icon: Icon(
            Icons.double_arrow,

            size: 48,
          ),
        ),
      ),
    ),
      onMapIsReady: (bool isReady) { // Callback dentro do OSMFlutter
        if (isReady) {
          controller.setZoom(stepZoom: 17.0);
        }
      },
    );
  }
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
