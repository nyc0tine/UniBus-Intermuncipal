import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/trajetos_viewmodel.dart';
import '../widgets/custom_navbar_motorista.dart';

class TrajetosMotoristaView extends StatefulWidget {
  const TrajetosMotoristaView({super.key});

  @override
  State<TrajetosMotoristaView> createState() => _TrajetosMotoristaViewState();
}

class _TrajetosMotoristaViewState extends State<TrajetosMotoristaView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------------
  // 🟦 Função do navbar
  // ------------------------------------------------------------------
  void _onNavTapped(int index) {
    switch (index) {
      case 0:
        // já está na página Trajetos
        break;
      case 1:
        Navigator.pushNamed(context, "/homeMotorista");
        break;
      case 2:
        Navigator.pushNamed(context, "/listaEstudantes");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TrajetosViewModel(),
      child: Consumer<TrajetosViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            backgroundColor: const Color(0xFFE6E8ED),

            body: Column(
              children: [
                _buildAppBarPadrao(vm),
                const SizedBox(height: 10),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        ..._buildInstituicoes(vm),
                        const SizedBox(height: 30),
                        _buildBotaoFinalizar(vm),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ---------------------------------------------------------
            // NAVBAR PADRÃO
            // ---------------------------------------------------------
            bottomNavigationBar: CustomNavbar(
              currentIndex: 0,  // trajeto é index 0
              onTap: _onNavTapped,
            ),
          );
        },
      ),
    );
  }

  // -----------------------------------------------------------
  // APPBAR
  // -----------------------------------------------------------
  Widget _buildAppBarPadrao(TrajetosViewModel vm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 40),
      decoration: const BoxDecoration(
        color: Color(0xFF4C63B6),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 20,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.white, size: 26),
            ),
          ),
          const Center(
            child: Text(
              "TRAJETOS DO DIA",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------
  // LISTA DE INSTITUIÇÕES
  // -----------------------------------------------------------
  List<Widget> _buildInstituicoes(TrajetosViewModel vm) {
    final List<Widget> items = [];

    for (var i = 0; i < vm.instituicoes.length; i++) {
      final inst = vm.instituicoes[i];

      items.add(
        Row(
          children: [
            GestureDetector(
              onTap: () {
                final msg = vm.toggleIndice(i);
                if (msg != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(msg)),
                  );
                }
              },
              child: Container(
                width: 34,
                height: 34,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: vm.isMarcado(i)
                      ? const Color(0xFF7EE69A)
                      : Colors.white,
                  border: Border.all(color: const Color(0xFF7EE69A), width: 2),
                ),
                child: vm.isMarcado(i)
                    ? const Icon(Icons.check, color: Colors.white)
                    : null,
              ),
            ),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFF7B84D6),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Text(
                  '${inst['nome'].toString().toUpperCase()} - ${inst['alunos']} ALUNOS',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

      if (i != vm.instituicoes.length - 1) {
        final animate = vm.ultimaMarcada == i;

        items.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: animate
                  ? FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _controller,
                        curve: Curves.easeInOut,
                      ),
                      child: const Icon(
                        Icons.arrow_downward,
                        size: 28,
                        color: Color(0xFF3146A1),
                      ),
                    )
                  : const Icon(
                      Icons.arrow_downward,
                      size: 28,
                      color: Color(0xFF3146A1),
                    ),
            ),
          ),
        );
      }
    }

    return items;
  }

  // -----------------------------------------------------------
  // BOTÃO FINALIZAR
  // -----------------------------------------------------------
  Widget _buildBotaoFinalizar(TrajetosViewModel vm) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: vm.canFinalizar()
            ? () {
                vm.finalizarTrajeto();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Trajeto finalizado")),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              vm.canFinalizar() ? const Color(0xFF3948A3) : const Color(0xFFD9D9D9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Text(
          "FINALIZAR TRAJETO",
          style: TextStyle(
            color: vm.canFinalizar() ? Colors.white : const Color(0xFF666666),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
