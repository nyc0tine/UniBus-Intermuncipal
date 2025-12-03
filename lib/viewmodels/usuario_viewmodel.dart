import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/usuario_model.dart';

class UsuarioViewModel extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _usuarioId;
  String? get usuarioId => _usuarioId;

  String? _msgTelaLogin;
  String? get msgTelaLogin => _msgTelaLogin;

  String? _nomeUsuario;
  String? get nomeUsuario => _nomeUsuario;

  String? _emailUsuario;
  String? get emailUsuario => _emailUsuario;

  Usuario? usuario;

  /// Cadastra um novo usuário no Firebase Auth e Firestore
  Future<bool> cadastrarUsuario(String nome, String email, String senha, String tipo) async {
    try {
      usuario = Usuario(email, tipo, senha);
      final resultado = await usuario!.criarConta();

      if (resultado["criado"]) {
        // Salvar informações adicionais no Firestore
        final user = _firebaseAuth.currentUser;
        if (user != null) {
          await _firestore.collection('usuarios').doc(user.uid).update({
            'nome': nome,
            'tipo': tipo,
            'dataCadastro': DateTime.now(),
          });

          _usuarioId = user.uid;
          _nomeUsuario = nome;
          _emailUsuario = email;
          _msgTelaLogin = resultado["msg"];
        }

        notifyListeners();
        return true;
      } else {
        _msgTelaLogin = resultado["msg"];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _msgTelaLogin = "Erro ao cadastrar usuário: $e";
      notifyListeners();
      return false;
    }
  }

  /// Realiza login com email e senha
  Future<bool> login(String email, String senha) async {
    try {
      usuario = Usuario(email, "", senha);
      final resultado = await usuario!.login();

      if (resultado["logado"]) {
        final usuarioLogado = resultado["usuario"] as User?;

        if (usuarioLogado != null) {
          // Buscar dados adicionais do usuário no Firestore
          final docSnapshot = await _firestore
              .collection('usuarios')
              .doc(usuarioLogado.uid)
              .get();

          if (docSnapshot.exists) {
            usuario?.tipo = docSnapshot.get('tipo') ?? 'estudante';
            _nomeUsuario = docSnapshot.get('nome') ?? usuarioLogado.displayName ?? "";
          }

          _usuarioId = usuarioLogado.uid;
          _emailUsuario = usuarioLogado.email ?? "";
          _nomeUsuario = usuarioLogado.displayName ?? _nomeUsuario ?? "";
          _msgTelaLogin = resultado["msg"];

          notifyListeners();
          return true;
        }
      } else {
        _msgTelaLogin = resultado["msg"];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _msgTelaLogin = "Erro ao fazer login: $e";
      notifyListeners();
      return false;
    }

    return false;
  }

  /// Realiza logout do usuário
  Future<void> logout() async {
    try {
      await usuario?.logout();
      usuario = null;
      _usuarioId = null;
      _nomeUsuario = null;
      _emailUsuario = null;
      _msgTelaLogin = null;
      notifyListeners();
    } catch (e) {
      _msgTelaLogin = "Erro ao fazer logout: $e";
      notifyListeners();
    }
  }

  /// Envia email de recuperação de senha
  Future<bool> resetarSenha(String email) async {
    try {
      usuario = Usuario(email, "", "");
      final resultado = await usuario!.resetarSenha(email);

      if (resultado["enviado"]) {
        _msgTelaLogin = resultado["msg"];
        notifyListeners();
        return true;
      } else {
        _msgTelaLogin = resultado["msg"];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _msgTelaLogin = "Erro ao resetar senha: $e";
      notifyListeners();
      return false;
    }
  }

  /// Retorna o usuário autenticado atualmente
  User? obterUsuarioAtual() {
    return _firebaseAuth.currentUser;
  }

  /// Verifica se há usuário logado
  bool estaLogado() {
    return _firebaseAuth.currentUser != null;
  }
}
