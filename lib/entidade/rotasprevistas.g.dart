// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rotasprevistas.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RotasPrevistas _$RotasPrevistasFromJson(Map<String, dynamic> json) =>
    RotasPrevistas(
      nome: json['nome'] as String,
      id: json['id'] as String,
      cor: json['cor'] as String,
      numPonto: (json['numPonto'] as num).toInt(),
    );

Map<String, dynamic> _$RotasPrevistasToJson(RotasPrevistas instance) =>
    <String, dynamic>{
      'id': instance.id,
      'numPonto': instance.numPonto,
      'cor': instance.cor,
      'nome': instance.nome,
    };
