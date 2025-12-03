import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';
import 'selecao_perfil_view.dart';
import 'home_estudante_view.dart';
import 'home_motorista_view.dart';
import 'reset_senha_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController senhaController = TextEditingController();

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('LogoBus.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: senhaController,
                  decoration: const InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                ),

                const SizedBox(height: 12),

                Consumer<LoginViewModel>(
                  builder: (context, vm, _) {
                    return DropdownButtonFormField<String>(
                      value: vm.tipoUsuario,
                      decoration: const InputDecoration(labelText: 'Tipo de usuário'),
                      items: const [
                        DropdownMenuItem(value: 'estudante', child: Text('Estudante')),
                        DropdownMenuItem(value: 'motorista', child: Text('Motorista')),
                      ],
                      onChanged: (value) => vm.setTipoUsuario(value ?? 'estudante'),
                    );
                  },
                ),

                const SizedBox(height: 20),

                Consumer<LoginViewModel>(
                  builder: (context, viewModel, child) {
                    return ElevatedButton(
                      onPressed: () async {
                        final result = await viewModel.login(
                          emailController.text.trim(),
                          senhaController.text,
                        );

                        if (result) {
                          if (viewModel.tipoUsuario == 'estudante') {
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
                              content: Text(viewModel.mensagemErro ?? 'Erro ao fazer login'),
                            ),
                          );
                        }
                      },
                      child: const Text('Login'),
                    );
                  },
                ),

                const SizedBox(height: 12),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SelecaoPerfilView()),
                    );
                  },
                  child: const Text('Não tem uma conta? Cadastre-se'),
                ),

                const SizedBox(height: 8),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ResetSenhaView()),
                    );
                  },
                  child: const Text('Esqueci minha senha'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
