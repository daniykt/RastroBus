import 'package:flutter/material.dart';

class RotaPage extends StatefulWidget {
  const RotaPage({super.key});

  @override
  State<RotaPage> createState() => _RotaPageState();
}

class _RotaPageState extends State<RotaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Column(
        children: <Widget>[
          // Parte do topo com campos de entrada e botão
          Container( 
            color: Color.fromARGB(129, 28, 199, 128), // Cor de fundo da parte superior
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
               const TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Sua Posição',
                    labelStyle: TextStyle(color: Colors.white),
                    focusedBorder: OutlineInputBorder( //quando clicar para escreve a sua posição fica azul
                      borderSide: BorderSide(color: Colors.blue),
                    )
                  ),
                ),
               const SizedBox(height: 8),
               const TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Destino Final',
                    labelStyle: TextStyle(color: Colors.white),
                    focusedBorder: OutlineInputBorder( //quando clicar para escreve a sua posição fica azul
                      borderSide: BorderSide(color: Colors.blue),
                    )
                  ),
                ),
               const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Buscar', style: TextStyle(color: Colors.blue),),
                  
                ),
              ],
            ),
          ),
          // Parte inferior com botões
        Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'PONTO MAIS PRÓXIMO',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: Size(double.infinity, 80), //Controla o tamanho do botão
                      ),
                      child: const Text('Azul', style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: Size(double.infinity, 80), //Controla o tamanho do botão
                      ),
                      child: const Text('Vermelho', style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, "/rotasprevistas"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: Size(double.infinity, 80), //Controla o tamanho do botão
                      ),
                      child: const Text('Verde', style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
       ),
    );
  }
}