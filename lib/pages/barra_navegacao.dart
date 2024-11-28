import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rastrobus/pages/linhas_page.dart';
import 'package:rastrobus/pages/previssoes_page.dart';
import 'rota_page.dart';

class BarraNavegacao extends StatefulWidget {
  const BarraNavegacao({super.key});

  @override
  State<BarraNavegacao> createState() => _HomePageState();
}

class _HomePageState extends State<BarraNavegacao>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedIndex =
      0; // Variável que armazena o índice do item selecionado no BottomNavigationBar.

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void onItemClicked(int index) {
    setState(() {
      selectedIndex = index;
      _tabController.index = selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment:
                MainAxisAlignment.start, // Alinha os itens à esquerda.
            children: [
              Expanded(
                child: Center(
                  child: Image.asset(
                    'lib/assets/images/barra2.png', // Caminho da imagem.
                    height: 90, // Ajuste a altura da imagem.
                  ),
                ),
              ),
            ],
          ),
          foregroundColor: Colors.white, // Cor dos ícones.
          backgroundColor: const Color(0xFF004445), // Cor de fundo original.
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: const [
            PrevissoesPage(),
            LinhasPage(),
            RotaPage(),
          ],
        ),
        // body: IndexedStack(
        //   //Define a parte principal da tela usando o IndexedStack,
        //   //que permite mostrar apenas um widget de uma lista,
        //   //dependendo de qual item está selecionado.
        //   index:
        //       selectedIndex, //Aqui indica qual layout vai ser escolhido com base aonde a pessoa clica
        //   children: const [
        //     PrevissoesPage(),
        //     LinhasPage(),
        //     RotaPage(),
        //   ],
        // ),
        //CurrentIndex: // Define o item selecionado atualmente.
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: const Color(0xFF004445),
          items: [
            BottomNavigationBarItem(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  // Só anima o ícone selecionado
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Icon(
                  selectedIndex == 0 ? Icons.access_time : Icons.timelapse,
                  key: ValueKey<int>(
                      selectedIndex == 0 ? 0 : -1), // Única chave por ícone
                ),
              ),
              label: "Previsões",
            ),
            BottomNavigationBarItem(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  // Só anima o ícone selecionado
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Icon(
                  selectedIndex == 1 ? Icons.swap_calls : Icons.call_split,
                  key: ValueKey<int>(
                      selectedIndex == 1 ? 1 : -1), // Única chave por ícone
                ),
              ),
              label: "Linhas",
            ),
            BottomNavigationBarItem(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  // Só anima o ícone selecionado
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Icon(
                  selectedIndex == 2 ? Icons.navigation : Icons.directions,
                  key: ValueKey<int>(
                      selectedIndex == 2 ? 2 : -1), // Única chave por ícone
                ),
              ),
              label: "Rotas",
            ),
          ],
          onTap: onItemClicked,
        ));
  }
}
