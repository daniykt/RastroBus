import 'package:json_annotation/json_annotation.dart';

part 'horario.g.dart';

@JsonSerializable()
class Horario {
  final int id;
  final int ponto_id;
  final String hora_chegada;

  Horario({
    required this.id,
    required this.ponto_id,
    required this.hora_chegada,
  });

  factory Horario.fromJson(Map<String, dynamic> json) =>
      _$HorarioFromJson(json);

  Map<String, dynamic> toJson() => _$HorarioToJson(this); 
}
