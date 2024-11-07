import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rastrobus/componentes/mapa.dart';
import 'package:rastrobus/componentes/rotasprevistas_item.dart';
import 'package:rastrobus/entidade/ponto.dart';
import 'package:rastrobus/vm/horario_vm.dart';
import 'package:rastrobus/vm/rotasprevistas_vm.dart';

class PrevissoesPage extends StatefulWidget {
  const PrevissoesPage({Key? key, List<Ponto>? pontosFiltrados})
      : super(key: key);

  @override
  State<PrevissoesPage> createState() => _PrevissoesPageState();
}

class _PrevissoesPageState extends State<PrevissoesPage> {
  List<Ponto> rotasprevistas = []; // Inicialização da lista de rotas

  List<Ponto> rotasFiltradas = [];

  late List<Ponto> pontosFiltrados;

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _searchController.addListener(_filtraRotas);

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
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: _buildMapSection(), // Mapa ocupando a parte superior da tela
          ),
          _buildBottomSection(),
        ],
      ),
    );
  }

// Método que constrói a parte inferior da tela
  Widget _buildBottomSection() {
    final screenSize = MediaQuery.of(context).size;
    final listHeight = screenSize.height * 0.25;

    final vmHorario = Provider.of<HorarioViewModel>(context);
    final horario = vmHorario.horario;

    return Column(
      children: [
        Container(
          color: const Color(0xFFF0F0F0),
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Color(0xFF424242)),
            decoration: const InputDecoration(
              border: OutlineInputBorder(), // Define a borda padrão
              labelText: 'Pesquise um local de embarque',
              labelStyle: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
              ), // Define a cor do rótulo
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                ), // Cor da borda ao focar
              ),
            ),
          ),
        ),
        Container(
          color: const Color(0xFF002124),
          child: SizedBox(
            width: double.maxFinite,
            height: listHeight,
            child: ListView.builder(
              itemCount: rotasFiltradas.length,
              itemBuilder: (context, index) => GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => "",
                child: RotasprevistasItem(
                  rotasprevistas: rotasFiltradas[index],
                  horario: horario[index],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Método que constrói o mapa
  Widget _buildMapSection() {
    return const SizedBox(
      width: double.infinity,
      child:
          Mapa(), // Certifique-se de que seu widget Mapa esteja definido corretamente
    );
  }

  // Método que constrói um botão na parte inferior (se necessário)
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

  void _filtraRotas() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      rotasFiltradas = rotasprevistas
          .where((rota) => rota.endereco.toLowerCase().contains(query))
          .toList();
    });
  }
}
