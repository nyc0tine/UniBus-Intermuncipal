import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String tipoUsuario = "estudante";
  String? mensagemErro;

  void setTipoUsuario(String value) {
    tipoUsuario = value;
    notifyListeners();
  }

  Future<bool> login(String email, String senha) async {
    try {
      // Validar campos vazios
      if (email.isEmpty || senha.isEmpty) {
        mensagemErro = "Preencha todos os campos.";
        notifyListeners();
        return false;
      }

      // Autenticar com Firebase Auth
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: senha,
      );

      mensagemErro = null;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      // Mapear erros do Firebase para mensagens amigáveis
      if (e.code == 'user-not-found') {
        mensagemErro = "Usuário não encontrado.";
      } else if (e.code == 'wrong-password') {
        mensagemErro = "Senha incorreta.";
      } else if (e.code == 'invalid-email') {
        mensagemErro = "Email inválido.";
      } else if (e.code == 'user-disabled') {
        mensagemErro = "Usuário desativado.";
      } else {
        mensagemErro = "Erro ao fazer login: ${e.message}";
      }
      notifyListeners();
      return false;
    } catch (e) {
      mensagemErro = "Erro inesperado: $e";
      notifyListeners();
      return false;
    }
  }
}
