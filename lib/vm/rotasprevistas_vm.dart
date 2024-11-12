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

  static ChangeNotifierProvider<RotasPrevistasVIewModel> novo() =>
      ChangeNotifierProvider(
        create: (_) => RotasPrevistasVIewModel(),
      );
}
