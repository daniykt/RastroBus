import 'package:geolocator/geolocator.dart';
import 'package:rastrobus/entidade/ponto.dart';

class RouteQuery {
  final Position posicaoUsuario;
  final Ponto destino;

  RouteQuery(this.posicaoUsuario, this.destino);
}