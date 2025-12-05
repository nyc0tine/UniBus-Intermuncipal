import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/home_motorista_viewmodel.dart';
import "../views/onibus_cadastrados_view.dart";
import '../widgets/custom_navbar_motorista.dart';

class HomeMotoristaView extends StatefulWidget {
  const HomeMotoristaView({super.key});

  @override
  State<HomeMotoristaView> createState() => _HomeMotoristaViewState();
}

class _HomeMotoristaViewState extends State<HomeMotoristaView> {
  int _selectedIndex = 1;

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);

    if (index == 0) {
      Navigator.pushNamed(context, '/trajetosMotorista');
    } else if (index == 1) {
      // já está na home
    } else if (index == 2) {
      Navigator.pushNamed(context, '/listaEstudantes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeMotoristaViewModel>(
      create: (_) => HomeMotoristaViewModel()..init(),
      child: Consumer<HomeMotoristaViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            backgroundColor: const Color(0xFFE7ECF2),

            body: SingleChildScrollView(
              child: Column(
                children: [
                  // HEADER
                  Container(
                    padding: const EdgeInsets.only(top: 60, bottom: 25),
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
                          "Bom Dia, ${vm.motoristaNome.isNotEmpty ? vm.motoristaNome : 'Motorista'}!",
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          vm.getDataFormatada(vm.dataSelecionada),
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

                  // CARD VIAGENS DE HOJE
                  _buildCard(
                    icon: Icons.directions_bus,
                    title: "Viagens de hoje",
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vm.viagensHoje.isNotEmpty
                              ? (vm.viagensHoje.first["tipo"] ?? "Viagem")
                              : "Sem viagem",
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          vm.viagensHoje.isNotEmpty
                              ? "${vm.viagensHoje.first['passageirosCount']} passageiros"
                              : "0 passageiros",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // CARD PASSAGEIROS
                  _buildCard(
                    icon: Icons.people,
                    title: "Lista de passageiros",
                    content: Text(
                      "${vm.estudantes.length} passageiros registrados",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // CARD AVISOS
                  _buildCard(
                    icon: Icons.notifications,
                    title: "Avisos recentes",
                    content: Text(
                      vm.avisos.isNotEmpty ? vm.avisos.first : "Nenhum aviso",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),

                  const SizedBox(height: 20),

                                    // CARD ÔNIBUS
                  _buildCard(
                    icon: Icons.directions_bus_filled_rounded,
                    title: "Ônibus cadastrados",
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Placa selecionada:",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          vm.motoristaPlaca.isNotEmpty
                              ? vm.motoristaPlaca
                              : "Nenhuma selecionada",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    button: ElevatedButton(
                      onPressed: () async {
                        final placaSelecionada = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const OnibusCadastradosView(),
                          ),
                        );

                        if (placaSelecionada != null) {
                          vm.setOnibusSelecionado(placaSelecionada);
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
                        "Gerenciar Ônibus",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),

            // 🔥 CUSTOM NAVBAR MOTORISTA
            bottomNavigationBar: CustomNavbar(
              currentIndex: _selectedIndex,
              onTap: _onNavTap,
            ),
          );
        },
      ),
    );
  }

  // --- CARD UNIVERSAL ---
  Widget _buildCard({
    IconData? icon,
    required String title,
    required Widget content,
    Widget? button,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Row(
              children: [
                Icon(icon, size: 30, color: const Color(0xFF445CC4)),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          else
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

          const SizedBox(height: 15),

          content,

          if (button != null) ...[
            const SizedBox(height: 15),
            button,
          ],
        ],
      ),
    );
  }
}
