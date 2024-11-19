import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:rastrobus/entidade/ponto.dart';
import 'package:rastrobus/repositorio/repositorio_rotasprevistas.dart';

class RotasPrevistasVIewModel extends ChangeNotifier {
  late List<Ponto> rotasprevistas = [];

  RotasPrevistasVIewModel useLista() {
    final future = RepositorioRotasprevistas().select();

    future.then((lista) {
      rotasprevistas = lista;
      notifyListeners();
    });

    return this;
  }

  Future<List<Ponto>> loadPontos() async {
    final items = await RepositorioRotasprevistas().select();
    rotasprevistas = items;

    notifyListeners();

    return items;
  }

  Future<Ponto> loadPontoById(int id) async {
    return await RepositorioRotasprevistas().selectById(id);
  }

  Ponto? getById(int id) {
    return rotasprevistas.where((rp) => rp.id == id).firstOrNull;
  }

  List<Ponto> rotasVerdes() {
    return rotasprevistas.where((rota) => rota.cor == '#00FF00').toList();
  }

  List<Ponto> rotasVermelhas() {
    return rotasprevistas.where((rota) => rota.cor == '#FF0000').toList();
  }

  List<Ponto> rotasAzuis() {
    return rotasprevistas.where((rota) => rota.cor == '#0000FF').toList();
  }

  static ChangeNotifierProvider<RotasPrevistasVIewModel> novo() =>
      ChangeNotifierProvider(
        create: (_) => RotasPrevistasVIewModel().useLista(),
      );

  loadHorarioChegadaByPontoId(int id) {}
}
