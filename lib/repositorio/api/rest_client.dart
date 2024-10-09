import 'package:dio/dio.dart' hide Headers;
import 'package:rastrobus/entidade/ponto.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_client.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/ponto")
  Future<List<Ponto>> getPontos();
}
