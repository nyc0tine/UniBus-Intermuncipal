// Pop-up de escolha do tipo de perfil: estucante ou motorista
import 'package:flutter/material.dart';

import 'cadastro_motorista_view.dart';

class SelecaoPerfilView extends StatelessWidget {
  const SelecaoPerfilView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Selecione seu perfil",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 25,
          children: [
            const Text(
              "Como você deseja se cadastrar?",
              style: TextStyle(fontSize: 18),
            ),

            // ---------------- BOTÃO ESTUDANTE ----------------
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/listaEstudantes');
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(240, 48)),
              child: const Text("Sou Estudante"),
            ),

            // ---------------- BOTÃO MOTORISTA ----------------
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const CadastroMotoristaView(),
                );
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(240, 48)),
              child: const Text("Sou Motorista"),
            ),
          ],
        ),
      ),
    );
  }
}
