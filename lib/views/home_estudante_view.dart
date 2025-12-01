import 'package:flutter/material.dart';

import '../viewmodels/home_estudante_viewmodel.dart';

class HomeEstudanteView extends StatefulWidget {
  const HomeEstudanteView({super.key});

  @override
  State<HomeEstudanteView> createState() => _HomeEstudanteViewState();
}

class _HomeEstudanteViewState extends State<HomeEstudanteView> {
  final HomeEstudanteViewModel _viewModel = HomeEstudanteViewModel();
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe9edf5),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xff4f63c0),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            label: "Trajetos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Estudantes",
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _cardMeuTransporteHoje(),
                    const SizedBox(height: 20),
                    _cardSolicitarAlteracao(),
                    const SizedBox(height: 20),
                    _cardAvisosRecentes(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Cabeçalho azul com saudação
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xff4f63c0),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(60),
          bottomRight: Radius.circular(60),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Bom Dia, ${_viewModel.getNomeEstudante()}!",
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Navegar para notificações
                },
                child: const Icon(Icons.notifications_none,
                    color: Colors.white, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            _viewModel.getDataAtual(),
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  /// Card "Meu transporte de hoje"
  Widget _cardMeuTransporteHoje() {
    return _baseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.directions_bus, size: 28),
              SizedBox(width: 10),
              Text(
                "Meu Transporte de Hoje",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            _viewModel.getNomeMotorista(),
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 8),
          Text(
            "Passageiros: ${_viewModel.getQuantidadePassageiros()}",
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 25),

          /// Botão "Estou livre!"
          Center(
            child: GestureDetector(
              onTap: () {
                _viewModel.marcarComoLivre();
                _mostrarMensagem('Status atualizado!', sucesso: true);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xff4f63c0),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
                child: const Text(
                  "Estou Livre!",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Card "Solicitar alteração"
  Widget _cardSolicitarAlteracao() {
    return GestureDetector(
      onTap: () {
        // TODO: Navegar para tela de alteração
      },
      child: _baseCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Row(
              children: [
                Icon(Icons.send, size: 28),
                SizedBox(width: 10),
                Text(
                  "Solicitar alteração",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Mudar status * Ida / Volta",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  /// Card "Avisos Recentes"
  Widget _cardAvisosRecentes() {
    return _baseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Avisos recentes",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _viewModel.getUltimoAviso(),
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  /// Função base para os cards
  Widget _baseCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xffe2e3e5),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(3, 6),
            blurRadius: 10,
          ),
        ],
      ),
      child: child,
    );
  }

  /// Método para mostrar mensagens ao usuário
  void _mostrarMensagem(String mensagem, {bool sucesso = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: sucesso ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
