import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:unibus_intermunicipal/models/cadastro_estudante_model.dart';
import 'package:unibus_intermunicipal/viewmodels/cadastro_estudante_viewmodel.dart';
import 'package:unibus_intermunicipal/views/login_view.dart';

class CadastroEstudanteView extends StatefulWidget{
  const CadastroEstudanteView({super.key});

  @override
  State<CadastroEstudanteView> createState() => _CadastroEstudanteViewState();
}

// Estado da tela de cadastro de estudante
class _CadastroEstudanteViewState extends State<CadastroEstudanteView> {

// Controladores para os campos de entrada de texto
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _universidadeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  File? _imagemPerfil;
  final _viewModel = CadastroEstudanteViewModel();

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
                  // Seletor/preview de foto do estudante
                  const SizedBox(height: 20),
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
                                children: [
                                  Icon(
                                    Icons.upload_file,
                                    size: 60,
                                    color: const Color(0xFF4C63B6),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
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
                      onPressed: () async {
                        final estudante = CadastroEstudanteModel(
                          nome: _nomeController.text.trim(),
                          email: _emailController.text.trim(),
                          universidade: _universidadeController.text.trim(),
                          telefone: _telefoneController.text.trim(),
                          senha: _senhaController.text,
                        );
                        // Exibe loading
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const Center(child: CircularProgressIndicator()),
                        );
                        try {
                          final sucesso = await _viewModel.cadastrarEstudante(
                            estudante,
                            imagemPerfil: _imagemPerfil,
                          );
                          Navigator.of(context).pop(); // Remove loading
                          if (sucesso) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Cadastro realizado com sucesso!')),
                            );
                            // Volta para página de login
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => const LoginView()),
                              (route) => false,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Erro ao cadastrar estudante. Verifique os dados e tente novamente.')),
                            );
                          }
                        } catch (e, st) {
                          Navigator.of(context).pop(); // Remove loading se ainda estiver presente
                          print('Erro inesperado ao cadastrar: $e');
                          print(st);
                          await showDialog<void>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Erro inesperado'),
                              content: Text(e.toString()),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
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

  // Método para selecionar imagem de perfil usando FilePicker
  Future<void> _selecionarImagem() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false);
      if (result != null && result.files.isNotEmpty && result.files.first.path != null) {
        setState(() {
          _imagemPerfil = File(result.files.first.path!);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao selecionar imagem: $e')),
      );
    }
  }

}
