import 'package:rastrobus/entidade/horario.dart';
import 'package:rastrobus/repositorio/api/rest_client.dart';

class RepositorioHorario {
  Future<List<Horario>> select() {
    return RestClient.instance.getHorario();
  }
}

