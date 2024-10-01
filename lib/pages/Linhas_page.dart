import 'package:flutter/material.dart';

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
                padding: const EdgeInsets.only(left: 90, right: 90),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(0, 33, 36, 1), // Cor de fundo
                  borderRadius:
                      BorderRadius.circular(50.0), // Cantos arredondados
                ),
                child: const Text(
                  'LINHAS DISPONIVEIS',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white), // Define o estilo do texto
                ),
              ),
              const SizedBox(height: 15), // Adiciona um espaçamento
              _buildElevatedButton('Azul', Colors.blue,
                  () {}), // Chama o método que cria um botão
              const SizedBox(height: 15), // Adiciona um espaçamento
              _buildElevatedButton('Vermelho', Colors.red,
                  () {}), // Chama o método que cria outro botão
              const SizedBox(height: 15), // Adiciona um espaçamento
              _buildElevatedButton('Verde', Colors.green, () {
                Navigator.pushNamed(context,
                    "/rotasprevistas"); // Define a navegação para outra rota
              }),
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
}
