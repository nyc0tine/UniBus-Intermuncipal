import 'package:flutter/material.dart';

class CadastroMotoristaView extends StatelessWidget {
  const CadastroMotoristaView({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Cadastro de Motorista"),
      content: const SizedBox(
        width: 300,
        height: 150,
        child: Center(
          child: Text(
            "Tela de cadastro de motorista\n(em desenvolvimento)",
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
