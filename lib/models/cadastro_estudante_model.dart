class CadastroEstudanteModel {
  final String nome;
  final String email;
  final String universidade;
  final String telefone;
  final String senha;

  CadastroEstudanteModel({
    required this.nome,
    required this.email,
    required this.universidade,
    required this.telefone,
    required this.senha,
  });

  bool isValid() {
    return nome.trim().isNotEmpty &&
        email.trim().isNotEmpty &&
        universidade.trim().isNotEmpty &&
        telefone.trim().isNotEmpty &&
        senha.trim().isNotEmpty;
  }
}
