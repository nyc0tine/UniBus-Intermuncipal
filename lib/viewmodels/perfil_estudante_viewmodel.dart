import 'package:flutter/material.dart';
import '../models/perfil_estudante_model.dart';

class PerfilEstudanteViewModel extends ChangeNotifier {
  PerfilEstudante? estudante;

  void carregarPerfil(String id) {
    estudante = PerfilEstudante(
      id: id,
      nome: "Ana Beatriz",
      instituicao: "Uninassau",
    );
    notifyListeners();
  }
}
