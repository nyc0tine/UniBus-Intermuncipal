class CadastroMotoristaModel {
  final String nome;
  final String email;
  final String placa;
  final String telefone;
  final String senha;

  CadastroMotoristaModel({
    required this.nome,
    required this.email,
    required this.telefone,
    required this.placa,
    required this.senha,
  });

  bool isValid() {
    return nome.isNotEmpty &&
        email.isNotEmpty &&
        telefone.isNotEmpty &&
        placa.isNotEmpty &&
        senha.length >= 6;
  }
}
