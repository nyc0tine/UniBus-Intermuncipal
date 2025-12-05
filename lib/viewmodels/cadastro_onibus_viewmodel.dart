import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OnibusCadastroViewModel {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? ultimoErro;

  Future<bool> cadastrarOnibus({
    required String numero,
    required String marca,
    required String placa,
    required String tipo,
    required int capacidade,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        ultimoErro = "Usuário não autenticado";
        return false;
      }

      final doc = _firestore.collection("onibus").doc();

      await doc.set({
        "numero": numero,
        "marca": marca,
        "placa": placa,
        "tipo": tipo,
        "capacidade": capacidade,
        "ownerId": user.uid,
        "dataCadastro": DateTime.now(),
      });

      ultimoErro = null;
      return true;

    } catch (e) {
      ultimoErro = "Erro ao cadastrar ônibus: $e";
      return false;
    }
  }
}
