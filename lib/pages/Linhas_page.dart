import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rastrobus/vm/rotasprevistas_vm.dart';

class LinhasPage extends StatefulWidget {
  const LinhasPage({super.key});

  @override
  State<LinhasPage> createState() => _LinhasPageState();
}

class _LinhasPageState extends State<LinhasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _buildBottomSection(
              context), // Chama o método que constrói a parte inferior
        ],
      ),
    );
  }

  // Método que constrói a parte inferior da tela
  Widget _buildBottomSection(BuildContext context) {
    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal:
                      MediaQuery.of(context).size.width * 0.1, // 10% da largura
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width *
                      0.1, // Ajuste proporcional
                ),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(0, 33, 36, 1),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: const FittedBox(
                  fit: BoxFit
                      .scaleDown, // Reduz o tamanho do texto se necessário
                  child: Text(
                    'LINHAS DISPONÍVEIS',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15), // Adiciona um espaçamento
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: _buildElevatedButton('Azul', Colors.blue, () {
                  selecionaRotasExibicao("#0000FF");

                  Navigator.pushNamed(context, "/rotasprevistas", arguments: {
                    'cor': '#0000FF',
                    'buscar_ponto_mais_proximo': false
                  });
                }),
              ), // Chama o método que cria um botão
              const SizedBox(height: 15), // Adiciona um espaçamento
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: _buildElevatedButton('Vermelho', Colors.red, () {
                  selecionaRotasExibicao("#FF0000");

                  Navigator.pushNamed(context, "/rotasprevistas", arguments: {
                    'cor': '#FF0000',
                    'buscar_ponto_mais_proximo': false
                  });
                }),
              ), // Chama o método que cria outro botão
              const SizedBox(height: 15), // Adiciona um espaçamento
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: _buildElevatedButton('Verde', Colors.green, () {
                  selecionaRotasExibicao("#00FF00");

                  Navigator.pushNamed(context, "/rotasprevistas", arguments: {
                    'cor': '#00FF00',
                    'buscar_ponto_mais_proximo': false
                  });
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método que cria um botão elevado com texto, cor e ação
  Widget _buildElevatedButton(
      String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color, // Define a cor de fundo do botão
        minimumSize:
            const Size(double.infinity, 80), // Define o tamanho mínimo do botão
      ),
      child: Text(text,
          style: const TextStyle(
              fontSize: 18,
              color: Colors.white)), // Define o texto e estilo do botão
    );
  }

  void selecionaRotasExibicao(String selectedColor) {
    final vm = Provider.of<RotasPrevistasVIewModel>(context, listen: false);

    switch (selectedColor) {
      case '#0000FF':
        vm.setRotasSelecionadas(vm.rotasAzuis());
        break;
      case '#00FF00':
        vm.setRotasSelecionadas(vm.rotasVerdes());
        break;
      case '#FF0000':
        vm.setRotasSelecionadas(vm.rotasVermelhas());
        break;
      default:
        vm.setRotasSelecionadas([]);
        break;
    }
  }
}
