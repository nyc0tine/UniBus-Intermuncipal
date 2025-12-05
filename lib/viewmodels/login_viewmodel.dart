import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

      // Determinar o tipo real do usuário a partir do Firestore
      final userId = userCred.user?.uid;
      String tipoReal = tipoUsuario;
      if (userId != null) {
        try {
          final doc = await _firestore.collection('usuarios').doc(userId).get();
          if (doc.exists && doc.data() != null && doc.data()!.containsKey('tipo')) {
            tipoReal = doc.get('tipo') as String;
          }
        } catch (e) {
          // se houver erro ao buscar, mantemos o tipo selecionado
        }

        // Se o tipo selecionado na UI não corresponde ao tipo real, negar login
        if (tipoReal != tipoUsuario) {
          mensagemErro = 'Tipo de usuário inválido para esta conta. Faça login como $tipoReal.';
          await _firebaseAuth.signOut();
          notifyListeners();
          return false;
        }

        // Salvar dados do usuário localmente usando o tipo real
        await _salvarDadosUsuario(userId, email, tipoReal);
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
