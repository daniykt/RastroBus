import 'package:rastrobus/entidade/rotasprevistas.dart';
import 'package:rastrobus/repositorio/api/dio_client.dart';
import 'package:rastrobus/repositorio/api/rest_client.dart';

class RepositorioRotasprevistas {
  final RestClient _rest = RestClient(buildDioClient("http://localhost:3000"));

  Future<List<RotasPrevistas>> select() {
    return _rest.getRotasPrevistas();
  }
}
