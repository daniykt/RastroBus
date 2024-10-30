import 'package:rastrobus/entidade/horario.dart';
import 'package:rastrobus/repositorio/api/dio_client.dart';
import 'package:rastrobus/repositorio/api/rest_client.dart';

class RepositorioHorario {
  final RestClient _rest = RestClient(buildDioClient("http://localhost:3000"));

  Future<List<Horario>> select() {
    return _rest.getHorario();
  }
}

