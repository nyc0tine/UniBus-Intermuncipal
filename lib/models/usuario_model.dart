import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Modelo de Usuário para autenticação com Firebase
class Usuario {
  String email;
  String tipo;
  String senha;

// Instância do FirebaseAuth
  FirebaseAuth auth = FirebaseAuth.instance;

// Getter para o FirebaseAuth
  Usuario(this.email, this.tipo, this.senha);

// Instância privada do FirebaseAuth
  Future<Map<String, dynamic>> criarConta() async {
    try {
      final contaCadastrada = await auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      final user = FirebaseAuth.instance.currentUser;
      final userRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user?.uid);

      await userRef.set({
        'email': email,
        'dataRegistro': DateTime.now(),
      });
// Retorna um mapa com o resultado da criação da conta
      return {
        "criado": true,
        "conta": contaCadastrada,
        "msg": "Conta criada com sucesso!",
      };
      // Captura erros específicos do FirebaseAuth 
    } on FirebaseAuthException catch (e) {
      return{ "criado": false, "msg": "Erro: ${e.message.toString()}"};
    } 
  }

// Método de login
  Future<Map<String, dynamic>> login() async {
    try {
      final credencial = await auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      FirebaseFirestore.instance
          .collection('usuarios')
          .doc(credencial.user?.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              tipo = documentSnapshot.get('tipo');
              email = documentSnapshot.get('email');
            }
          });

      return {
        "logado": true,
        "usuario": credencial.user,
        "msg": "Login realizado com sucesso!",
      };
    } on FirebaseAuthException catch (e) {
      return { "logado": false, "usuario": null, "msg": e.message};
    }
  }

// Método de logout
  Future<void> logout() async {
    return auth.signOut();
  }

// Método para resetar senha
  Future<Map<String, dynamic>> resetarSenha(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return {
        "enviado": true,
        "msg": "Email de redefinição enviado para $email",
      };
    } on FirebaseAuthException catch(e) {
      return {"enviado": false, "msg": 'Erro ao enviar email: ${e.message}'};
    }
  }
}
