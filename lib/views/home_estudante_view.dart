import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/home_estudante_viewmodel.dart';
import '../widgets/custom_navbar_estudante.dart';

class HomeEstudanteView extends StatefulWidget {
  const HomeEstudanteView({super.key});

  @override
  State<HomeEstudanteView> createState() => _HomeEstudanteViewState();
}

class _HomeEstudanteViewState extends State<HomeEstudanteView> {

int _selectedIndex = 1;

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);

    if (index == 0) {
      Navigator.pushNamed(context, '/trajetosEstudante');
    } else if (index == 1) {
      // já está na home
    } else if (index == 2) {
      Navigator.pushNamed(context, '/enquete');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeEstudanteViewModel>(
      create: (_) => HomeEstudanteViewModel()..init(),
      child: Consumer<HomeEstudanteViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            backgroundColor: const Color(0xFFE7ECF2),

            body: SingleChildScrollView(
              child: Column(
                children: [
                  // HEADER
                  Container(
                    padding: const EdgeInsets.only(top: 60, bottom: 20),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF445CC4), Color(0xFF5468D4)],
                      ),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(60),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Bom Dia, ${vm.estudanteNome.isNotEmpty ? vm.estudanteNome : '...'}!",
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          vm.getDataAtual(),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                          size: 28,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // CARD - MEU TRANSPORTE DE HOJE
                  _buildCard(
                    icon: Icons.directions_bus,
                    title: "Meu Transporte de Hoje",
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vm.motoristaNome.isNotEmpty
                              ? vm.motoristaNome
                              : 'Sem motorista',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${vm.quantidadePassageiros} passageiros',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    button: ElevatedButton(
                      onPressed: vm.loading
                          ? null
                          : () async {
                              try {
                                await vm.marcarComoLivre();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Status atualizado!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } catch (_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Erro ao atualizar'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF445CC4),
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Em Desenvolvimento",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // CARD - SOLICITAR ALTERAÇÃO
                  _buildCard(
                    icon: Icons.send,
                    title: "Solicitar alteração",
                    content: const Text(
                      "Mudar status * Ida / Volta",
                      style: TextStyle(fontSize: 18),
                    ),
                    button: ElevatedButton(
                      onPressed: vm.loading
                          ? null
                          : () async {
                              try {
                                await vm.solicitarAlteracao(tipo: 'Ida');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Solicitação enviada'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } catch (_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Erro ao enviar'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF445CC4),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Em desenvolvimento",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // CARD - AVISOS
                  _buildCard(
                    title: "Avisos recentes",
                    content: Text(
                      vm.ultimoAviso.isNotEmpty
                          ? vm.ultimoAviso
                          : 'Nenhum aviso',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),

            // NAVBAR REUTILIZÁVEL
            bottomNavigationBar: CustomNavbar(
              currentIndex: _selectedIndex,
              onTap: _onNavTap,
            ),
          );
        },
      ),
    );
  }

  // CARD REUTILIZÁVEL
  Widget _buildCard({
    IconData? icon,
    required String title,
    required Widget content,
    Widget? button,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: Colors.black26, offset: Offset(2, 4), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) Icon(icon, size: 28),
              if (icon != null) const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          content,

          if (button != null) ...[
            const SizedBox(height: 20),
            button,
          ],
        ],
      ),
    );
  }
}
