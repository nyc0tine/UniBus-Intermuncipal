import 'package:flutter/material.dart';

import '../models/cadastro_motorista_model.dart';
import '../viewmodels/cadastro_motorista_viewmodel.dart';

class CadastroMotoristaView extends StatefulWidget{
  const CadastroMotoristaView({super.key});

  @override
  State<CadastroMotoristaView> createState() => _CadastroMotoristaViewState();
}

// Estado da tela de cadastro de motorista
class _CadastroMotoristaViewState extends State<CadastroMotoristaView> {
  final CadastroMotoristaViewModel _viewModel = CadastroMotoristaViewModel();
  bool _isLoading = false;

// Controladores para os campos de entrada de texto
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
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
                  _buildInputField('Placa do Ônibus:', _placaController),
                  const SizedBox(height: 20),
                  _buildInputField('Telefone:', _telefoneController),
                  const SizedBox(height: 20),
                  _buildInputField('Senha:', _senhaController, obscure: true),
                  const SizedBox(height: 20),

                  Center(// Botão de cadastro
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4C63B6),
                        minimumSize: const Size(260, 55),// Tamanho do botão
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),// Bordas arredondadas
                        ),
                        elevation: 5,// Sombra do botão
                      ),
                      onPressed: _isLoading ? null : _salvarCadastro,// Ação ao pressionar o botão
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
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
  Widget _buildInputField(String label, TextEditingController controller, {bool obscure = false}) {// Parâmetro para ocultar o texto da senha
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

  // Método para salvar o cadastro do motorista
  Future<void> _salvarCadastro() async {
    try {
      // Criar modelo de cadastro
      final motorista = CadastroMotoristaModel(
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        placa: _placaController.text.trim(),
        telefone: _telefoneController.text.trim(),
        senha: _senhaController.text,
      );

      // Validar usando o model
      if (!motorista.isValid()) {
        // Mostrar o primeiro erro encontrado
        final erro = motorista.nomeError ??
            motorista.emailError ??
            motorista.telefoneError ??
            motorista.placaError ??
            motorista.senhaError ??
            'Dados inválidos';
        _mostrarMensagem(erro);
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Chamar o ViewModel para salvar
      final sucesso = await _viewModel.cadastrarMotorista(motorista);

      if (sucesso) {
        _mostrarMensagem('Cadastro realizado com sucesso!', sucesso: true);
        // Limpar campos
        _nomeController.clear();
        _emailController.clear();
        _placaController.clear();
        _telefoneController.clear();
        _senhaController.clear();

        // Voltar para a tela anterior após 2 segundos
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        _mostrarMensagem('Erro ao cadastrar. Verifique seus dados e tente novamente.');
      }
    } catch (e) {
      _mostrarMensagem('Erro: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Método para mostrar mensagens ao usuário
  void _mostrarMensagem(String mensagem, {bool sucesso = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: sucesso ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    // Liberar os controladores quando o widget for destruído
    _nomeController.dispose();
    _emailController.dispose();
    _placaController.dispose();
    _telefoneController.dispose();
    _senhaController.dispose();
    super.dispose();
  }
}
