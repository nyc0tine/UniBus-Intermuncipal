import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  String tipoUsuario = "estudante";
  String? mensagemErro;

  void setTipoUsuario(String value) {
    tipoUsuario = value;
    notifyListeners();
  }

  Future<bool> login(String email, String senha) async {
    // Aqui você implementa a lógica real de login (API, Firebase, etc)

    if (email.isEmpty || senha.isEmpty) {
      mensagemErro = "Preencha todos os campos.";
      return false;
    }

    // EXEMPLO de autenticação mock
    if (email == "teste@teste.com" && senha == "123") {
      return true;
    } else {
      mensagemErro = "Email ou senha incorretos.";
      return false;
    }
  }
}
