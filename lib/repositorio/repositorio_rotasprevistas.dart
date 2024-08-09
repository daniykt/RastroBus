import 'package:rastrobus/entidade/rotasprevistas.dart';

class RepositorioRotasprevistas {
  List<RotasPrevistas> select() {
    return <RotasPrevistas>[
      RotasPrevistas(
        nome: "Rotas do Ônibus",
      ),
    ];
  }
}
