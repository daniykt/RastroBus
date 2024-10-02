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
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: Container(
                color: const Color(0xFF004445),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFF004E0A),
                      child: Text(
                        "${rotasprevistas.numPonto}",
                        style: textTheme.bodyLarge
                            ?.copyWith(color: const Color(0xFFF0F0F0)),
                      ),
                    ),
                    const SizedBox(
                        width: 16.0), // Espaçamento entre a bola e o texto
                    Expanded(
                      child: Text(
                        rotasprevistas.nome,
                        style: textTheme.bodyMedium
                            ?.copyWith(color: const Color(0xFFF0F0F0)),
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
    );
  }
}
