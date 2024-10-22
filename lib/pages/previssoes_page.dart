import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rastrobus/componentes/mapa.dart';
import 'package:rastrobus/componentes/rotasprevistas_item.dart';
import 'package:rastrobus/vm/rotasprevistas_vm.dart';

class PrevissoesPage extends StatefulWidget {
  const PrevissoesPage({Key? key}) : super(key: key);

  @override
  State<PrevissoesPage> createState() => _PrevissoesPageState();
}

class _PrevissoesPageState extends State<PrevissoesPage> {
  List<dynamic> rotasprevistas = []; // Inicialização da lista de rotas

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
  final vm = Provider.of<RotasPrevistasVIewModel>(context);
  final rotasprevistas = vm.rotasprevistas;

  

  return Column(
    children: [
      Container(
        color: const Color(0xFFF0F0F0),
        padding: const EdgeInsets.all(8.0),
        child: const TextField(
          style: TextStyle(color: Color(0xFF424242)),
          decoration: InputDecoration(
            border: OutlineInputBorder(), // Define a borda padrão
            labelText: 'Pesquise um local de embarque',
            labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)), // Define a cor do rótulo
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue), // Cor da borda ao focar
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
            itemCount: rotasprevistas.length,
            itemBuilder: (context, index) => GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => "",
              child: RotasprevistasItem(
                rotasprevistas: rotasprevistas[index],
                cor: Color(int.parse(rotasprevistas[index].cor.substring(1), radix: 16) + 0xFF000000), //Converte a cor hexadecimal para um objeto Color
                  //verde: #00FF00
                  //azul: #0000FF
                  //vermelho: #FF0000
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
}

//Mapa de Cores
//class ColorMap {
 // static const Map<String, String> colors = {
 //   "#verde": "00FF00",
 //   "#azul": "0000FF"};
//}

