import 'package:flutter/material.dart';
import '../models/lista_estudante_model.dart';

class ListaEstudanteViewModel extends ChangeNotifier {
  final List<String> instituicoes = ["Todos", "Uninassau", "UFPB", "UNIESP"];

  final List<Estudante> _todosEstudantes = [
    Estudante(id: "1", nome: "Ana Beatriz", instituicao: "Uninassau"),
    Estudante(id: "2", nome: "João Pedro", instituicao: "UFPB"),
    Estudante(id: "3", nome: "Maria Eduarda", instituicao: "UNIESP"),
    Estudante(id: "4", nome: "Lucas Henriques", instituicao: "UFPB"),
    Estudante(id: "5", nome: "Carlos Silva", instituicao: "Uninassau"),
    Estudante(id: "6", nome: "Juliana Costa", instituicao: "UNIESP"),
    Estudante(id: "7", nome: "Felipe Oliveira", instituicao: "UFPB"),
    Estudante(id: "8", nome: "Amanda Souza", instituicao: "Uninassau"),
  ];

  String _filtroAtual = "Todos";
  String get filtroAtual => _filtroAtual;

  List<Estudante> get estudantesFiltrados {
    if (_filtroAtual == "Todos") return _todosEstudantes;
    return _todosEstudantes
        .where((e) => e.instituicao == _filtroAtual)
        .toList();
  }

  void mudarFiltro(String novoFiltro) {
    _filtroAtual = novoFiltro;
    notifyListeners();
  }
}
