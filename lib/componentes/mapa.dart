import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:rastrobus/entidade/ponto.dart';

class Mapa extends StatefulWidget {
  const Mapa({super.key});

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> with AutomaticKeepAliveClientMixin {
  late MapController controller;
  
  // Exemplo de lista de pontos (você pode obter isso de uma API ou banco de dados)
  final List<Ponto> pontos = [
    Ponto(id: 1,
    numero: 101,
    cor: "#008000",
    endereco: "Avenida Baldan, próximo ao Supermercado São Judas Tadeu",
    bairro: "Centro",
    latitude: -21.605985,
    longitude: -48.366354,
    imagem: "aa"),

    Ponto(id: 2,
    numero: 102,
    cor: "#0000FF",
    endereco: "Rua Prudente de Moraes, esquina com a Rua João Pessoa",
    bairro: "Centro",
    latitude: -21.608321,
    longitude: -48.365489,
    imagem: "aa"),

    Ponto(id: 3,
    numero: 103,
    cor: "#FF0000",
    endereco: "Avenida Trolesi, próximo ao Matão Center",
    bairro: "Imperador",
    latitude: -21.606428,
    longitude: -48.36291,
    imagem: "aa"),

    Ponto( id: 4,
    numero: 104,
    cor: "#008000",
    endereco: "Rua Rui Barbosa, em frente à Praça Alfredo de Paiva Garcia",
    bairro: "Centro",
    latitude: -21.608853,
    longitude: -48.368657,
    imagem: "aa"),
    // Adicione mais pontos conforme necessário
  ];

  @override
  void initState() {
    super.initState();
    controller = MapController(
      initMapWithUserPosition: const UserTrackingOption(
        enableTracking: true,
        unFollowUser: false,
      ),
    );

    // Adicionando pontos no mapa
    Future.delayed(const Duration(seconds: 1), () {
      for (var ponto in pontos) {
        controller.addMarker(
          GeoPoint(latitude: ponto.latitude, longitude: ponto.longitude),
          markerIcon: const MarkerIcon(
            icon: Icon(
              Icons.location_on,
              color: Colors.red, // Cor dinâmica
              size: 40,
            ),
          ),
        );
      }
    });
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    super.build(context);
    final tema = Theme.of(context);

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
