import 'package:json_annotation/json_annotation.dart';

part 'horario.g.dart';

@JsonSerializable()
class Horario {
  final int id;
  final int pontoId; 
  final String horaChegada;

  Horario({
    required this.id,
    required this.pontoId,
    required this.horaChegada,
  });

 
  factory Horario.fromJson(Map<String, dynamic> json) => _$HorarioFromJson(json);

 
  toJson() => _$HorarioToJson(this);
}
