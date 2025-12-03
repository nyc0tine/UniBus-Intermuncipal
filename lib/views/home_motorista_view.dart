import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/home_motorista_viewmodel.dart';

class HomeMotoristaView extends StatefulWidget {
  const HomeMotoristaView({super.key});

  @override
  State<HomeMotoristaView> createState() => _HomeMotoristaViewState();
}

class _HomeMotoristaViewState extends State<HomeMotoristaView> {
  int _selectedIndex = 1; // Home selecionada
  // Removed duplicate declaration of _selectedIndex

   @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeMotoristaViewModel>(
      create: (_) => HomeMotoristaViewModel()..init(),
      child: Consumer<HomeMotoristaViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            backgroundColor: const Color(0xFFE6E8ED),
            bottomNavigationBar: buildBottomNavigation(),
            body: Column(
              children: [
                buildHeader(vm),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        cardViagensHoje(vm),
                        const SizedBox(height: 20),
                        cardListaPassageiros(vm),
                        const SizedBox(height: 20),
                        cardAvisos(vm),
                        const SizedBox(height: 20),
                        cardOnibus(vm),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

// Header
  Widget buildHeader(HomeMotoristaViewModel vm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 25),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4F63D2), Color(0xFF3146A1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Column(
        children: [
          const Text(
            "Bom Dia, Motorista!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Georgia',
            ),
          ),
          const SizedBox(height: 20),

          // LINHA COM SETAS E DATA
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  vm.recuarData();
                },
              ),
              Text(
                vm.getDataFormatada(vm.dataSelecionada),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Georgia',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                onPressed: () {
                  vm.avancarData();
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  // card Viagens de Hoje
  Widget cardViagensHoje(HomeMotoristaViewModel vm) {
    final viagem = vm.viagensHoje.isNotEmpty ? vm.viagensHoje.first : null;
    final tipo = viagem != null ? (viagem['tipo'] as String?) ?? 'Viagem' : 'Sem viagem';
    final passageiros = viagem != null ? (viagem['passageirosCount'] as int?) ?? 0 : 0;

    return buildCard(
      icon: Icons.directions_bus,
      title: "Viagens de hoje",
      children: [
        Text(tipo, style: const TextStyle(fontSize: 17)),
        const SizedBox(height: 10),
        Text("$passageiros ALUNOS", style: const TextStyle(fontSize: 17)),
      ],
    );
  }

  // Card Lista de Passageiros 
  Widget cardListaPassageiros(HomeMotoristaViewModel vm) {
    final contagem = vm.estudantes.length;
    return buildCard(
      icon: Icons.list_alt,
      title: "Lista de passageiros",
      children: [
        Text("$contagem passageiros registrados",
            style: const TextStyle(fontSize: 17)),
      ],
    );
  }

  // Card Avisos 
  Widget cardAvisos(HomeMotoristaViewModel vm) {
    final primeiroAviso = vm.avisos.isNotEmpty ? vm.avisos.first : 'Sem avisos';
    return buildCard(
      title: "Avisos recentes",
      icon: Icons.notifications,
      children: [
        Row(
          children: [
            const Text("•  ", style: TextStyle(fontSize: 20)),
            Expanded(
              child: Text(
                primeiroAviso,
                style: const TextStyle(fontSize: 17),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Card Ônibus 
  Widget cardOnibus(HomeMotoristaViewModel vm) {
    return buildCard(
      icon: Icons.directions_bus,
      title: "Ônibus cadastrados",
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Selecionado:\n${vm.veiculo ?? 'Não especificado'}", 
              style: const TextStyle(fontSize: 17)),
            Text("Placa:\n${vm.motoristaContato.isNotEmpty ? vm.motoristaContato : 'N/A'}", 
              style: const TextStyle(fontSize: 17)),
          ],
        )
      ],
    );
  }

  // COMPONENTE REUTILIZÁVEL DE CARD 
  Widget buildCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(2, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 30),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia',
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ...children,
        ],
      ),
    );
  }

  // BOTTOM NAVIGATION 
  Widget buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF4F63D2),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          navButton(Icons.location_on, "Trajetos", false),
          navButton(Icons.home, "Home", true),
          navButton(Icons.people, "Estudantes", false),
        ],
      ),
    );
  }

  Widget navButton(IconData icon, String label, bool active) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 28,
            color: active ? const Color(0xFF4F63D2) : Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}