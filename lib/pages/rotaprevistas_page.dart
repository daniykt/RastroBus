import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rastrobus/componentes/mapa.dart';
import 'package:rastrobus/componentes/rotasprevistas_item.dart';
import 'package:rastrobus/vm/rotasprevistas_vm.dart';

class RotasPrevistasPage extends StatelessWidget {
  const RotasPrevistasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenSize = MediaQuery.of(context).size;
    final listHeight = screenSize.height * 0.25;
    final vm = Provider.of<RotasPrevistasVIewModel>(context);
    final rotasprevistas = vm.rotasprevistas;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Previssões",
          style: textTheme.titleLarge?.copyWith(color: const Color(0xFFF0F0F0)),
        ),
        backgroundColor: const Color(0xFF004445),
      ),
      body: Column(
        children: [
          const Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Mapa(),
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

//código consulta
/*  padding:

                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: const SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color(0xFF54AE33),
                          child: Text(
                            '54',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                            width: 16.0), // Espaçamento entre a bola e o texto
                        Expanded(
                          child: Text(
                            'Av. Odone Marchesan, 1234',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            overflow: TextOverflow
                                .ellipsis, // Para truncar o texto se for muito longo
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0), // Espaçamento entre as linhas
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color(0xFF54AE33),
                          child: Text(
                            '55',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                            width: 16.0), // Espaçamento entre a bola e o texto
                        Expanded(
                          child: Text(
                            'Rua Piririn, 1245',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),*/


  