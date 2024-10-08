import 'package:dio/dio.dart' hide Headers;
import 'package:rastrobus/entidade/rotasprevistas.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_client.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/pontos")
  Future<List<RotasPrevistas>> getRotasPrevistas();
}
