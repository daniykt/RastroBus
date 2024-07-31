import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// Aplicativo principal
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

// Página principal com navegação inferior
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Índice da aba selecionada
  int _selectedIndex = 0;

  // Lista de widgets para cada aba
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Previsões'),
    Text('Linhas'),
    Rotas(),
  ];

  // Função chamada quando um item da barra de navegação inferior é selecionado
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RastroBus'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Previsões',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_calls),
            label: 'Linhas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.navigation),
            label: 'Rotas',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue, // Cor dos ícones selecionados
        onTap: _onItemTapped,
      ),
    );
  }
}

// Widget para a aba 'Rotas'
class Rotas extends StatelessWidget {
  const Rotas({super.key});

  @override
  Widget build(BuildContext context) {
    return RotasWidget();
  }
}

// Widget para a tela de 'Rotas'
class RotasWidget extends StatelessWidget {
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
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Sua Posição',
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Destino Final',
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Buscar'),
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
                    Text(
                      'PONTO MAIS PRÓXIMO',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: Size(double.infinity, 80),
                      ),
                      child: Text('Azul', style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: Size(double.infinity, 80),
                      ),
                      child: Text('Vermelho', style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: Size(double.infinity, 80),
                      ),
                      child: Text('Verde', style: TextStyle(fontSize: 18, color: Colors.white)),
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
