class CadastroMotoristaModel {
  final String nome;
  final String email;
  final String placa;
  final String telefone;
  final String senha;
  final String? fotoPerfil; // URL opcional da foto de perfil

  CadastroMotoristaModel({
    required this.nome,
    required this.email,
    required this.placa,
    required this.telefone,
    required this.senha,
    this.fotoPerfil,
  });

  // Método para validar os dados
  bool isValid() {
    return nome.isNotEmpty &&
        email.isNotEmpty &&
        placa.isNotEmpty &&
        telefone.isNotEmpty &&
        senha.isNotEmpty &&
        _isValidEmail(email) &&
        _isValidPhone(telefone) &&
        senha.length >= 6;
  }

  // Validar email com regex
  static bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  // Validar telefone (aceita apenas números)
  static bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\d{10,11}$');
    return phoneRegex.hasMatch(phone.replaceAll(RegExp(r'\D'), ''));
  }

  // Método para converter para Map (para salvar no banco)
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'email': email,
      'placa': placa,
      'telefone': telefone,
      if (fotoPerfil != null) 'fotoPerfil': fotoPerfil,
    };
  }

  // Converte o model em um Map pronto para salvar no Firestore
  Map<String, dynamic> toFirestoreMap() => toMap();

  /// Cria um modelo a partir de um Map (por exemplo, DocumentSnapshot.data())
  /// Usado para ler dados do Firestore
  factory CadastroMotoristaModel.fromMap(Map<String, dynamic> map) {
    return CadastroMotoristaModel(
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      placa: map['placa'] ?? '',
      telefone: map['telefone'] ?? '',
      senha: '', // senha não está armazenada no Firestore
      fotoPerfil: map['fotoPerfil'],
    );
  }

  // Getter para validação individual de email
  String? get emailError {
    if (email.isEmpty) return 'Email não pode estar vazio';
    if (!_isValidEmail(email)) return 'Email inválido';
    return null;
  }

  // Getter para validação individual de telefone
  String? get telefoneError {
    if (telefone.isEmpty) return 'Telefone não pode estar vazio';
    if (!_isValidPhone(telefone)) return 'Telefone deve ter 10 ou 11 dígitos';
    return null;
  }

  // Getter para validação individual de senha
  String? get senhaError {
    if (senha.isEmpty) return 'Senha não pode estar vazia';
    if (senha.length < 6) return 'Senha deve ter no mínimo 6 caracteres';
    return null;
  }

  // Getter para validação individual de nome
  String? get nomeError {
    if (nome.isEmpty) return 'Nome não pode estar vazio';
    if (nome.length < 3) return 'Nome deve ter no mínimo 3 caracteres';
    return null;
  }

  // Getter para validação individual de placa
  String? get placaError {
    if (placa.isEmpty) return 'placa não pode estar vazia';
    if (placa.length < 5) return 'placa inválida';
    return null;
  }
}