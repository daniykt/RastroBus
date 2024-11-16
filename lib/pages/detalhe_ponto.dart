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
      BuildContext context, Ponto ponto, HorarioViewModel horarioVM) {
    final horario = horarioVM.getByPontoId(ponto.id);

    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Fundo com gradiente animado
              AnimatedContainer(
                duration: const Duration(seconds: 4),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(24),
                constraints: const BoxConstraints(
                  minWidth: double.infinity,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 255, 255, 255),
                      const Color.fromARGB(255, 173, 243, 236),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.0, 1.0],
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
                        Icon(Icons.directions_bus, color: Colors.teal.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Ponto ${ponto.id} - Rua e Referência",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on, color: Colors.black54),
                  const SizedBox(width: 8),
                  Text(
                    ponto.bairro,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.black54,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Barra de cor com suavização
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
              // Horário de chegada com gradiente animado
              AnimatedContainer(
                duration: const Duration(seconds: 4),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(16), // Padding interno
                margin: const EdgeInsets.symmetric(
                    horizontal:
                        16), // Margem nas laterais para afastar das bordas
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 255, 255, 255),
                      const Color.fromARGB(255, 173, 243, 236),
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
                    const SizedBox(height: 4),
                    Text(
                      horario?.hora_chegada ?? "Indisponível",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                    ),
                  ],
                ),
              )
            ],
          ),
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
