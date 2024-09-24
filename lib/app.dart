import 'package:flutter/material.dart';
import 'package:rastrobus/pages/Home_page.dart';
import 'package:rastrobus/pages/Linhas_page.dart';
import 'package:rastrobus/pages/Rota_page.dart';
import 'package:rastrobus/pages/rotaprevistas_page.dart';

class Aplicacao extends StatelessWidget {
  const Aplicacao({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "RastroBus",
      debugShowCheckedModeBanner: false,
      initialRoute: "/homepage",
      routes: {
        "/linhapage": (_) => const LinhasPage(),
        "/homepage": (_) => const HomePage(),
        "/rotapage": (_) => const RotaPage(),
        "/rotasprevistas": (_) => const RotasPrevistasPage(),
      },
    );
  }
}
