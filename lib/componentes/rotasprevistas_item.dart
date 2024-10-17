import 'package:flutter/material.dart';
import 'package:rastrobus/entidade/horario.dart';
import 'package:rastrobus/entidade/ponto.dart';

class RotasprevistasItem extends StatelessWidget {
  final Ponto rotasprevistas;
  final Horario horario;

  const RotasprevistasItem({
    super.key,
    required this.rotasprevistas,
    required this.horario,
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
                        "${horario.horaChegada}",
                        style: textTheme.bodyLarge
                            ?.copyWith(color: const Color(0xFFF0F0F0)),
                      ),
                    ),
                    const SizedBox(
                        width: 16.0), // Espaçamento entre a bola e o texto
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${rotasprevistas.endereco},",
                              style: textTheme.bodyMedium
                                  ?.copyWith(color: const Color(0xFFF0F0F0)),
                              overflow: TextOverflow
                                  .ellipsis, // Para truncar o texto se for muito longo
                            ),
                            Text(
                              "Bairro - ${rotasprevistas.bairro}",
                              style: textTheme.bodyMedium
                                  ?.copyWith(color: const Color(0xFFF0F0F0)),
                              overflow: TextOverflow
                                  .ellipsis, // Para truncar o texto se for muito longo
                            ),
                          ]),
                    )),
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
