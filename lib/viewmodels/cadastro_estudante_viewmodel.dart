import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import '../models/cadastro_estudante_model.dart';

class CadastroEstudanteViewModel {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  // Método para salvar cadastro do estudante
  Future<bool> cadastrarEstudante(CadastroEstudanteModel estudante, {File? imagemPerfil}) async {
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

      String? fotoPerfilUrl;
      if (imagemPerfil != null && imagemPerfil.existsSync()) {
        fotoPerfilUrl = await _uploadFotoPerfil(userCredential.user!.uid, imagemPerfil);
      }

      // Salvar dados adicionais do estudante no Firestore
      await _firestore.collection('estudantes').doc(userCredential.user!.uid).set({
        'nome': estudante.nome,
        'email': estudante.email,
        'universidade': estudante.universidade,
        'telefone': estudante.telefone,
        'dataCadastro': DateTime.now(),
        if (fotoPerfilUrl != null) 'fotoPerfil': fotoPerfilUrl,
      });

      print('Estudante cadastrado com sucesso: ${estudante.toMap()}');
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

  // Método para fazer upload da foto de perfil
  Future<String?> _uploadFotoPerfil(String uid, File imagemPerfil) async {
    try {
      final Reference ref = _firebaseStorage.ref().child('perfis/$uid/foto_perfil.jpg');
      final UploadTask uploadTask = ref.putFile(imagemPerfil);
      final TaskSnapshot taskSnapshot = await uploadTask;
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      print('Foto de perfil enviada com sucesso: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Erro ao fazer upload da foto: $e');
      return null;
    }
  }
}