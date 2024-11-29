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
          "Detalhes",
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
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _body(BuildContext context, int id) {
    final vm = Provider.of<RotasPrevistasVIewModel>(context, listen: false);

    return FutureBuilder<Ponto>(
      future: vm.loadPontoById(id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _onError(context);
        }
        if (snapshot.hasData) {
          return _onSuccess(context, snapshot.data!, vm);
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
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _onSuccess(
      BuildContext context, Ponto ponto, RotasPrevistasVIewModel vm) {
    return FutureBuilder<String?>(
      future: vm.loadHorarioChegadaByPontoId(context, ponto.id),
      builder: (context, horarioSnapshot) {
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(seconds: 4),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFFFFFF),
                        Color(0xFFADF3EC),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.directions_bus,
                              color: Colors.teal.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Ponto ${ponto.numero} - Endereço e Referência",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal.shade700,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ponto.endereco,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: Colors.black87,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                _getImage(ponto),
                const SizedBox(height: 16),
                Text(
                  ponto.bairro,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.black54,
                      ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 250,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Color(
                        int.parse(ponto.cor.replaceFirst('#', ''), radix: 16) |
                            0xFF000000),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                AnimatedContainer(
                  duration: const Duration(seconds: 4),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFFFFFF),
                        Color(0xFFADF3EC),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.access_time, color: Colors.black87),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Horário de chegada",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        horarioSnapshot.data ?? "Indisponível",
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
      },
    );
  }

  Widget _getImage(Ponto ponto) => ponto.imagem == null
      ? Image.asset("lib/assets/images/sem_imagem.png")
      : ClipRRect(
          child: Image.memory(
            base64Decode(ponto.imagem!),
            fit: BoxFit.cover,
          ),
        );
}
