import 'package:flutter/material.dart';
import 'package:rastrobus/pages/linhas_page.dart';
import 'package:rastrobus/pages/previssoes_page.dart';
import 'rota_page.dart';

class BarraNagegacao extends StatefulWidget {
  const BarraNagegacao({super.key});

  @override
  State<BarraNagegacao> createState() => _HomePageState();
}

class _HomePageState extends State<BarraNagegacao>
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
        title: const Text("RastroBus"),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF004445),
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
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.access_time),
              label: "Previsões",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.swap_calls),
              label: "Linhas",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.navigation),
              label: "Rotas",
            )
          ],
          onTap: onItemClicked),
    );
  }
}
