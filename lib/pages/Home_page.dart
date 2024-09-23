import 'package:flutter/material.dart';
import 'Rota_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int itemSelecionado = 0; // Variável que armazena o índice do item selecionado no BottomNavigationBar.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RastroBus"),
      ),
       body: IndexedStack( //Define a parte principal da tela usando o IndexedStack, 
       //que permite mostrar apenas um widget de uma lista, 
       //dependendo de qual item está selecionado.
        index: itemSelecionado, //Aqui indica qual layout vai ser escolhido com base aonde a pessoa clica
        children: const [
          Center(child: Text("Previsões")),
          Center(child: Text("Linhas")),
          RotaPage(), 
        ],
      ),                         
                     //CurrentIndex: // Define o item selecionado atualmente.
       bottomNavigationBar: BottomNavigationBar(currentIndex: itemSelecionado, selectedItemColor: Colors.blue ,items: const [
        BottomNavigationBarItem(icon: Icon(Icons.access_time), label: "Previsões"),
        BottomNavigationBarItem(icon: Icon(Icons.swap_calls), label: "Linhas"),
        BottomNavigationBarItem(icon: Icon(Icons.navigation), label: "Rotas")
      ],
      onTap: (valor) { // Função chamada quando um item é tocado.
        setState(() { // Atualiza o estado do widget.
          itemSelecionado = valor; // Atualiza o índice do item selecionado.
        });
      }
      ),
    );
  }
}