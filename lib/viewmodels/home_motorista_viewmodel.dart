import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeMotoristaViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool loading = false;
  String? error;

  String? motoristaId;
  Map<String, dynamic>? motoristaData;

  String motoristaNome = '';
  String motoristaContato = '';
  String motoristaPlaca = ''; // ← Atualizável pela Home
  String? veiculo;

  DateTime dataSelecionada = DateTime.now();

  List<Map<String, dynamic>> viagensHoje = [];
  List<Map<String, dynamic>> estudantes = [];
  List<String> avisos = [];

  // ===============================================================
  // DATA FORMATADA
  // ===============================================================
  String getDataFormatada([DateTime? data]) {
    final d = data ?? DateTime.now();
    final dia = d.day.toString().padLeft(2, '0');
    final mes = d.month.toString().padLeft(2, '0');
    final ano = d.year;
    return '$dia/$mes/$ano';
  }

  // ===============================================================
  // INICIALIZAÇÃO
  // ===============================================================
  Future<void> init({String? motoristaIdParam}) async {
    loading = true;
    notifyListeners();

    motoristaId = motoristaIdParam ?? _auth.currentUser?.uid;

    if (motoristaId == null) {
      error = "Usuário não autenticado";
      loading = false;
      notifyListeners();
      return;
    }

    await _carregarNomeLocal();
    await carregarDadosMotorista();
    await carregarViagensHoje();
    await carregarAvisos();

    loading = false;
    notifyListeners();
  }

  // ===============================================================
  // CARREGA NOME DO LOCAL STORAGE
  // ===============================================================
  Future<void> _carregarNomeLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      motoristaNome = prefs.getString('nomeUsuario') ?? '';
      notifyListeners();
    } catch (_) {}
  }

  // ===============================================================
  // CARREGAR DADOS DO MOTORISTA
  // ===============================================================
  Future<void> carregarDadosMotorista() async {
    if (motoristaId == null) return;

    try {
      loading = true;
      notifyListeners();

      final doc = await _db.collection('motoristas').doc(motoristaId).get();

      if (doc.exists) {
        motoristaData = doc.data() as Map<String, dynamic>?;

        motoristaNome = motoristaData?['nome'] ?? '';
        motoristaContato = motoristaData?['contato'] ?? '';
        motoristaPlaca = motoristaData?['placa'] ?? '';
        veiculo = motoristaData?['veiculo'] ?? "Não especificado";
      }
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // ===============================================================
  // ALTERAÇÃO PRINCIPAL — ATUALIZA PLACA NA HOME
  // ===============================================================
  void setOnibusSelecionado(String placa) {
    motoristaPlaca = placa;
    notifyListeners();
  }

  // ===============================================================
  // CARREGAR VIAGENS DO DIA
  // ===============================================================
  Future<void> carregarViagensHoje([DateTime? data]) async {
    if (motoristaId == null) return;

    try {
      loading = true;
      notifyListeners();

      final dataBusca = data ?? dataSelecionada;

      final inicioDia =
          DateTime(dataBusca.year, dataBusca.month, dataBusca.day);
      final fimDia = inicioDia.add(const Duration(days: 1));

      final viagensSnap = await _db
          .collection('motoristas')
          .doc(motoristaId)
          .collection('viagens')
          .where('data', isGreaterThanOrEqualTo: Timestamp.fromDate(inicioDia))
          .where('data', isLessThan: Timestamp.fromDate(fimDia))
          .orderBy('data')
          .get();

      viagensHoje = viagensSnap.docs.map((doc) {
        final dados = doc.data();
        return {
          ...dados,
          'id': doc.id,
        };
      }).toList();

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

  // ===============================================================
  // CARREGAR LISTA DE ESTUDANTES DA PRIMEIRA VIAGEM
  // ===============================================================
  Future<void> carregarEstudantesViagem() async {
    if (motoristaId == null || viagensHoje.isEmpty) return;

    try {
      final viagemId = viagensHoje.first['id'];
      if (viagemId == null) return;

      final estudantesSnap = await _db
          .collection('motoristas')
          .doc(motoristaId)
          .collection('viagens')
          .doc(viagemId)
          .collection('estudantes')
          .get();

      estudantes = estudantesSnap.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // ===============================================================
  // CARREGAR AVISOS
  // ===============================================================
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
          .map((doc) => (doc.data()['texto'] ?? '').toString())
          .toList();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // ===============================================================
  // ALTERAÇÕES DE DATA
  // ===============================================================
  void avancarData() {
    dataSelecionada = dataSelecionada.add(const Duration(days: 1));
    carregarViagensHoje();
  }

  void recuarData() {
    dataSelecionada = dataSelecionada.subtract(const Duration(days: 1));
    carregarViagensHoje();
  }
}
