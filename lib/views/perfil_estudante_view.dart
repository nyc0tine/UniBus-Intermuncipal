import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/perfil_estudante_viewmodel.dart';

class PerfilEstudanteView extends StatelessWidget {
  final String id;

  const PerfilEstudanteView({required this.id});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PerfilEstudanteViewModel()..carregarPerfil(id),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Perfil do Estudante"),
        ),
        body: Consumer<PerfilEstudanteViewModel>(
          builder: (context, vm, _) {
            if (vm.estudante == null) {
              return Center(child: CircularProgressIndicator());
            }

            final estudante = vm.estudante!;

            return Stack(
              children: [
                // Marca d'água
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.08,
                    child: Center(
                      child: Text(
                        "UNIBUS\nintermunicipal",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),

                // Conteúdo principal
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        child: Text(
                          estudante.nome[0],
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        estudante.nome,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        estudante.instituicao,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
