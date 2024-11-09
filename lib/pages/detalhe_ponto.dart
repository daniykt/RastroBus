import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rastrobus/entidade/ponto.dart';
import 'package:rastrobus/vm/rotasprevistas_vm.dart';

class DetalhePonto extends StatelessWidget {
  const DetalhePonto({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final argument = ModalRoute.of(context)?.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Previssões",
          style: textTheme.titleLarge?.copyWith(color: const Color(0xFFF0F0F0)),
        ),
        backgroundColor: const Color(0xFF004445),
      ),
      body: argument == null
          ? emptyBody(context)
          : body(context, argument as int),
    );
  }

  Widget emptyBody(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Não foi informado nenhum id de ponto"),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Voltar"),
            ),
          ],
        ),
      );

  Widget body(BuildContext context, int id) {
    final vm = Provider.of<RotasPrevistasVIewModel>(context, listen: false);

    return FutureBuilder<Ponto>(
      future: vm.loadPontoById(id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return onError(context);
        }

        if (snapshot.hasData) {
          return onSuccess(context, snapshot.data!);
        }

        return onLoading();
      },
    );
  }

  Widget onLoading() => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 12,
            ),
            Text("Aguarde enquanto carregamos dados do ponto...")
          ],
        ),
      );

  Widget onError(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
                "Não foi possível carregar as informações do ponto. Volte e tente novamente."),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Voltar"),
            ),
          ],
        ),
      );

  Widget onSuccess(BuildContext context, Ponto ponto) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          getImage(ponto),
          Text(ponto.endereco),
        ],
      ),
    );
  }

  Widget getImage(Ponto ponto) => ponto.imagem == null
      ? Image.asset("lib/assets/images/sem_imagem.png")
      : Image.memory(base64Decode(ponto.imagem!));
}
