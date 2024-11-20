import 'package:json_annotation/json_annotation.dart';

part 'horario.g.dart';

@JsonSerializable()
class Horario {
  final int id;

  @JsonKey(name: "ponto_id")
  final int pontoId;

  @JsonKey(name: "hora_chegada")
  final String horaChegada;

  Horario({
    required this.id,
    required this.pontoId,
    required this.horaChegada,
  });

  factory Horario.fromJson(Map<String, dynamic> json) =>
      _$HorarioFromJson(json);

  Map<String, dynamic> toJson() => _$HorarioToJson(this);
}
