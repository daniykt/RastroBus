import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:rastrobus/entidade/rotasprevistas.dart';
import 'package:rastrobus/repositorio/repositorio_rotasprevistas.dart';

class RotasPrevistasVIewModel extends ChangeNotifier {
  late List<RotasPrevistas> rotasprevistas = [];

  RotasPrevistasVIewModel useLista() {
    final future = RepositorioRotasprevistas().select();

    future.then((lista) {
      rotasprevistas = lista;
      notifyListeners();
    });

    return this;
  }

  RotasPrevistas? getById(String id) {
    return rotasprevistas.where((rp) => rp.id == id).firstOrNull;
  }

  static ChangeNotifierProvider<RotasPrevistasVIewModel> novo() =>
      ChangeNotifierProvider(
        create: (_) => RotasPrevistasVIewModel().useLista(),
      );
}
