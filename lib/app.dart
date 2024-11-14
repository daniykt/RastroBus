import 'package:flutter/material.dart';
import 'package:rastrobus/pages/barra_nagegacao.dart';
import 'package:rastrobus/pages/detalhe_ponto.dart';
import 'package:rastrobus/pages/linhas_page.dart';
import 'package:rastrobus/pages/previssoes_page.dart';
import 'package:rastrobus/pages/rota_page.dart';
import 'package:rastrobus/pages/rotaprevistas_page.dart';

class Aplicacao extends StatelessWidget {
  const Aplicacao({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "RastroBus",
      debugShowCheckedModeBanner: false,
      initialRoute: "/BarraNavegacao",
      routes: {
       "/previsaopage": (_) => const PrevissoesPage(),
        "/linhapage": (_) => const LinhasPage(),
        "/BarraNavegacao": (_) => const BarraNagegacao(),
        "/rotapage": (_) => const RotaPage(),
        "/rotasprevistas": (_) => const RotasPrevistasPage(),
        "/detalheponto": (_) => const DetalhePonto(),
      },
    );
  }
}
