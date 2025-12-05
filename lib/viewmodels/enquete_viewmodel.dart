import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/enquete_model.dart';

class EnqueteViewModel {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String? ultimoErro;

  Future<bool> enviarResposta(String status) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ultimoErro = "Usuário não autenticado.";
        return false;
      }

      final resposta = EnqueteModel(
        userId: user.uid,
        status: status,
        data: DateTime.now(),
      );

      await _db.collection('enquetes').add(resposta.toMap());
      return true;
    } catch (e) {
      ultimoErro = e.toString();
      return false;
    }
  }
}
