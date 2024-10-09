import 'package:json_annotation/json_annotation.dart';

part "ponto.g.dart";

@JsonSerializable()
class Ponto {
  final int id;
  final int numero;
  final String cor;
  final String endereco;
  final String bairro;
  final double latitude;
  final double longitude;
  final String imagem;

  Ponto({
    required this.id,
    required this.numero,
    required this.bairro,
    required this.cor,
    required this.endereco,
    required this.imagem,
    required this.latitude,
    required this.longitude,
  });

  factory Ponto.fromJson(Map<String, dynamic> json) => _$PontoFromJson(json);

  toJson() => _$PontoToJson(this);
}
