import 'package:flutter/material.dart';
import 'package:rastrobus/pages/rotaprevistas_page.dart';

class Aplicacao extends StatelessWidget {
  const Aplicacao({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "RastroBus",
      initialRoute: "/rotasprevistas",
      routes: {
        "/rotasprevistas": (_) => const RotasPrevistasPage(),
      },
    );
  }
}
