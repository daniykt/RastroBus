import 'package:json_annotation/json_annotation.dart';

part 'rotasprevistas.g.dart';

@JsonSerializable()
class RotasPrevistas {
  final String id;
  final int numPonto;
  final String cor;
  final String nome;

  RotasPrevistas({
    required this.nome,
    required this.id,
    required this.cor,
    required this.numPonto,
  });

  factory RotasPrevistas.fromJson(Map<String, dynamic> json) =>
      _$RotasPrevistasFromJson(json);

  toJson() => _$RotasPrevistasToJson(this);
}
