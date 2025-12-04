import 'package:flutter/material.dart';

class TrajetosViewModel extends ChangeNotifier {
  DateTime dataSelecionada = DateTime.now();

  final List<Map<String, dynamic>> instituicoes = [
    {'nome': 'UNIESP', 'alunos': 46},
    {'nome': 'UNINASSAU', 'alunos': 6},
    {'nome': 'UFPB', 'alunos': 18},
    {'nome': 'FPB', 'alunos': 22},
  ];

  // Índice da última bolinha marcada (progresso). -1 = nada marcado
  int ultimaMarcada = -1;

  void avancarData() {
    dataSelecionada = dataSelecionada.add(const Duration(days: 1));
    notifyListeners();
  }

  void recuarData() {
    dataSelecionada = dataSelecionada.subtract(const Duration(days: 1));
    notifyListeners();
  }

  String getDataFormatada(DateTime d) {
    // Formata data como 'Segunda-feira , 1 de dezembro de 2025'
    final weekday = _weekdayPt(d.weekday);
    final month = _monthPt(d.month);
    return '$weekday , ${d.day} de $month de ${d.year}';
  }

  String _weekdayPt(int w) {
    switch (w) {
      case DateTime.monday:
        return 'Segunda-feira';
      case DateTime.tuesday:
        return 'Terça-feira';
      case DateTime.wednesday:
        return 'Quarta-feira';
      case DateTime.thursday:
        return 'Quinta-feira';
      case DateTime.friday:
        return 'Sexta-feira';
      case DateTime.saturday:
        return 'Sábado';
      case DateTime.sunday:
      default:
        return 'Domingo';
    }
  }

  String _monthPt(int m) {
    switch (m) {
      case 1:
        return 'janeiro';
      case 2:
        return 'fevereiro';
      case 3:
        return 'março';
      case 4:
        return 'abril';
      case 5:
        return 'maio';
      case 6:
        return 'junho';
      case 7:
        return 'julho';
      case 8:
        return 'agosto';
      case 9:
        return 'setembro';
      case 10:
        return 'outubro';
      case 11:
        return 'novembro';
      case 12:
      default:
        return 'dezembro';
    }
  }

  /// Tenta alternar a bolinha no índice [index].
  /// Regras:
  /// - Só é permitido marcar o próximo: index == ultimaMarcada + 1
  /// - Só é permitido desmarcar o último marcado: index == ultimaMarcada
  /// Retorna `null` se operação bem-sucedida, ou mensagem de erro caso contrário.
  String? toggleIndice(int index) {
    if (index < 0 || index >= instituicoes.length) {
      return 'Índice inválido';
    }

    if (index == ultimaMarcada + 1) {
      // marcar próximo
      ultimaMarcada = index;
      notifyListeners();
      return null;
    }

    if (index == ultimaMarcada) {
      // desmarcar último
      ultimaMarcada = ultimaMarcada - 1;
      notifyListeners();
      return null;
    }

    // qualquer outra ação é inválida (pular ordem ou desmarcar abaixo do topo)
    if (index > ultimaMarcada + 1) {
      return 'Marque as paradas anteriores primeiro';
    }
    return 'Desmarque as paradas mais recentes primeiro';
  }

  bool isMarcado(int index) => index <= ultimaMarcada;

  bool canFinalizar() => ultimaMarcada == instituicoes.length - 1;

  void finalizarTrajeto() {
    // Aqui você pode implementar lógica real (ex: enviar para backend)
    // Por enquanto apenas notifica para permitir feedback na UI
    notifyListeners();
  }
}
