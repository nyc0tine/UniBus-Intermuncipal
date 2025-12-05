import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unibus_intermunicipal/viewmodels/usuario_viewmodel.dart';

class ResetSenhaView extends StatelessWidget {
  const ResetSenhaView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // TÍTULO
            const Text(
              "Resetar Senha",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4C63B6),
              ),
            ),

            const SizedBox(height: 20),

            // CAMPO DE EMAIL
            TextField(
              controller: emailController,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                labelText: "Email cadastrado",
                labelStyle: const TextStyle(color: Color(0xFF4C63B6)),
                filled: true,
                fillColor: const Color(0xFFE6E8ED),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFF4C63B6), width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFBFC3D9)),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // BOTÃO ENVIAR
            Consumer<UsuarioViewModel>(
              builder: (context, viewModel, child) {
                return SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      final emailResetado = await viewModel.resetarSenha(
                        emailController.text,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text(viewModel.msgTelaLogin.toString()),
                        ),
                      );

                      if (emailResetado) {
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4C63B6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 3,
                    ),
                    child: const Text(
                      "Enviar Link",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            // CANCELAR
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancelar",
                style: TextStyle(
                  color: Color(0xFF4C63B6),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
