import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:unibus_intermunicipal/models/cadastro_estudante_model.dart';
import 'package:unibus_intermunicipal/viewmodels/cadastro_estudante_viewmodel.dart';
import 'package:unibus_intermunicipal/views/login_view.dart';

class CadastroEstudanteView extends StatefulWidget {
  const CadastroEstudanteView({super.key});

  @override
  State<CadastroEstudanteView> createState() => _CadastroEstudanteViewState();
}

class _CadastroEstudanteViewState extends State<CadastroEstudanteView> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  final _viewModel = CadastroEstudanteViewModel();

  /// MÁSCARA DE TELEFONE
  final _telefoneMask = MaskTextInputFormatter(
    mask: '(##) # ####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  /// UNIVERSIDADES
  final List<String> _universidades = [
    'UNIPÊ',
    'UFPB',
    'IFPB',
    'FPB',
    'UNINASSAU',
    'UNIESP',
  ];

  String? _universidadeSelecionada;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  String _cleanText(String v) => v.trim();
  String _cleanPhone(String v) => v.replaceAll(RegExp(r'\D'), '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7EBF3),
      body: Column(
        children: [
          // ---------------- TÍTULO ----------------
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

          // ---------------- FORMULÁRIO ----------------
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF4C63B6),
                      size: 30,
                    ),
                  ),

                  const SizedBox(height: 40),

                  _buildInputField('Nome Completo:', _nomeController),
                  const SizedBox(height: 20),

                  _buildInputField('Email:', _emailController),
                  const SizedBox(height: 20),

                  // ---------------- DROPDOWN UNIVERSIDADE ----------------
                  Container(
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
                      value: _universidadeSelecionada,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Universidade:',
                        labelStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      items: _universidades.map((u) {
                        return DropdownMenuItem(
                          value: u,
                          child: Text(
                            u,
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      }).toList(),
                      onChanged: (v) =>
                          setState(() => _universidadeSelecionada = v),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ---------------- TELEFONE COM MÁSCARA ----------------
                  Container(
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
                    child: TextFormField(
                      controller: _telefoneController,
                      decoration: const InputDecoration(
                        labelText: "Telefone",
                        border: InputBorder.none,
                        labelStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [_telefoneMask],
                    ),
                  ),

                  const SizedBox(height: 20),

                  _buildInputField('Senha:', _senhaController, obscure: true),
                  const SizedBox(height: 30),

                  // ---------------- BOTÃO CADASTRAR ----------------
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4C63B6),
                        minimumSize: const Size(260, 55),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 5,
                      ),
                      onPressed: _cadastrar,
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

  // ---------------- CAMPO ESTILIZADO ----------------
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

  // ---------------- FUNÇÃO CADASTRAR ----------------
  Future<void> _cadastrar() async {
    final nome = _cleanText(_nomeController.text);
    final email = _cleanText(_emailController.text);
    final telefone = _cleanPhone(_telefoneController.text);
    final senha = _senhaController.text.trim();
    final universidade = _universidadeSelecionada;

    if (nome.isEmpty ||
        email.isEmpty ||
        telefone.isEmpty ||
        senha.isEmpty ||
        universidade == null) {
      _showMessage('Por favor, preencha todos os campos.');
      return;
    }

    if (senha.length < 6) {
      _showMessage('A senha deve ter pelo menos 6 caracteres.');
      return;
    }

    if (telefone.length < 10) {
      _showMessage('Digite um telefone válido.');
      return;
    }

    final estudante = CadastroEstudanteModel(
      nome: nome,
      email: email,
      universidade: universidade,
      telefone: telefone,
      senha: senha,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final sucesso = await _viewModel.cadastrarEstudante(estudante);

      Navigator.of(context).pop();

      if (sucesso) {
        _showMessage('Cadastro realizado com sucesso!');
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginView()),
          (route) => false,
        );
      } else {
        _showMessage(_viewModel.ultimoErro ?? 'Erro ao cadastrar.');
      }
    } catch (e) {
      Navigator.of(context).pop();
      _showMessage('Erro inesperado: $e');
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }
}
