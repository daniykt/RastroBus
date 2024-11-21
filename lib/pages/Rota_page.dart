import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rastrobus/componentes/mapa.dart';
import 'package:rastrobus/componentes/rotasprevistas_item.dart';
import 'package:rastrobus/entidade/ponto.dart';
import 'package:rastrobus/pages/previssoes_page.dart';
import 'package:rastrobus/util/addresses.dart';
import 'package:rastrobus/util/location.dart';
import 'package:rastrobus/vm/horario_vm.dart';
import 'package:rastrobus/vm/rotasprevistas_vm.dart';

class RotaPage extends StatefulWidget {
  const RotaPage({super.key});

  @override
  State<RotaPage> createState() => _RotaPageState();
}

class _RotaPageState extends State<RotaPage> {
  String _suaPosicao = "";
  final _suaPosicaoController = TextEditingController();

  List<Ponto> rotasprevistas = []; // Inicialização da lista de rotas
  List<Ponto> rotasFiltradas = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final position = await determinePosition();
      final address = await getAddressWithLatLng(position);

      setState(() {
        _suaPosicao =
            /*"(${position.latitude},${position.longitude}) - */
            "${address?.road}";

        _suaPosicaoController.text = _suaPosicao;
      });
    });

    void filtraRotas() {
      final query = _searchController.text.toLowerCase();

      setState(() {
        rotasFiltradas = rotasprevistas
            .where((rota) => rota.endereco.toLowerCase().contains(query))
            .toList();
      });
    }

    _searchController.addListener(filtraRotas);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<RotasPrevistasVIewModel>(context, listen: false);
      vm.loadPontos().then((pontos) {
        setState(() {
          rotasprevistas = pontos;
          rotasFiltradas = rotasprevistas;
        });
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
            context,
          ), // Chama o método que constrói a parte inferior
        ],
      ),
    );
  }

  // Método que constrói a parte superior da tela
Widget _buildTopSection() {
  return Container(
    color: Color(0xFF004445), // Cor sólida de fundo
    padding: const EdgeInsets.all(12.0),
    child: Column(
      children: <Widget>[
        _buildTextField(
          'Sua Posição',
          _suaPosicaoController,
          Icons.my_location, // Ícone para "Sua Posição"
        ),
        const SizedBox(height: 12),
        _buildTextField(
          'Destino Final',
          _searchController,
          Icons.location_on, // Ícone para "Destino Final"
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            backgroundColor: Colors.blue.shade600,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Mapa(
                  pontosFiltrados: rotasFiltradas,
                ),
              ),
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.search, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Buscar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Método que cria um campo de texto com rótulo e ícone
Widget _buildTextField(
    String label, TextEditingController? controller, IconData icon) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: Colors.white), // Ícone à esquerda
      filled: true,
      fillColor: Colors.white.withOpacity(0.1), // Fundo semi-transparente
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none, // Remove bordas externas
      ),
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    ),
    style: const TextStyle(color: Colors.white),
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
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: _buildElevatedButton('Azul', Colors.blue, () {}),
              ), // Chama o método que cria um botão
              const SizedBox(height: 15), // Adiciona um espaçamento
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: _buildElevatedButton('Vermelho', Colors.red, () {}),
              ), // Chama o método que cria outro botão
              const SizedBox(height: 15), // Adiciona um espaçamento
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: _buildElevatedButton('Verde', Colors.green, () {
                  Navigator.pushNamed(context,
                      "/rotasprevistas"); // Define a navegação para outra rota
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

}
