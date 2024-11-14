
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rastrobus/componentes/mapa.dart';
import 'package:rastrobus/entidade/ponto.dart';
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
  List<Ponto> rotasFiltradas = []; // Lista de rotas filtradas
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Definir a posição inicial do usuário (caso esteja usando localização)
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final position = await determinePosition();
      final address = await getAddressWithLatLng(position);

      setState(() {
        _suaPosicao = "${address?.road}";
        _suaPosicaoController.text = _suaPosicao;
      });
    });

    // Filtro das rotas conforme a digitação do usuário
    void filtraRotas() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        rotasFiltradas = rotasprevistas
            .where((rota) => rota.endereco.toLowerCase().contains(query))
            .toList();
      });
    }

    _searchController.addListener(filtraRotas);

    // Carregar rotas ao inicializar
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<RotasPrevistasVIewModel>(context, listen: false);
      vm.loadPontos().then((pontos) {
        setState(() {
          rotasprevistas = pontos;
          rotasFiltradas = rotasprevistas;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _buildTopSection(), // Parte superior com campos de texto
          _buildBottomSection(context), // Parte inferior com botões
        ],
      ),
    );
  }

  // Construção da parte superior da tela com campos de texto e botões
  Widget _buildTopSection() {
    return Container(
      color: const Color.fromARGB(129, 28, 199, 128),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          _buildTextField(
            'Sua Posição',
            _suaPosicaoController,
          ),
          const SizedBox(height: 8),
          _buildAutoCompleteTextField(
            'Destino Final',
            _searchController,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Mapa(
                    pontosFiltrados: rotasFiltradas
                  ),
                ),
              );
            },
            child: const Text(
              'Buscar',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  // Campo de texto com autocomplete para o "Destino Final"
  Widget _buildAutoCompleteTextField(
      String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          onChanged: (query) {
            setState(() {
              rotasFiltradas = rotasprevistas
                  .where((rota) =>
                      rota.endereco.toLowerCase().contains(query.toLowerCase()))
                  .toList();
            });
          },
        ),
        // Lista suspensa de sugestões com base no filtro
        if (_searchController.text.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            itemCount: rotasFiltradas.length,
            itemBuilder: (context, index) {
              final rota = rotasFiltradas[index];
              return ListTile(
                title: Text(rota.endereco),
                onTap: () {
                  _searchController.text = rota.endereco;
                  FocusScope.of(context).unfocus();
                },
              );
            },
          ),
      ],
    );
  }

  // Método para criar campos de texto genéricos
  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  // Construção da parte inferior da tela com botões
  Widget _buildBottomSection(BuildContext context) {
    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'PONTO MAIS PRÓXIMO',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              _buildElevatedButton('Azul', Colors.blue, () {}),
              const SizedBox(height: 15),
              _buildElevatedButton('Vermelho', Colors.red, () {}),
              const SizedBox(height: 15),
              _buildElevatedButton('Verde', Colors.green, () {
                Navigator.pushNamed(context, "/rotasprevistas");
              }),
            ],
          ),
        ),
      ),
    );
  }

  // Botões elevados para outras funcionalidades
  Widget _buildElevatedButton(
      String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 80),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}
