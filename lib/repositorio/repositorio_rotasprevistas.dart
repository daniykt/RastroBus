import 'package:rastrobus/entidade/ponto.dart';
import 'package:rastrobus/repositorio/api/rest_client.dart';

class RepositorioRotasprevistas {
  Future<List<Ponto>> select() {
    return RestClient.instance.getPontos();
  }

  Future<Ponto> selectById(int id) {
    return RestClient.instance.getPontoById(id);
  }
}
