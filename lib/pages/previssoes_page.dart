import 'package:flutter/material.dart';
import 'package:rastrobus/componentes/mapa.dart';

class PrevissoesPage extends StatefulWidget {
  const PrevissoesPage({Key? key}) : super(key: key);

  @override
  State<PrevissoesPage> createState() => _PrevissoesPageState();
}

class _PrevissoesPageState extends State<PrevissoesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _buildTopSection(), // Parte superior com o campo de pesquisa
          Expanded(
            child: _buildMapSection(), // Mapa ocupando a parte central da tela
          ),
          _buildBottomSection(), // Parte inferior com os botões
        ],
      ),
    );
  }

  // Método que constrói a parte superior da tela
  Widget _buildTopSection() {
    return Container(
      color: Colors.lightBlueAccent,
      padding: const EdgeInsets.all(8.0),
      child: const TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Pesquise um local de embarque',
        ),
      ),
    );
  }

  // Método que constrói o mapa (aqui, você pode chamar o widget do seu mapa)
  Widget _buildMapSection() {
    return const Column(
     children: [
       Expanded(
         child: SizedBox(
           width: double.infinity,
           child: Mapa(),
         ),
       ),
     ],
    );
  }

  // Método que constrói a parte inferior da tela
  Widget _buildBottomSection() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildButton('Favoritos'),
              _buildButton('Últimos pontos utilizados'),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Nenhum ponto pesquisado.',
            style: TextStyle(color: Colors.white, height: 10),
          ),
        ],
      ),
    );
  }

  // Método que constrói um botão na parte inferior
  Widget _buildButton(String text) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
