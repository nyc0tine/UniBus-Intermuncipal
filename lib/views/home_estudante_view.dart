  import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/home_estudante_viewmodel.dart';

class HomeEstudanteView extends StatefulWidget {
  const HomeEstudanteView({super.key});
  
  @override
  State<HomeEstudanteView> createState() => _HomeEstudanteViewState();
}

class _HomeEstudanteViewState extends State<HomeEstudanteView> {
  int _selectedIndex = 1; // Home selecionada
  late HomeEstudanteViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = HomeEstudanteViewModel();
    vm.init();  // 🔥 Agora só inicializa UMA ve
  }


  // NAVEGAÇÃO INFERIOR
void _onItemTapped(int index) {
  // Navegação real
  if (index == 0) {
    Navigator.pushNamed(context, '/trajetos');
  } else if (index == 1) {
    Navigator.pushNamed(context, '/homeEstudante');
  } else if (index == 2) {
    Navigator.pushNamed(context, '/listaEstudantes');
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

            // Header
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 60, bottom: 20),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF445CC4),
                          Color(0xFF5468D4),
                        ],
                      ),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(60),
                      ),
                    ),
                    child: Column(
                      children: [
                        // TÍTULO
                        Text(
                          "Bom Dia, ${vm.estudante?.nome ?? '...'}!",
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // data
                        Text(
                          vm.getDataAtual(),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Icon(Icons.notifications_none, color: Colors.white, size: 28),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Card Meu Transport de Hoje 
                  _buildCard(
                    icon: Icons.directions_bus,
                    title: "Meu Transporte de Hoje",
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(vm.motorista?.nome ?? 'Sem motorista', style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 5),
                        Text('${vm.quantidadePassageiros} passageiros', style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                    button: ElevatedButton(
                      onPressed: vm.loading
                          ? null
                          : () async {
                              try {
                                await vm.marcarComoLivre();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Status atualizado!'), backgroundColor: Colors.green),
                                );
                              } catch (_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Erro ao atualizar'), backgroundColor: Colors.red),
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
                        "Estou Livre!",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Card Solicitar alteração
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
                                  const SnackBar(content: Text('Solicitação enviada'), backgroundColor: Colors.green),
                                );
                              } catch (_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Erro ao enviar'), backgroundColor: Colors.red),
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
                        "Solicitar",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Card Avisos 
                  _buildCard(
                    title: "Avisos recentes",
                    content: Text(
                      vm.ultimoAviso.isNotEmpty ? vm.ultimoAviso : 'Nenhum aviso',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),

            // Barra de Navegação Inferior
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: const Color(0xFF445CC4),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white70,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.place),
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
          );
        },
      ),
    );
  }

  // Widget do Card Reutilizável 
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
          BoxShadow(
            color: Colors.black26,
            offset: Offset(2, 4),
            blurRadius: 8,
          )
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
