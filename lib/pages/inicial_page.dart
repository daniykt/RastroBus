import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rastrobus/pages/barra_navegacao.dart';

class InicioPage extends StatefulWidget {
  @override
  _InicioPageState createState() => _InicioPageState();
}

const _animationDuration = Duration(seconds: 3);

class _InicioPageState extends State<InicioPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: _animationDuration,
      vsync: this,
    )..forward();

    _animation = _controller.drive(CurveTween(curve: Curves.easeInOut));

    _iniciarTransicao();
  }

  void _iniciarTransicao() async {
    await Future.delayed(_animationDuration);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BarraNavegacao()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _animation,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Centraliza os widgets na vertical
            children: [
              Image.asset(
                'lib/assets/images/inicio.png',
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.width * 0.7,
              ),
              const SizedBox(height: 16), // Espaço entre a imagem e o texto
              Text(
                'RastroBus',
                style: GoogleFonts.poppins(
                  fontSize: 40, // Tamanho da fonte
                  fontWeight: FontWeight.bold, // Texto em negrito
                  color: Colors.black, // Cor do texto
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
