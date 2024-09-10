import 'package:rastrobus/entidade/rotasprevistas.dart';

class RepositorioRotasprevistas {
  List<RotasPrevistas> select() {
    return <RotasPrevistas>[
      RotasPrevistas(
        nome: "Previssões-1",
        id: "1",
        numPonto: 1,
      ),
      RotasPrevistas(
        nome: "Previssoes-2",
        id: "2",
        numPonto: 2,
      ),
      RotasPrevistas(
        nome: "Previssoes-3",
        id: "3",
        numPonto: 3,
      ),
      RotasPrevistas(
        nome: "Previssoes-4",
        id: "4",
        numPonto: 4,
      ),
      RotasPrevistas(
        nome: "Previssoes-5",
        id: "5",
        numPonto: 5,
      ),
      RotasPrevistas(
        nome: "Previssoes-6",
        id: "6",
        numPonto: 6,
      ),
      RotasPrevistas(
        nome: "Previssoes-7",
        id: "7",
        numPonto: 7,
      ),
    ];
  }
}
