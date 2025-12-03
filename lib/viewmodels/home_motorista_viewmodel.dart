import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeMotoristaViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool loading = false;
  String? error;

  String? motoristaId;
  Map<String, dynamic>? motoristaData;
  String motoristaNome = '';
  String motoristaContato = '';

  DateTime dataSelecionada = DateTime.now();
  List<Map<String, dynamic>> viagensHoje = [];
  List<Map<String, dynamic>> estudantes = [];
  List<String> avisos = [];
  String? veiculo;

  // Retorna a data formatada (DD/MM/YYYY)
  String getDataFormatada([DateTime? data]) {
    final d = data ?? DateTime.now();
    final dia = d.day.toString().padLeft(2, '0');
    final mes = d.month.toString().padLeft(2, '0');
    final ano = d.year;
    return '$dia/$mes/$ano';
  }

  Future<void> init({String? motoristaIdParam}) async {
    loading = true;
    notifyListeners();

    motoristaId = motoristaIdParam ?? _auth.currentUser?.uid;
    if (motoristaId == null) {
      error = 'Usuário não autenticado';
      loading = false;
      notifyListeners();
      return;
    }

    await carregarDadosMotorista();
    await carregarViagensHoje();
    await carregarAvisos();

    loading = false;
    notifyListeners();
  }

  Future<void> carregarDadosMotorista() async {
    if (motoristaId == null) return;
    try {
      loading = true;
      notifyListeners();

      final doc = await _db.collection('motoristas').doc(motoristaId).get();
      if (doc.exists && doc.data() != null) {
        motoristaData = doc.data()!;
        motoristaNome = (motoristaData!['nome'] as String?) ?? '';
        motoristaContato = (motoristaData!['contato'] as String?) ?? '';
        veiculo = (motoristaData!['veiculo'] as String?) ?? 'Não especificado';
      }
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> carregarViagensHoje([DateTime? data]) async {
    if (motoristaId == null) return;
    try {
      loading = true;
      notifyListeners();

      final dataBusca = data ?? dataSelecionada;
      final inicioDia = DateTime(dataBusca.year, dataBusca.month, dataBusca.day);
      final fimDia = inicioDia.add(const Duration(days: 1));

      // Busca trajetos/viagens do motorista para a data selecionada
      final viagensSnap = await _db
          .collection('motoristas')
          .doc(motoristaId)
          .collection('viagens')
          .where('data', isGreaterThanOrEqualTo: Timestamp.fromDate(inicioDia))
          .where('data', isLessThan: Timestamp.fromDate(fimDia))
          .orderBy('data')
          .get();

      viagensHoje = viagensSnap.docs.map((doc) => doc.data()).toList();

      // Se houver viagens, busca lista de estudantes dessa viagem
      if (viagensHoje.isNotEmpty) {
        await carregarEstudantesViagem();
      }

      dataSelecionada = dataBusca;
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> carregarEstudantesViagem() async {
    if (motoristaId == null || viagensHoje.isEmpty) return;
    try {
      final viagemId = viagensHoje.first['id'] as String?;
      if (viagemId == null) return;

      // Busca estudantes/passageiros dessa viagem
      final estudantesSnap = await _db
          .collection('motoristas')
          .doc(motoristaId)
          .collection('viagens')
          .doc(viagemId)
          .collection('estudantes')
          .get();

      estudantes = estudantesSnap.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> carregarAvisos() async {
    if (motoristaId == null) return;
    try {
      loading = true;
      notifyListeners();

      final avisosSnap = await _db
          .collection('motoristas')
          .doc(motoristaId)
          .collection('avisos')
          .orderBy('timestamp', descending: true)
          .limit(5)
          .get();

      avisos = avisosSnap.docs
          .map((doc) => (doc.data()['texto'] as String?) ?? '')
          .toList();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void avancarData() {
    dataSelecionada = dataSelecionada.add(const Duration(days: 1));
    carregarViagensHoje();
  }

  void recuarData() {
    dataSelecionada = dataSelecionada.subtract(const Duration(days: 1));
    carregarViagensHoje();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
