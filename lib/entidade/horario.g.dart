// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'horario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Horario _$HorarioFromJson(Map<String, dynamic> json) => Horario(
      id: (json['id'] as num).toInt(),
      ponto_id: (json['ponto_id'] as num).toInt(),
      hora_chegada: json['hora_chegada'] as String,
    );

Map<String, dynamic> _$HorarioToJson(Horario instance) => <String, dynamic>{
      'id': instance.id,
      'ponto_id': instance.ponto_id,
      'hora_chegada': instance.hora_chegada,
    };
