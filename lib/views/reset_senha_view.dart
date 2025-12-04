import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unibus_intermunicipal/viewmodels/usuario_viewmodel.dart';

class ResetSenhaView extends StatelessWidget {
  const ResetSenhaView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();

    return AlertDialog(
      title: Text('Resetar Senha'),
      content: TextField(
        controller: emailController,
        decoration: InputDecoration(labelText: 'Email'),
      ),
      actions: [
        Consumer<UsuarioViewModel>(
          builder: (context, viewModel, child) {
            return TextButton(
              onPressed: () async {
                final emailResetado = await viewModel.resetarSenha(
                  emailController.text,
                );

                if (emailResetado) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(viewModel.msgTelaLogin.toString())),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(viewModel.msgTelaLogin.toString())),
                  );
                }
              },
              child: Text('Enviar'),
            );
          },
        ),
      ],
    );
  }
}
