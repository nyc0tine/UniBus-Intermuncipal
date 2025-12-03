import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class CadastroEstudanteViewModel {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para salvar cadastro do estudante
  Future<bool> cadastrarEstudante(estudante) async {
    try {
      // Validar dados
      if (!estudante.isValid()) {
        throw Exception('Dados inválidos');
      }

      // Criar usuário no Firebase Auth usando email e senha
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: estudante.email,
        password: estudante.senha,
      );

      // Salvar dados adicionais do estudante no Firestore
      await _firestore.collection('estudantes').doc(userCredential.user!.uid).set({
        'nome': estudante.nome,
        'email': estudante.email,
        'universidade': estudante.universidade,
        'telefone': estudante.telefone,
        'dataCadastro': DateTime.now(),
      });

      print('Motorista cadastrado com sucesso: ${estudante.toMap()}');
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Erro: A senha é muito fraca');
      } else if (e.code == 'email-already-in-use') {
        print('Erro: O email já está registrado');
      } else if (e.code == 'invalid-email') {
        print('Erro: Email inválido');
      } else {
        print('Erro Firebase Auth: ${e.message}');
      }
      return false;
    } catch (e) {
      print('Erro ao cadastrar estudante: $e');
      return false;
    }
  }
}

