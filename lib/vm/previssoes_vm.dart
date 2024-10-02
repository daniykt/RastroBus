import 'package:flutter/foundation.dart';
import 'package:rastrobus/entidade/previssoes.dart';
import 'package:provider/provider.dart';
import 'package:rastrobus/repositorio/repositorio_previssoes.dart';

class PrevissoesViewModel extends ChangeNotifier {
  late List<Previssoes> previssoes;

  PrevissoesViewModel useLista(List<Previssoes> previssoes) {
    this.previssoes = previssoes;
    notifyListeners();
    return this;
  }

  static ChangeNotifierProvider<PrevissoesViewModel> novo() =>
      ChangeNotifierProvider(
        create: (_) => PrevissoesViewModel().useLista(
          RepositorioPrevissoes().select(),
        ),
      );
}
