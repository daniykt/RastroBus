// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'horario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Horario _$HorarioFromJson(Map<String, dynamic> json) => Horario(
      id: (json['id'] as num).toInt(),
      pontoId: (json['ponto_id'] as num).toInt(),
      horaChegada: json['hora_chegada'] as String,
    );

Map<String, dynamic> _$HorarioToJson(Horario instance) => <String, dynamic>{
      'id': instance.id,
      'ponto_id': instance.pontoId,
      'hora_chegada': instance.horaChegada,
    };
