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
      backgroundColor: const Color(0xFFE7EBF3),
      body: Column(
        children: [
          // Cabeçalho padronizado
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 40),
            decoration: const BoxDecoration(
              color: Color(0xFF4C63B6),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: const Center(
              child: Text(
                'LOGIN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Logo com sombra
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          offset: const Offset(4, 4),
                          blurRadius: 4,
                        ),
                      ],
                      image: const DecorationImage(
                        image: AssetImage('assets/images/LogoBus.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Campos de texto estilizados
                  _buildInputField('Email:', emailController),
                  const SizedBox(height: 20),

                  _buildInputField('Senha:', senhaController, obscure: true),
                  const SizedBox(height: 20),

                  // Dropdown estilizado
                  Consumer<LoginViewModel>(
                    builder: (context, vm, _) {
                      return Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFF4C63B6),
                              offset: Offset(4, 4),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: DropdownButtonFormField<String>(
                          value: vm.tipoUsuario,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Tipo de Usuário',
                            labelStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: 'estudante', child: Text("Estudante")),
                            DropdownMenuItem(
                                value: 'motorista', child: Text("Motorista")),
                          ],
                          onChanged: (v) => vm.setTipoUsuario(v ?? 'estudante'),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  // Botão Entrar
                  Consumer<LoginViewModel>(
                    builder: (_, vm, __) {
                      return SizedBox(
                        width: 260,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4C63B6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 5,
                          ),
                          onPressed: () async {
                            final ok = await vm.login(
                              emailController.text.trim(),
                              senhaController.text,
                            );

                            if (ok) {
                              if (vm.tipoUsuario == 'estudante') {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const HomeEstudanteView()),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const HomeMotoristaView()),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      vm.mensagemErro ?? "Erro ao fazer login."),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            "ENTRAR",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Links
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SelecaoPerfilView()),
                      );
                    },
                    child: const Text(
                      "Não tem uma conta? Cadastre-se",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF4C63B6),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ResetSenhaView()),
                      );
                    },
                    child: const Text(
                      "Esqueci minha senha",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // REUTILIZAÇÃO DO ESTILO DOS CAMPOS DAS OUTRAS TELAS
  Widget _buildInputField(String label, TextEditingController controller,
      {bool obscure = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF4C63B6),
            offset: Offset(4, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          labelStyle: const TextStyle(
            fontSize: 18,
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
