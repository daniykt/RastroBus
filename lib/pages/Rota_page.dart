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
          _buildListItem(
              context), // Chama o método que constrói a parte da lista
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
            _searchController,
          ), // Chama o método que cria outro campo de texto
          const SizedBox(height: 8), // Adiciona um espaçamento
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Mapa(
                    pontosFiltrados:
                        rotasFiltradas, // Passando os pontos filtrados para a nova página
                  ),
                ),
              );
            },
            child: const Text(
              'Buscar',
              style: TextStyle(
                color: Colors.blue,
              ),
            ), // Define o texto e estilo do botão
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

  Widget _buildListItem(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final listHeight = screenSize.height * 0.25;

    final vmHorario = Provider.of<HorarioViewModel>(context);
    final horario = vmHorario.horarios;
    return Container(
      color: const Color(0xFF002124),
      child: SizedBox(
        width: double.maxFinite,
        height: listHeight,
        child: ListView.builder(
          itemCount: rotasFiltradas.length,
          itemBuilder: (context, index) {
            final rota = rotasFiltradas[index];
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => {
                _searchController.text = rota.endereco,
                FocusScope.of(context).requestFocus(FocusNode())
              },
              child: RotasprevistasItem(
                rotasprevistas: rotasFiltradas[index],
                horario: horario[index],
              ),
            );
          },
        ),
      ),
    );
  }
}
