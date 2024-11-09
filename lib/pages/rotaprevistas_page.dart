import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rastrobus/componentes/mapa.dart';
import 'package:rastrobus/componentes/rotasprevistas_item.dart';
import 'package:rastrobus/entidade/ponto.dart';
import 'package:rastrobus/vm/horario_vm.dart';
import 'package:rastrobus/vm/rotasprevistas_vm.dart';

// ignore: must_be_immutable
class RotasPrevistasPage extends StatelessWidget {
  RotasPrevistasPage({super.key, this.selectedColor = ''});

  late String? selectedColor;
  bool buscarPontoMaisProximo = false;

  @override
  Widget build(BuildContext context) {

    Map<String, dynamic>? argumens = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    selectedColor = argumens?['cor'];
    buscarPontoMaisProximo = argumens?['buscar_ponto_mais_proximo'];

    print(buscarPontoMaisProximo);
    

    final textTheme = Theme.of(context).textTheme;
    final screenSize = MediaQuery.of(context).size;
    final listHeight = screenSize.height * 0.25;
    final vm = Provider.of<RotasPrevistasVIewModel>(context);
    List<Ponto> rotasprevistas = [];
    final vmHorario = Provider.of<HorarioViewModel>(context);
    final horario = vmHorario.horario;

    switch (selectedColor) {
      case 'azul':
        rotasprevistas = vm.rotasAzuis();
        break;
      case 'verde':
        rotasprevistas = vm.rotasVerdes();
        break;
      case 'vermelho':
        rotasprevistas = vm.rotasVermelhas();
        break;
      default:
        rotasprevistas = vm.rotasprevistas;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Previsões",
          style: textTheme.titleLarge?.copyWith(color: const Color(0xFFF0F0F0)),
        ),
        backgroundColor: const Color(0xFF004445),
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Mapa(rotasprevistas: rotasprevistas, buscarPontoMaisProximo: buscarPontoMaisProximo,),
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
                    horario: horario[index],
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

