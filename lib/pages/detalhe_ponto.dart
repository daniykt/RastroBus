import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rastrobus/entidade/ponto.dart';
import 'package:rastrobus/vm/rotasprevistas_vm.dart';
import 'package:rastrobus/vm/horario_vm.dart';

class DetalhePonto extends StatelessWidget {
  const DetalhePonto({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final argument = ModalRoute.of(context)?.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Previsões",
          style: textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF004445),
      ),
      body: argument == null
          ? _emptyBody(context)
          : _body(context, argument as int),
    );
  }

  Widget _emptyBody(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Nenhum ponto de ônibus selecionado."),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Voltar"),
            ),
          ],
        ),
      );

  Widget _body(BuildContext context, int id) {
    final rotasPrevistasVM =
        Provider.of<RotasPrevistasVIewModel>(context, listen: false);
    final horarioVM = Provider.of<HorarioViewModel>(context, listen: false);

    return FutureBuilder<Ponto>(
      future: rotasPrevistasVM.loadPontoById(id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _onError(context);
        }
        if (snapshot.hasData) {
          return _onSuccess(context, snapshot.data!, horarioVM);
        }
        return _onLoading();
      },
    );
  }

  Widget _onLoading() => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text("Carregando dados do ponto..."),
          ],
        ),
      );

  Widget _onError(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Erro ao carregar as informações. Tente novamente."),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Voltar"),
            ),
          ],
        ),
      );

  Widget _onSuccess(
      BuildContext context, Ponto ponto, HorarioViewModel horarioVM) {
    // Obtém o horário de chegada com base no ponto_id
    final horario = horarioVM.getByPontoId(ponto.id);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(35),
              color: const Color(0xFFb3cde0),
              constraints: const BoxConstraints(
                minWidth: double.infinity, // Preenche toda a largura da tela
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize
                    .min, // Garante que o conteúdo não ultrapasse o limite
                children: [
                  // Exibe o número do ponto e o texto "Rua e Referência"
                  Text(
                    "Ponto ${ponto.id} - Rua e Referência", // Adicionando o número do ponto
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Flexible(
                    child: Text(
                      ponto.endereco,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                      maxLines: 2, // Limita o texto a 2 linhas
                      overflow: TextOverflow
                          .ellipsis, // Reticências se o texto for longo
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _getImage(ponto),
            const SizedBox(height: 8),
            Text(
              ponto.bairro,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontStyle: FontStyle.normal,
                    color: Colors.black54,
                  ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 300,
              height: 16,
              decoration: BoxDecoration(
                color: Color(
                    int.parse(ponto.cor.replaceFirst('#', ''), radix: 16) |
                        0xFF000000),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(35),
              color: const Color(0xFFb3cde0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Horário de chegada:",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    horario?.hora_chegada ?? "Indisponível",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getImage(Ponto ponto) => ponto.imagem == null
      ? Image.asset("lib/assets/images/sem_imagem.png")
      : ClipRRect(
          child: Image.memory(
            base64Decode(ponto.imagem!),
          ),
        );
}
