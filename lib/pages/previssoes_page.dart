import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rastrobus/componentes/mapa.dart';
import 'package:rastrobus/componentes/rotasprevistas_item.dart';
import 'package:rastrobus/entidade/ponto.dart';
import 'package:rastrobus/vm/horario_vm.dart';
import 'package:rastrobus/vm/rotasprevistas_vm.dart';

class PrevissoesPage extends StatefulWidget {
  const PrevissoesPage({super.key});

  @override
  State<PrevissoesPage> createState() => _PrevissoesPageState();
}

class _PrevissoesPageState extends State<PrevissoesPage> {
  List<Ponto> rotasprevistas = [];
  List<Ponto> rotasFiltradas = [];
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
    final vm = Provider.of<RotasPrevistasVIewModel>(context);
    rotasprevistas = vm.rotasprevistas;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: _buildMapSection(rotasprevistas), // Usando rotasFiltradas
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
                onTap: () => Navigator.pushNamed(
                  context,
                  "/detalheponto",
                  arguments: rotasFiltradas[index].id,
                ),
                child: RotasprevistasItem(
                  rotasprevistas: rotasFiltradas[index],
                  horario: horario[index],
                  cor: Color(int.parse(rotasFiltradas[index].cor.substring(1),
                          radix: 16) +
                      0xFF000000), // Conversão de cor hex para objeto Color
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Método que constrói o mapa
  Widget _buildMapSection(List<Ponto> pontosFiltrados) {
    return const SizedBox(
      width: double.infinity,
      child: Mapa(
        buscarPontoMaisProximo: false, // Adição dos pontos filtrados ao mapa
        mostraApenasFiltrados: false,
      ),
    );
  }

  // Método para construir o botão
  // ignore: unused_element
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
