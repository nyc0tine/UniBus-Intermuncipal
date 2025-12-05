import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/cadastro_motorista_model.dart';

class CadastroMotoristaViewModel {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String? ultimoErro;

  Future<bool> cadastrarMotorista(CadastroMotoristaModel motorista) async {
    try {
      if (!motorista.isValid()) {
        ultimoErro = "Dados inválidos";
        return false;
      }

      // cria usuário
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: motorista.email,
        password: motorista.senha,
      );

      final uid = cred.user!.uid;

      await _firestore.collection("motoristas").doc(uid).set({
        "nome": motorista.nome,
        "email": motorista.email,
        "placa": motorista.placa,
        "telefone": motorista.telefone,
        "dataCadastro": DateTime.now(),
      });

      return true;
    } on FirebaseAuthException catch (e) {
      ultimoErro = _traduzErro(e.code);
      return false;
    } catch (e) {
      ultimoErro = "Erro inesperado: $e";
      return false;
    }
  }

  String _traduzErro(String code) {
    switch (code) {
      case 'email-already-in-use':
        return "Email já cadastrado.";
      case 'weak-password':
        return "A senha deve ter pelo menos 6 caracteres.";
      case 'invalid-email':
        return "Email inválido.";
      default:
        return "Erro: $code";
    }
  }
}
