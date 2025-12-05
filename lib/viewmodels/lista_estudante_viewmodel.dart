import 'package:flutter/material.dart';
import '../models/lista_estudante_model.dart';

class ListaEstudanteViewModel extends ChangeNotifier {
  // Filtros das instituições
  final List<String> instituicoes = ["Todos", "Uninassau", "UFPB", "UNIESP"];

  // Novo filtro para o status (ida/volta)
  final List<String> statusList = ["Todos", "Ida", "Volta", "Ida e Volta"];

  // Lista completa de estudantes
  final List<Estudante> _todosEstudantes = [
    Estudante(id: "1", nome: "Ana Beatriz", instituicao: "Uninassau", status: "Ida e Volta"),
    Estudante(id: "2", nome: "João Pedro", instituicao: "UFPB", status: "Volta"),
    Estudante(id: "3", nome: "Maria Eduarda", instituicao: "UNIESP", status: "Ida e Volta"),
    Estudante(id: "4", nome: "Lucas Henriques", instituicao: "UFPB", status: "Ida e Volta"),
    Estudante(id: "5", nome: "Carlos Silva", instituicao: "Uninassau", status: "Ida e Volta"),
    Estudante(id: "6", nome: "Juliana Costa", instituicao: "UNIESP", status: "Volta"),
    Estudante(id: "7", nome: "Felipe Oliveira", instituicao: "UFPB", status: "Ida"),
    Estudante(id: "8", nome: "Amanda Souza", instituicao: "Uninassau", status: "Ida e Volta"),
  ];

  // Filtros atuais
  String _filtroInstituicao = "Todos";
  String _filtroStatus = "Todos";

  // Getters dos filtros
  String get filtroInstituicao => _filtroInstituicao;
  String get filtroStatus => _filtroStatus;

  // Retorna a lista filtrada conforme instituição + ida/volta
  List<Estudante> get estudantesFiltrados {
    return _todosEstudantes.where((e) {
      final filtroInst = _filtroInstituicao == "Todos" || e.instituicao == _filtroInstituicao;
      final filtroStat = _filtroStatus == "Todos" || e.status == _filtroStatus;
      return filtroInst && filtroStat;
    }).toList();
  }

  // Altera filtro por instituição
  void mudarFiltroInstituicao(String novo) {
    _filtroInstituicao = novo;
    notifyListeners();
  }

  // Altera filtro por status (ida/volta)
  void mudarFiltroStatus(String novo) {
    _filtroStatus = novo;
    notifyListeners();
  }
}
