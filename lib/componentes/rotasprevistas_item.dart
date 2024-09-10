import 'package:flutter/material.dart';
import 'package:rastrobus/entidade/rotasprevistas.dart';

class RotasprevistasItem extends StatelessWidget {
  final RotasPrevistas rotasprevistas;

  const RotasprevistasItem({
    super.key,
    required this.rotasprevistas,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Material(
          elevation: 7,
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: Container(
                  color: const Color(0xFF0D6067),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFF004E0A),
                        child: Text(
                          "${rotasprevistas.numPonto}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                          width: 16.0), // Espaçamento entre a bola e o texto
                      Expanded(
                        child: Text(
                          rotasprevistas.nome,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          overflow: TextOverflow
                              .ellipsis, // Para truncar o texto se for muito longo
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
