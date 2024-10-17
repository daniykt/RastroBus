// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'horario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Horario _$HorarioFromJson(Map<String, dynamic> json) => Horario(
      id: (json['id'] as num).toInt(),
      pontoId: (json['pontoId'] as num).toInt(),
      horaChegada: json['horaChegada'] as String,
    );

Map<String, dynamic> _$HorarioToJson(Horario instance) => <String, dynamic>{
      'id': instance.id,
      'pontoId': instance.pontoId,
      'horaChegada': instance.horaChegada,
    };
