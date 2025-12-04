import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/trajetos_viewmodel.dart';

class TrajetosView extends StatefulWidget {
  const TrajetosView({super.key});

  @override
  State<TrajetosView> createState() => _TrajetosViewState();
}

class _TrajetosViewState extends State<TrajetosView>
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
                _buildHeader(vm),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        ..._buildInstituicoes(vm),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: vm.canFinalizar()
                                ? () {
                                    vm.finalizarTrajeto();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Trajeto finalizado'),
                                      ),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: vm.canFinalizar()
                                  ? const Color(0xFF3948A3)
                                  : const Color(0xFFD9D9D9),
                            ),
                            child: Text(
                              'FINALIZAR TRAJETO',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: vm.canFinalizar()
                                    ? Colors.white
                                    : const Color(0xFF666666),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: _buildBottomNavigation(context),
          );
        },
      ),
    );
  }

  Widget _buildHeader(TrajetosViewModel vm) {
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
            'Bom Dia, Motorista!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Georgia',
            ),
          ),
          const SizedBox(height: 20),
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
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                onPressed: () {
                  vm.avancarData();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildInstituicoes(TrajetosViewModel vm) {
    final List<Widget> items = [];
    for (var i = 0; i < vm.instituicoes.length; i++) {
      final inst = vm.instituicoes[i];

      items.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // indicador circular (clicável)
            GestureDetector(
              onTap: () {
                final msg = vm.toggleIndice(i);
                if (msg != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(msg)));
                }
              },
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: vm.isMarcado(i)
                      ? const Color(0xFF7EE69A)
                      : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF7EE69A), width: 2),
                ),
                child: vm.isMarcado(i)
                    ? const Icon(Icons.check, color: Colors.white)
                    : const SizedBox.shrink(),
              ),
            ),

            // pill
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 18,
                ),
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

      // se não for o último, adicionar seta com animação
      if (i != vm.instituicoes.length - 1) {
        final shouldAnimate = vm.ultimaMarcada == i;
        items.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: shouldAnimate
                  ? FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _controller,
                        curve: Curves.easeInOut,
                      ),
                      child: const Icon(
                        Icons.arrow_downward,
                        color: Color(0xFF3146A1),
                        size: 28,
                      ),
                    )
                  : const Icon(
                      Icons.arrow_downward,
                      color: Color(0xFF3146A1),
                      size: 28,
                    ),
            ),
          ),
        );
      }
    }
    return items;
  }

  Widget _buildBottomNavigation(BuildContext context) {
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
          _navButton(Icons.location_on, 'Trajetos', true, () {
            // já está na tela trajetos
          }),
          _navButton(Icons.home, 'Home', false, () {
            Navigator.pushNamed(context, '/homeEstudante');
          }),
          _navButton(Icons.people, 'Estudantes', false, () {
            Navigator.pushNamed(context, '/listaEstudantes');
          }),
        ],
      ),
    );
  }

  Widget _navButton(
    IconData icon,
    String label,
    bool active,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
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
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
