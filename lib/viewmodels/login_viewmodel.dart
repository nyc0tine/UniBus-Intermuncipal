import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      final userCred = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: senha,
      );

      // Salvar dados do usuário localmente após autenticação bem-sucedida
      final userId = userCred.user?.uid;
      if (userId != null) {
        await _salvarDadosUsuario(userId, email, tipoUsuario);
      }

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

  /// Salva dados do usuário localmente (SharedPreferences) e busca informações
  /// adicionais do Firestore (nome, contato, etc)
  Future<void> _salvarDadosUsuario(
    String userId,
    String email,
    String tipo,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Salvar dados básicos localmente
      await prefs.setString('userId', userId);
      await prefs.setString('email', email);
      await prefs.setString('tipoUsuario', tipo);

      // Buscar dados adicionais do Firestore
      final colecao = tipo == 'motorista' ? 'motoristas' : 'estudantes';
      final doc = await _firestore.collection(colecao).doc(userId).get();

      if (doc.exists) {
        final data = doc.data() ?? {};
        final nome = data['nome'] as String? ?? 'Usuário';
        final contato = data['contato'] as String? ?? '';
        final instituicao = data['instituicao'] as String? ?? '';

        // Salvar informações no SharedPreferences
        await prefs.setString('nomeUsuario', nome);
        await prefs.setString('contatoUsuario', contato);
        await prefs.setString('instituicaoUsuario', instituicao);
      }
    } catch (e) {
      // Falha silenciosa ao salvar dados do usuário
    }
  }
}
