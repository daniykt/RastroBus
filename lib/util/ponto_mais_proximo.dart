import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:rastrobus/entidade/ponto.dart';
import 'package:rastrobus/util/route_query.dart';
import 'package:rastrobus/vm/rotasprevistas_vm.dart';

double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double R = 6371; // Raio da Terra em km
  double dLat = _degToRad(lat2 - lat1);
  double dLon = _degToRad(lon2 - lon1);

  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_degToRad(lat1)) *
          cos(_degToRad(lat2)) *
          sin(dLon / 2) *
          sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return R * c; // Distância em km
}

double _degToRad(double deg) {
  return deg * (pi / 180);
}

Ponto _findNearestPonto(
  double latitude,
  double longitude,
  List<Ponto> pontos,
) {
  Ponto? nearestPonto;
  double shortestDistance = double.infinity;

  for (Ponto ponto in pontos) {
    double distance = _calculateDistance(
      latitude,
      longitude,
      ponto.latitude,
      ponto.longitude,
    );

    if (distance < shortestDistance) {
      shortestDistance = distance;
      nearestPonto = ponto;
    }
  }

  return nearestPonto!;
}

void findPontoMaisProximo(BuildContext context, Position userPosition, String cor) {
  final vm = Provider.of<RotasPrevistasVIewModel>(context, listen: false);
  final pontos = vm.rotasprevistas.where((p) => p.cor == cor).toList();

  final pontoMaisProximo = _findNearestPonto(userPosition.latitude, userPosition.longitude, pontos);

  Navigator.pushNamed(context, "/route", arguments: RouteQuery(userPosition, pontoMaisProximo));
}
