import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
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
  final TextEditingController _universidadeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  File? _imagemPerfil;
  final _viewModel = CadastroEstudanteViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7EBF3),
      body: Column(
        children: [
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

                  // -------------------- FOTO DO ESTUDANTE --------------------
                  Center(
                    child: GestureDetector(
                      onTap: _selecionarImagem,
                      child: Container(
                        height: 240,
                        width: 180,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color(0xFF4C63B6),
                            width: 2,
                          ),
                        ),
                        child: _imagemPerfil == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.upload_file,
                                    size: 60,
                                    color: Color(0xFF4C63B6),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Escolher arquivo',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(13),
                                child: Image.file(
                                  _imagemPerfil!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

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

                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4C63B6),
                        minimumSize: const Size(260, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
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

  // -------------------------- VALIDAÇÕES E ENVIO --------------------------
  Future<void> _cadastrar() async {
    final nome = _nomeController.text.trim();
    final email = _emailController.text.trim();
    final universidade = _universidadeController.text.trim();
    final telefone = _telefoneController.text.trim();
    final senha = _senhaController.text;

    // -------- VALIDAÇÕES IGUAIS AO MOTORISTA --------
    if (nome.isEmpty ||
        email.isEmpty ||
        universidade.isEmpty ||
        telefone.isEmpty ||
        senha.isEmpty) {
      _showMessage('Por favor, preencha todos os campos.');
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      _showMessage('Digite um e-mail válido.');
      return;
    }

    if (senha.length < 6) {
      _showMessage('A senha deve ter pelo menos 6 caracteres.');
      return;
    }

    if (telefone.length < 8) {
      _showMessage('Digite um telefone válido.');
      return;
    }

    if (_imagemPerfil == null) {
      _showMessage('Selecione uma foto do estudante.');
      return;
    }

    final estudante = CadastroEstudanteModel(
      nome: nome,
      email: email,
      universidade: universidade,
      telefone: telefone,
      senha: senha,
    );

    // -------- LOADING --------
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final sucesso = await _viewModel.cadastrarEstudante(
        estudante,
        imagemPerfil: _imagemPerfil,
      );

      Navigator.pop(context);

      if (sucesso) {
        _showMessage("Cadastro realizado com sucesso!");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginView()),
          (route) => false,
        );
      } else {
        _showMessage("Erro ao cadastrar estudante. Tente novamente.");
      }
    } catch (e) {
      Navigator.pop(context);
      _showMessage("Erro inesperado: $e");
    }
  }

  // -------------------------- COMPONENTES --------------------------
  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    bool obscure = false,
  }) {
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

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Future<void> _selecionarImagem() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _imagemPerfil = File(result.files.first.path!);
        });
      }
    } catch (e) {
      _showMessage("Erro ao selecionar imagem: $e");
    }
  }
}
