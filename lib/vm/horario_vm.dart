import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:rastrobus/entidade/horario.dart';
import 'package:rastrobus/repositorio/repositorio_horarios.dart';

class HorarioViewModel extends ChangeNotifier {
  late List<Horario> horario = [];

  HorarioViewModel useLista() {
    final future = RepositorioHorario().select();

    future.then((lista) {
      horario = lista;
      notifyListeners();
    });

    return this;
  }

  Horario? getById(int id) {
    return horario.where((h) => h.id == id).firstOrNull;
  }

  static ChangeNotifierProvider<HorarioViewModel> novo() =>
      ChangeNotifierProvider(
        create: (_) => HorarioViewModel().useLista(),
      );
}