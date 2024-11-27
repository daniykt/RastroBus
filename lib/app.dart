import 'package:flutter/material.dart';
import 'package:rastrobus/pages/barra_navegacao.dart';
import 'package:rastrobus/pages/detalhe_ponto.dart';
import 'package:rastrobus/pages/inicial_page.dart';
import 'package:rastrobus/pages/linhas_page.dart';
import 'package:rastrobus/pages/previssoes_page.dart';
import 'package:rastrobus/pages/rota_page.dart';
import 'package:rastrobus/pages/rotaprevistas_page.dart';
import 'package:rastrobus/pages/route_page.dart';

class Aplicacao extends StatelessWidget {
  const Aplicacao({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "RastroBus",
      debugShowCheckedModeBanner: false,
      initialRoute: "/inicio",
      routes: {
        "/inicio": (_) =>  InicioPage(),
       "/previsaopage": (_) => const PrevissoesPage(),
        "/linhapage": (_) => const LinhasPage(),
        "/BarraNavegacao": (_) => const BarraNavegacao(),
        "/rotapage": (_) => const RotaPage(),
        "/rotasprevistas": (_) => const RotasPrevistasPage(),
        "/detalheponto": (_) => const DetalhePonto(),
        "/route": (_) => const RoutePage(),
      },
    );
  }
}
