import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:rastrobus/entidade/horario.dart';
import 'package:rastrobus/repositorio/repositorio_horarios.dart';

class HorarioViewModel extends ChangeNotifier {
  late List<Horario> horarios = [];

  HorarioViewModel useLista() {
    final future = RepositorioHorario().select();

    future.then((lista) {
      horarios = lista;
      notifyListeners();
    });

    return this;
  }

  Future<List<Horario>> loadHorarios() async {
    final items = await RepositorioHorario().select();
    horarios = items;

    notifyListeners();

    return items;
  }

  Future<Horario?> loadHorarioByPontoId(int pontoId) async {
    final horario = await RepositorioHorario().selectByPontoId(pontoId);
    return horario;
  }

  Horario? getByPontoId(int pontoId) {
    try {
      return horarios.firstWhere((h) => h.ponto_id == pontoId);
    } catch (e) {
      return null;
    }
  }

  static ChangeNotifierProvider<HorarioViewModel> novo() =>
      ChangeNotifierProvider(
        create: (_) => HorarioViewModel().useLista(),
      );
}
