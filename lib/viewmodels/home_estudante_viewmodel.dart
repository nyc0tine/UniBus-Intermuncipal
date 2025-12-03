import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/estudante_model.dart';
import '../models/motorista_model.dart';

class HomeEstudanteViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool loading = false;
  String? error;

  String? estudanteId;
  EstudanteModel? estudante;
  MotoristaModel? motorista;

  int quantidadePassageiros = 0;
  String ultimoAviso = '';

  // Retorna a data atual formatada
  String getDataAtual() {
    final agora = DateTime.now();
    final dia = agora.day.toString().padLeft(2, '0');
    final mes = agora.month.toString().padLeft(2, '0');
    final ano = agora.year;

    return '$dia/$mes/$ano';
  }

  Future<void> init({String? estudanteIdParam}) async {
    loading = true;
    notifyListeners();

    estudanteId = estudanteIdParam ?? _auth.currentUser?.uid;
    if (estudanteId == null) {
      error = 'Usuário não autenticado';
      loading = false;
      notifyListeners();
      return;
    }

    await carregarDadosEstudante();
    await carregarTrajetoHoje();

    loading = false;
    notifyListeners();
  }

  Future<void> carregarDadosEstudante() async {
    if (estudanteId == null) return;
    try {
      loading = true;
      notifyListeners();

      final doc = await _db.collection('estudantes').doc(estudanteId).get();
      if (doc.exists && doc.data() != null) {
        estudante = EstudanteModel.fromMap(doc.data()!, id: doc.id);
      }
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> carregarTrajetoHoje() async {
    if (estudanteId == null) {
      return;
    }
    try {
      loading = true;
      notifyListeners();

      // Busca trajetos de hoje do estudante
      final agora = DateTime.now();
      final inicioDia = DateTime(agora.year, agora.month, agora.day);
      final fimDia = inicioDia.add(const Duration(days: 1));

      final trajetosSnap = await _db
          .collection('estudantes')
          .doc(estudanteId)
          .collection('trajetos')
          .where('data', isGreaterThanOrEqualTo: Timestamp.fromDate(inicioDia))
          .where('data', isLessThan: Timestamp.fromDate(fimDia))
          .limit(1)
          .get();

      if (trajetosSnap.docs.isNotEmpty) {
        final trajData = trajetosSnap.docs.first.data();
        quantidadePassageiros = (trajData['passageirosCount'] as int?) ?? 0;
        final motoristaId = trajData['motoristaId'] as String?;

        if (motoristaId != null && motoristaId.isNotEmpty) {
          final mDoc = await _db.collection('motoristas').doc(motoristaId).get();
          if (mDoc.exists && mDoc.data() != null) {
            motorista = MotoristaModel.fromMap(mDoc.data()!, id: mDoc.id);
          }
        }
      }

      // busca um último aviso simples (ex.: coleção avisos vinculada ao estudante)
      final avisossnap = await _db
          .collection('estudantes')
          .doc(estudanteId)
          .collection('avisos')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();
      if (avisossnap.docs.isNotEmpty) {
        ultimoAviso = (avisossnap.docs.first.data()['texto'] as String?) ?? '';
      }
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> marcarComoLivre() async {
    if (estudanteId == null) return;
    try {
      loading = true;
      notifyListeners();

      await _db.collection('estudantes').doc(estudanteId).update({'status': 'livre'});
      estudante?.status = 'livre';
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> solicitarAlteracao({required String tipo, String? observacao}) async {
    if (estudanteId == null) return;
    try {
      loading = true;
      notifyListeners();

      await _db.collection('solicitacoes').add({
        'estudanteId': estudanteId,
        'tipo': tipo,
        'observacao': observacao ?? '',
        'status': 'pendente',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    // cancelar listeners/streams quando implementados
    super.dispose();
  }
}
