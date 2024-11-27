import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:rastrobus/componentes/road_map.dart';
import 'package:rastrobus/util/route_query.dart';

class RoutePage extends StatelessWidget {
  const RoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context)?.settings.arguments;

    RouteQuery? query;

    if (argument != null) {
      query = argument as RouteQuery;
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment:
              MainAxisAlignment.start, // Alinha os itens à esquerda.
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  'lib/assets/images/barra2.png', // Caminho da imagem.
                  height: 90, // Ajuste a altura da imagem.
                ),
              ),
            ),
          ],
        ),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF004445),
      ),
      body: query == null ? emptyBody(context) : body(query),
    );
  }

  Widget emptyBody(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                "Não encontramos o ponto onde deseja chegar. Volte e selecione novamente."),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context), // Voltar à tela anterior
              child: const Text("Voltar"),
            ),
          ],
        ),
      );

  Widget body(RouteQuery query) => RoadMap(
        target: query.destino,
        userPoint: GeoPoint(
            latitude: query.posicaoUsuario.latitude,
            longitude: query.posicaoUsuario.longitude),
      );
}
