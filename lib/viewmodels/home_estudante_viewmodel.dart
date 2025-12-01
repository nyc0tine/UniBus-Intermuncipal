
class HomeEstudanteViewModel {
  // Dados temporários do estudante (depois será integrado com Firebase)
  String _nomeEstudante = 'Maria';
  String _nomeMotorista = 'Viagem com Carlinhos';
  int _quantidadePassageiros = 47;
  String _ultimoAviso = '• Motorista aprovou sua solicitação.';

  // Retorna o nome do estudante
  String getNomeEstudante() => _nomeEstudante;

  // Retorna a data atual formatada
String getDataAtual() {
  final agora = DateTime.now();
  final dia = agora.day.toString().padLeft(2, '0');
  final mes = agora.month.toString().padLeft(2, '0');
  final ano = agora.year;

  return '$dia/$mes/$ano';
}

  // Retorna o nome do motorista
  String getNomeMotorista() => _nomeMotorista;

  // Retorna a quantidade de passageiros
  int getQuantidadePassageiros() => _quantidadePassageiros;

  // Retorna o último aviso
  String getUltimoAviso() => _ultimoAviso;

  // Marca o estudante como livre (disponível para novo trajeto)
  void marcarComoLivre() {
    print('Estudante marcado como livre');
    // TODO: Integrar com Firebase para atualizar status
  }

  // Solicita uma alteração no trajeto
  void solicitarAlteracao({required String tipo}) {
    print('Solicitação de alteração: $tipo');
    // TODO: Integrar com Firebase para enviar solicitação
  }

  // Carrega dados do estudante do Firestore
  Future<void> carregarDadosEstudante(String estudanteId) async {
    try {
      // TODO: Buscar dados do Firestore
      print('Carregando dados do estudante: $estudanteId');
    } catch (e) {
      print('Erro ao carregar dados: $e');
    }
  }

  // Carrega trajeto de hoje
  Future<void> carregarTrajetoHoje() async {
    try {
      // TODO: Buscar trajeto de hoje do Firestore
      print('Carregando trajeto de hoje');
    } catch (e) {
      print('Erro ao carregar trajeto: $e');
    }
  }
}
