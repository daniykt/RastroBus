import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rastrobus/util/addresses.dart';
import 'package:rastrobus/util/location.dart';

class RotaPage extends StatefulWidget {
  const RotaPage({super.key});

  @override
  State<RotaPage> createState() => _RotaPageState();
}

class _RotaPageState extends State<RotaPage> {
  String _suaPosicao = "";
  final _suaPosicaoController = TextEditingController();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final position = await determinePosition();
      final address = await getAddressWithLatLng(position);

      setState(() {
        _suaPosicao =
            "(${position.latitude},${position.longitude}) - ${address?.road}";

        _suaPosicaoController.text = _suaPosicao;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _buildTopSection(), // Chama o método que constrói a parte superior
          _buildBottomSection(
              context), // Chama o método que constrói a parte inferior
        ],
      ),
    );
  }

  // Método que constrói a parte superior da tela
  Widget _buildTopSection() {
    return Container(
      color: const Color.fromARGB(129, 28, 199, 128),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          _buildTextField(
            'Sua Posição',
            _suaPosicaoController,
          ), // Chama o método que cria um campo de texto
          const SizedBox(height: 8), // Adiciona um espaçamento
          _buildTextField(
            'Destino Final',
            null,
          ), // Chama o método que cria outro campo de texto
          const SizedBox(height: 8), // Adiciona um espaçamento
          ElevatedButton(
            onPressed: () {}, // Define a ação do botão (vazia por enquanto)
            child: const Text('Buscar',
                style: TextStyle(
                    color: Colors.blue)), // Define o texto e estilo do botão
          ),
        ],
      ),
    );
  }

  // Método que cria um campo de texto com um rótulo
  Widget _buildTextField(String label, TextEditingController? controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(), // Define a borda do campo de texto
        labelText: label, // Define o rótulo do campo de texto
        labelStyle: const TextStyle(
          color: Colors.white,
        ), // Define a cor do rótulo
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
          ), // Define a cor da borda quando focada
        ),
      ),
    );
  }

  // Método que constrói a parte inferior da tela
  Widget _buildBottomSection(BuildContext context) {
    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'PONTO MAIS PRÓXIMO',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ), // Define o estilo do texto
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
