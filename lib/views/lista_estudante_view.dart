import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/lista_estudante_viewmodel.dart';

class ListaEstudanteView extends StatelessWidget {
  const ListaEstudanteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Estudantes"),
        centerTitle: true,
      ),

      body: Consumer<ListaEstudanteViewModel>(
        builder: (context, vm, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ---------- FILTRO INSTITUIÇÃO ----------
              const Padding(
                padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
                child: Text("Instituição", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: vm.instituicoes.map((inst) {
                    final selected = vm.filtroInstituicao == inst;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(inst),
                        selected: selected,
                        selectedColor: Colors.blue.shade600,
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : Colors.black,
                        ),
                        onSelected: (_) => vm.mudarFiltroInstituicao(inst),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // ---------- FILTRO IDA / VOLTA ----------
              const Padding(
                padding: EdgeInsets.only(left: 16, top: 20, bottom: 8),
                child: Text("Status", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: vm.statusList.map((status) {
                    final selected = vm.filtroStatus == status;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(status),
                        selected: selected,
                        selectedColor: Colors.green.shade600,
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : Colors.black,
                        ),
                        onSelected: (_) => vm.mudarFiltroStatus(status),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 10),

              // ---------- LISTA DE ESTUDANTES ----------
              Expanded(
                child: ListView.builder(
                  itemCount: vm.estudantesFiltrados.length,
                  itemBuilder: (context, index) {
                    final est = vm.estudantesFiltrados[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(est.nome[0]),
                      ),
                      title: Text(est.nome),
                      subtitle: Text("${est.instituicao} • ${est.status}"),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
