import 'package:json_annotation/json_annotation.dart';

part 'horario.g.dart';

@JsonSerializable()
class Horario {
  final int id;

  @JsonValue("ponto_id")
  final int pontoId;

  @JsonValue("hora_chegada")
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
