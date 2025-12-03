import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/lista_estudante_viewmodel.dart';
import 'perfil_estudante_view.dart';

class ListaEstudanteView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ListaEstudanteViewModel(),
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Estudantes"),
            bottom: TabBar(
              onTap: (index) {
                final vm = context.read<ListaEstudanteViewModel>();
                vm.mudarFiltro(vm.instituicoes[index]);
              },
              tabs: const [
                Tab(text: "Todos"),
                Tab(text: "Uninassau"),
                Tab(text: "UFPB"),
                Tab(text: "UNIESP"),
              ],
            ),
          ),
          body: Consumer<ListaEstudanteViewModel>(
            builder: (context, vm, _) {
              return ListView.builder(
                itemCount: vm.estudantesFiltrados.length,
                itemBuilder: (context, index) {
                  final estudante = vm.estudantesFiltrados[index];

                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(estudante.nome[0]),
                    ),
                    title: Text(estudante.nome),
                    subtitle: Text(estudante.instituicao),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PerfilEstudanteView(id: estudante.id),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
