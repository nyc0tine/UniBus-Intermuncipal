import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/cadastro_motorista_model.dart';

class CadastroMotoristaViewModel {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Descrição do erro da última operação
  String? _ultimoErro;

  String? get ultimoErro => _ultimoErro;

  /// Método para salvar cadastro do motorista
  Future<bool> cadastrarMotorista(CadastroMotoristaModel motorista) async {
    try {
      // Validar dados
      if (!motorista.isValid()) {
        _ultimoErro = 'Dados inválidos';
        throw Exception('Dados inválidos');
      }

      // Criar usuário no Firebase Auth usando email e senha
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: motorista.email,
        password: motorista.senha,
      );

      // Salvar dados adicionais do motorista no Firestore
      await _firestore.collection('motoristas').doc(userCredential.user!.uid).set({
        'nome': motorista.nome,
        'email': motorista.email,
        'placa': motorista.placa,
        'telefone': motorista.telefone,
        'dataCadastro': DateTime.now(),
      });

      _ultimoErro = null;
      print('Motorista cadastrado com sucesso: ${motorista.toMap()}');
      return true;
    } on FirebaseAuthException catch (e) {
      _ultimoErro = _mapearErroFirebaseAuth(e.code);
      print('Erro Firebase Auth: $_ultimoErro');
      return false;
    } catch (e) {
      _ultimoErro = 'Erro ao cadastrar motorista: ${e.toString()}';
      print(_ultimoErro);
      return false;
    }
  }

  /// Mapeia códigos de erro do Firebase Auth para mensagens legíveis
  String _mapearErroFirebaseAuth(String code) {
    switch (code) {
      case 'weak-password':
        return 'A senha é muito fraca. Use no mínimo 6 caracteres.';
      case 'email-already-in-use':
        return 'O email já está registrado no sistema.';
      case 'invalid-email':
        return 'O email informado é inválido.';
      case 'operation-not-allowed':
        return 'Operação não permitida. Contate o suporte.';
      default:
        return 'Erro ao criar usuário: $code';
    }
  }
}

