import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rastrobus/app.dart';
import 'package:rastrobus/vm/horario_vm.dart';
import 'package:rastrobus/vm/rotasprevistas_vm.dart';

class Provedor extends StatelessWidget {
  const Provedor({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        HorarioViewModel.novo(),
        RotasPrevistasVIewModel.novo(),
      ],
      child: const Aplicacao(),
    );
  }
}
