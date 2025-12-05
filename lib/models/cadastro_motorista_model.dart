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

  /// Converte os dados para Map (usado no Firestore)
  Map<String, dynamic> toMap() {
    return {
      "nome": nome,
      "email": email,
      "placa": placa,
      "telefone": telefone,
    };
  }

  /// Validação de campos
  bool isValid() {
    return _validarNome() &&
        _validarEmail() &&
        _validarTelefone() &&
        _validarPlaca() &&
        _validarSenha();
  }

  bool _validarNome() => nome.trim().isNotEmpty;

  bool _validarEmail() {
    final emailRegex = RegExp(r"^[^@]+@[^@]+\.[^@]+$");
    return emailRegex.hasMatch(email);
  }

  bool _validarTelefone() {
    // Aceita telefone com 9 dígitos (padrão brasileiro)
    final phoneRegex = RegExp(r"^\d{9,15}$");
    return phoneRegex.hasMatch(telefone);
  }

  bool _validarPlaca() {
    // Aceita placas antigas e Mercosul (simplificado)
    final placaRegex = RegExp(r"^[A-Z]{3}[0-9][A-Z0-9][0-9]{2}$");
    return placaRegex.hasMatch(placa.toUpperCase());
  }

  bool _validarSenha() => senha.length >= 6;
}
