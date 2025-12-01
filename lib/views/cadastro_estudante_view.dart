import 'package:flutter/material.dart';

class CadastroEstudanteView extends StatefulWidget{
  const CadastroEstudanteView({super.key});

  @override
  State<CadastroEstudanteView> createState() => _CadastroEstudanteViewState();
}

// Estado da tela de cadastro de motorista
class _CadastroEstudanteViewState extends State<CadastroEstudanteView> {

// Controladores para os campos de entrada de texto
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _universidadeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(// Estrutura básica da tela
      backgroundColor: const Color(0xFFE7EBF3),
      body: Column(
        children: [
          Container(
            width: double.infinity,// Largura total da tela
            padding: const EdgeInsets.only(top: 60, bottom: 40),
            decoration: const BoxDecoration(
              color: Color(0xFF4C63B6),
              borderRadius: BorderRadius.only(// Bordas arredondadas na parte inferior
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: const Center(// Título centralizado
              child: Text(
                'CADASTRO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          // Área expansível para o conteúdo do formulário
          Expanded(
            child: SingleChildScrollView(// Permite rolagem se o conteúdo for maior que a tela
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ícone de voltar
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF4C63B6),
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(// Ícone de perfil do motorista
                    child: Container(
                      height: 120,
                      width: 120,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Campos de entrada de texto
                  _buildInputField('Nome Completo:', _nomeController),
                  const SizedBox(height: 20),
                  _buildInputField('Email:', _emailController),
                  const SizedBox(height: 20),
                  _buildInputField('Universidade:', _universidadeController),
                  const SizedBox(height: 20),
                  _buildInputField('Telefone:', _telefoneController),
                  const SizedBox(height: 20),
                  _buildInputField('Senha:', _senhaController, obscure: true),
                  const SizedBox(height: 30),

                  Center(// Botão de cadastro
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4C63B6),
                        minimumSize: const Size(260, 55),// Tamanho do botão
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),// Bordas arredondadas
                        ),
                        elevation: 5,// Sombra do botão
                      ),
                      onPressed: () {},// Ação ao pressionar o botão
                      child: const Text(
                        'CADASTRAR',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ), 
        ],
      ),
    );
  }

  // Método auxiliar para construir campos de entrada de texto
  Widget _buildInputField(String label, TextEditingController controller, {bool obscure = false}) {// Parâmetro para ocultar o texto (senha)
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [// Sombra do contêiner
          BoxShadow(
            color: Color(0xFF4C63B6),
            offset: Offset(4, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: TextField(// Campo de entrada de texto
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
