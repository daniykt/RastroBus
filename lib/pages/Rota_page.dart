import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:rastrobus/entidade/ponto.dart';
import 'package:rastrobus/util/addresses.dart';
import 'package:rastrobus/util/location.dart';
import 'package:rastrobus/util/ponto_mais_proximo.dart';
import 'package:rastrobus/util/route_query.dart';
import 'package:rastrobus/vm/rotasprevistas_vm.dart';

class RotaPage extends StatefulWidget {
  const RotaPage({super.key});

  @override
  State<RotaPage> createState() => _RotaPageState();
}

class _RotaPageState extends State<RotaPage> {
  final _suaPosicaoController = TextEditingController();

  List<Ponto> rotasprevistas = []; // Inicialização da lista de rotas
  List<Ponto> rotasFiltradas = []; // Lista de rotas filtradas
  final _searchController = TextEditingController();

  late Position _userPosition;
  late Ponto _targetPosition;

  @override
  void initState() {
    super.initState();

    // Definir a posição inicial do usuário (caso esteja usando localização)
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final position = await determinePosition();
      final address = await getAddressWithLatLng(position);

      var addressText =
          address?.road ?? "Não foi possível resolver seu endereço";

      if (addressText == "null") {
        addressText = "Não foi possível resolver seu endereço";
      }

      setState(() {
        _suaPosicaoController.text = addressText;
        _userPosition = position;
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
          const SizedBox(height: 8), // Adiciona um espaçamento
          _buildAutoCompleteTextField(
            'Destino Final',
            _searchController,
          ),
          const SizedBox(height: 8), // Adiciona um espaçamento
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                "/route",
                arguments: RouteQuery(_userPosition, _targetPosition),
              );
            }, // Define a ação do botão (vazia por enquanto)
            child: const Text('Buscar',
                style: TextStyle(
                    color: Colors.blue)), // Define o texto e estilo do botão
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
                  setState(() {
                    _targetPosition = rota;
                  });

                  _searchController.text = rota.endereco;
                  FocusScope.of(context).unfocus();
                },
              );
            },
          ),
      ],
    );
  }

  // Método que cria um campo de texto com um rótulo
  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(), // Define a borda do campo de texto
        labelText: label, // Define o rótulo do campo de texto
        labelStyle:
            const TextStyle(color: Colors.white), // Define a cor do rótulo
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.blue), // Define a cor da borda quando focada
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
              _buildElevatedButton(
                'Azul',
                Colors.blue,
                () => findPontoMaisProximo(context, _userPosition, "#0000FF"),
              ), // Chama o método que cria um botão
              const SizedBox(height: 15), // Adiciona um espaçamento
              _buildElevatedButton(
                'Vermelho',
                Colors.red,
                () => findPontoMaisProximo(context, _userPosition, "#FF0000"),
              ), // Chama o método que cria outro botão
              const SizedBox(height: 15), // Adiciona um espaçamento
              _buildElevatedButton(
                'Verde',
                Colors.green,
                () => findPontoMaisProximo(context, _userPosition, "#00FF00"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método que cria um botão elevado com texto, cor e ação
  Widget _buildElevatedButton(
    String text,
    Color color,
    VoidCallback onPressed,
  ) {
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
