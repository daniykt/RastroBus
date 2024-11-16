// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ponto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ponto _$PontoFromJson(Map<String, dynamic> json) => Ponto(
      id: (json['id'] as num).toInt(),
      numero: (json['numero'] as num).toInt(),
      bairro: json['bairro'] as String,
      cor: json['cor'] as String,
      endereco: json['endereco'] as String,
      imagem: json['imagem'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$PontoToJson(Ponto instance) => <String, dynamic>{
      'id': instance.id,
      'numero': instance.numero,
      'cor': instance.cor,
      'endereco': instance.endereco,
      'bairro': instance.bairro,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'imagem': instance.imagem,
    };
