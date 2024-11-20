import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rastrobus/componentes/mapa.dart';
import 'package:rastrobus/componentes/rotasprevistas_item.dart';
import 'package:rastrobus/vm/horario_vm.dart';
import 'package:rastrobus/vm/rotasprevistas_vm.dart';

class RotasPrevistasPage extends StatelessWidget {
  const RotasPrevistasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenSize = MediaQuery.of(context).size;
    final listHeight = screenSize.height * 0.25;

    // Obtendo os parâmetros passados via navegação (se houver)
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final selectedColor = arguments?['cor'];
    final buscarPontoMaisProximo =
        arguments?['buscar_ponto_mais_proximo'] ?? false;

    // ViewModels para obter as rotas previstas e horários
    final vm = Provider.of<RotasPrevistasVIewModel>(context);
    final vmHorario = Provider.of<HorarioViewModel>(context);
    final horario = vmHorario.horario;

    // Filtrando as rotas conforme a cor selecionada
    // List<Ponto> rotasprevistas = [];
    // switch (selectedColor) {
    //   case '#0000FF':
    //     rotasprevistas = vm.rotasAzuis();
    //     break;
    //   case '#00FF00':
    //     rotasprevistas = vm.rotasVerdes();
    //     break;
    //   case '#FF0000':
    //     rotasprevistas = vm.rotasVermelhas();
    //     break;
    //   default:
    //     rotasprevistas = vm.rotasprevistas;
    // }

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
              child: Mapa(
                rotasprevistas: vm.rotasExibicao,
                buscarPontoMaisProximo: buscarPontoMaisProximo,
                keepAlive: false,
              ),
            ),
          ),
          Container(
            color: const Color(0xFF002124),
            child: SizedBox(
              width: double.maxFinite,
              height: listHeight,
              child: ListView.builder(
                itemCount: vm.rotasExibicao.length,
                itemBuilder: (context, index) => GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.pushNamed(
                    context,
                    "/detalheponto",
                    arguments: vm.rotasExibicao[index].id,
                  ),
                  child: RotasprevistasItem(
                    rotasprevistas: vm.rotasExibicao[index],
                    horario: horario[index],
                    cor: Color(int.parse(vm.rotasExibicao[index].cor.substring(1),
                            radix: 16) +
                        0xFF000000), // Converte a cor hexadecimal para um objeto Color
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
