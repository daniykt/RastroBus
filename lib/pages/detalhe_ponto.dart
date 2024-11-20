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
    // Argumento passado na navegação (id do ponto)
    final argument = ModalRoute.of(context)?.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Previsões",
          style: textTheme.titleLarge?.copyWith(color: const Color(0xFFF0F0F0)),
        ),
        backgroundColor: const Color(0xFF004445), // Cor do AppBar
      ),
      body: argument == null
          ? _emptyBody(context)
          : _body(context, argument as int),
    );
  }

  // Corpo vazio caso não haja argumento (ponto não selecionado)
  Widget _emptyBody(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Nenhum ponto de ônibus selecionado."),
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

  // Corpo principal que carrega as informações do ponto
  Widget _body(BuildContext context, int id) {
    final vm = Provider.of<RotasPrevistasVIewModel>(context, listen: false);

    return FutureBuilder<Ponto>(
      future: vm.loadPontoById(id), // Carregar o ponto pelo id
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _onError(context); // Exibe erro se houver falha
        }
        if (snapshot.hasData) {
          return _onSuccess(
              context, snapshot.data!, vm); // Exibe os dados carregados
        }
        return _onLoading(); // Exibe loading enquanto os dados são carregados
      },
    );
  }

  Widget _onLoading() => const Center(
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

  Widget _onError(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Não foi possível carregar as informações do ponto. Volte e tente novamente.",
            ),
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

  // Exibe as informações do ponto de ônibus
  Widget _onSuccess(
      BuildContext context, Ponto ponto, RotasPrevistasVIewModel vm) {
    return FutureBuilder<String?>(
      future: vm.loadHorarioChegadaByPontoId(
          ponto.id), // Carregar o horário de chegada
      builder: (context, horarioSnapshot) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Exibe a rua e bairro do ponto
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFb3cde0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Rua e Referência",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal.shade700,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ponto.endereco, // Endereço do ponto
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: const Color(0xFF333333),
                            ),
                      ),
                      Text(
                        ponto.bairro, // Bairro do ponto
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF666666),
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Exibe imagem do ponto ou uma imagem padrão
                _getImage(ponto),
                const SizedBox(height: 8),

                // Exibe nome do bairro
                Text(
                  ponto.bairro,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                ),
                const SizedBox(height: 8),

                // Exibe a cor da linha do ônibus
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

                // Exibe o horário de chegada ou "Indisponível"
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFb3cde0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Horário de chegada:",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        //TODO como o método do VM não foi implementado, aqui aparece sempre indisponivel!
                        horarioSnapshot.data ??
                            "Indisponível", // Exibe o horário
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

  // Função que retorna a imagem do ponto, ou uma imagem padrão
  Widget _getImage(Ponto ponto) => ponto.imagem == null
      ? Image.asset("lib/assets/images/sem_imagem.png") // Imagem padrão
      : ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.memory(
            base64Decode(ponto.imagem!), // Decodifica a imagem base64
            fit: BoxFit.cover,
          ),
        );
}
