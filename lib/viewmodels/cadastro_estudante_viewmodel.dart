import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/cadastro_estudante_model.dart';

class CadastroEstudanteViewModel {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _ultimoErro;
  String? get ultimoErro => _ultimoErro;

  Future<bool> cadastrarEstudante(CadastroEstudanteModel estudante) async {
    try {
      if (!estudante.isValid()) {
        _ultimoErro = 'Dados inválidos';
        return false;
      }

      // 🔹 Cria usuário no Firebase Auth
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: estudante.email,
        password: estudante.senha,
      );

      final uid = userCredential.user!.uid;

      // 🔹 Dados do Firestore (sem foto!)
      final data = {
        'nome': estudante.nome,
        'email': estudante.email,
        'universidade': estudante.universidade,
        'telefone': estudante.telefone,
        'dataCadastro': DateTime.now(),
      };

      // 🔹 Salva no Firestore
      await _firestore.collection('estudantes').doc(uid).set(data);

      _ultimoErro = null;
      return true;
    } on FirebaseAuthException catch (e) {
      _ultimoErro = _mapearErroFirebaseAuth(e.code);
      return false;
    } catch (e) {
      _ultimoErro = 'Erro ao cadastrar estudante.';
      return false;
    }
  }

  String _mapearErroFirebaseAuth(String code) {
    switch (code) {
      case 'weak-password':
        return 'A senha é muito fraca. Use no mínimo 6 caracteres.';
      case 'email-already-in-use':
        return 'O e-mail já está registrado no sistema.';
      case 'invalid-email':
        return 'O e-mail informado é inválido.';
      default:
        return 'Erro ao criar usuário: $code';
    }
  }
}
