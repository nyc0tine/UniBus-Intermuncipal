import 'package:flutter/material.dart';

class CadastroEstudanteView extends StatelessWidget {
  const CadastroEstudanteView({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Cadastro de Estudante"),
      content: const SizedBox(
        width: 300,
        height: 150,
        child: Center(
          child: Text(
            "Tela de cadastro de estudante\n(em desenvolvimento)",
            textAlign: TextAlign.center,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Fechar"),
        ),
      ],
    );
  }
}
