import 'package:rastrobus/entidade/ponto.dart';
import 'package:rastrobus/repositorio/api/dio_client.dart';
import 'package:rastrobus/repositorio/api/rest_client.dart';

class RepositorioRotasprevistas {
  final RestClient _rest = RestClient(buildDioClient("http://localhost:3000"));

  Future<List<Ponto>> select() {
    return _rest.getPontos();
  }

  Future<Ponto> selectById(int id) {
    return _rest.getPontoById(id);
  }
}
