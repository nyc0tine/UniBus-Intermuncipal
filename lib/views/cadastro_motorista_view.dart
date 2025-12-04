import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:unibus_intermunicipal/models/cadastro_motorista_model.dart';
import 'package:unibus_intermunicipal/viewmodels/cadastro_motorista_viewmodel.dart';
import 'package:unibus_intermunicipal/views/login_view.dart';

class CadastroMotoristaView extends StatefulWidget {
  const CadastroMotoristaView({super.key});

  @override
  State<CadastroMotoristaView> createState() => _CadastroMotoristaViewState();
}

class _CadastroMotoristaViewState extends State<CadastroMotoristaView> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  File? _imagemPerfil;
  final _viewModel = CadastroMotoristaViewModel();

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
                  
                  // Foto do motorista
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

                  _buildInputField('Placa:', _placaController),
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
                      onPressed: () async {
                        final nome = _nomeController.text.trim();
                        final email = _emailController.text.trim();
                        final placa = _placaController.text.trim();
                        final telefone = _telefoneController.text.trim();
                        final senha = _senhaController.text;

                        // ---------- VALIDAÇÕES ----------
                        if (nome.isEmpty ||
                            email.isEmpty ||
                            placa.isEmpty ||
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

                        if (placa.length < 7) {
                          _showMessage('Digite uma placa válida.');
                          return;
                        }

                        if (_imagemPerfil == null) {
                          _showMessage('Selecione uma foto do motorista.');
                          return;
                        }

                        final motorista = CadastroMotoristaModel(
                          nome: nome,
                          email: email,
                          placa: placa,
                          telefone: telefone,
                          senha: senha,
                        );

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const Center(child: CircularProgressIndicator()),
                        );

                        try {
                          final sucesso = await _viewModel.cadastrarMotorista(
                            motorista,
                            imagemPerfil: _imagemPerfil,
                          );

                          Navigator.of(context).pop();

                          if (sucesso) {
                            _showMessage('Cadastro realizado com sucesso!');
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => const LoginView()),
                              (route) => false,
                            );
                          } else {
                            _showMessage('Erro ao cadastrar. Verifique os dados.');
                          }
                        } catch (e) {
                          Navigator.of(context).pop();
                          _showMessage('Erro inesperado: $e');
                        }
                      },
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

  Widget _buildInputField(String label, TextEditingController controller, {bool obscure = false}) {
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

  Future<void> _selecionarImagem() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false);
      if (result != null && result.files.isNotEmpty && result.files.first.path != null) {
        setState(() {
          _imagemPerfil = File(result.files.first.path!);
        });
      }
    } catch (e) {
      _showMessage('Erro ao selecionar imagem: $e');
    }
  }

  // ---------- Método auxiliar ----------
  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }
}
