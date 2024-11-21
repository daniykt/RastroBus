import 'package:flutter/material.dart';
import 'package:rastrobus/pages/linhas_page.dart';
import 'package:rastrobus/pages/previssoes_page.dart';
import 'rota_page.dart';

class BarraNavegacao extends StatefulWidget {
  const BarraNavegacao({super.key});

  @override
  State<BarraNavegacao> createState() => _HomePageState();
}

class _HomePageState extends State<BarraNavegacao> {
  int itemSelecionado = 0; // Variável que armazena o índice do item selecionado no BottomNavigationBar.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("RastroBus"),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF004445),
      ),
      body: IndexedStack(
        index: itemSelecionado,
        children: const [
          PrevissoesPage(),
          LinhasPage(),
          RotaPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: itemSelecionado,
        selectedItemColor: Colors.blue,
        items: [
          BottomNavigationBarItem(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                itemSelecionado == 0 ? Icons.access_time : Icons.timelapse,
                key: ValueKey<int>(itemSelecionado), // Key para animar a troca
              ),
            ),
            label: "Previsões",
          ),
          BottomNavigationBarItem(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                itemSelecionado == 1 ? Icons.swap_calls : Icons.call_split,
                key: ValueKey<int>(itemSelecionado),
              ),
            ),
            label: "Linhas",
          ),
          BottomNavigationBarItem(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                itemSelecionado == 2 ? Icons.navigation : Icons.directions,
                key: ValueKey<int>(itemSelecionado),
              ),
            ),
            label: "Rotas",
          ),
        ],
        onTap: (valor) {
          setState(() {
            itemSelecionado = valor; // Atualiza o índice do item selecionado
          });
        },
      ),
    );
  }
}
