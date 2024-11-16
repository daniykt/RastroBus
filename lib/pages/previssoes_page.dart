import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rastrobus/componentes/mapa.dart';
import 'package:rastrobus/componentes/rotasprevistas_item.dart';
import 'package:rastrobus/entidade/ponto.dart';
import 'package:rastrobus/vm/horario_vm.dart';
import 'package:rastrobus/vm/rotasprevistas_vm.dart';

class PrevissoesPage extends StatefulWidget {
  const PrevissoesPage({
    Key? key,
  }) : super(key: key);

  @override
  State<PrevissoesPage> createState() => _PrevissoesPageState();
}

class _PrevissoesPageState extends State<PrevissoesPage> {
  List<Ponto> rotasprevistas = []; // Inicialização da lista de rotas
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

  Widget _buildBottomSection() {
    final screenSize = MediaQuery.of(context).size;
    final listHeight = screenSize.height * 0.25;

    final vmHorario = Provider.of<HorarioViewModel>(context);
    final horario = vmHorario.horarios;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Color(0xFF424242)),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Pesquise um local de embarque',
              hintStyle: const TextStyle(color: Color(0xFFB0B0B0)),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF00796B)),
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFF00796B), // Cor da borda
                  width: 2.0, // Largura da borda
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFF00796B), // Cor da borda ao focar
                  width: 2.0,
                ),
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
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapSection() {
    return const SizedBox(
      width: double.infinity,
      child: Mapa(
        pontosFiltrados: [], // Certifique-se de que seu widget Mapa esteja definido corretamente
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
