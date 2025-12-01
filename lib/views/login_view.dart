import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/login_viewmodel.dart';
import 'selecao_perfil_view.dart';
import 'home_estudante_view.dart';
import 'home_motorista_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController senhaController = TextEditingController();

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 30,
          children: [
            ClipOval(
              child: Image.asset(
                'assets/unibus_logo.png',
                height: 110,
                width: 110,
                fit: BoxFit.cover,
              ),
            ),

            // ------------------- EMAIL -------------------
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),

            // ------------------- SENHA -------------------
            TextField(
              controller: senhaController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),

            // ------------------- TIPO DE USUÁRIO -------------------
            Consumer<LoginViewModel>(
              builder: (context, vm, _) {
                return DropdownButtonFormField<String>(
                  value: vm.tipoUsuario,
                  decoration: const InputDecoration(labelText: "Tipo de usuário"),
                  items: const [
                    DropdownMenuItem(value: "estudante", child: Text("Estudante")),
                    DropdownMenuItem(value: "motorista", child: Text("Motorista")),
                  ],
                  onChanged: (value) => vm.setTipoUsuario(value!),
                );
              },
            ),

            const SizedBox(height: 20),

            // ------------------- BOTÃO DE LOGIN -------------------
            Consumer<LoginViewModel>(
              builder: (context, viewModel, child) {
                return ElevatedButton(
                  onPressed: () async {
                    bool result = await viewModel.login(
                      emailController.text,
                      senhaController.text,
                    );

                    if (result) {
                      if (viewModel.tipoUsuario == "estudante") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeEstudanteView()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeMotoristaView()),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(viewModel.mensagemErro ?? "Erro ao fazer login"),
                        ),
                      );
                    }
                  },
                  child: const Text('Login'),
                );
              },
            ),

            // ------------------- CADASTRAR -------------------
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SelecaoPerfilView()),
                );
              },
              child: const Text(
                'Não tem uma conta? Cadastre-se',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
