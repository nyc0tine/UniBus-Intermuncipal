//objeto temporário antes de guardar no banco de dados
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

  // Método para validar os dados
  bool isValid() {
    return nome.isNotEmpty &&
        email.isNotEmpty &&
        universidade.isNotEmpty &&
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
      'universidade': universidade,
      'telefone': telefone,
    
    };
  }

  // Converte o model em um Map pronto para salvar no Firestore
  Map<String, dynamic> toFirestoreMap() => toMap();

  // Cria um modelo a partir de um Map (por exemplo, DocumentSnapshot.data())
  factory CadastroEstudanteModel.fromMap(Map<String, dynamic> map) {
    return CadastroEstudanteModel(
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      universidade: map['universidade'] ?? '',
      telefone: map['telefone'] ?? '',
      senha: '', // senha não está armazenada no Firestore
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

  // Getter para validação individual de universidade
  String? get universidadeError {
    if (universidade.isEmpty) return 'Universidade não pode estar vazia';
    if (universidade.length < 3) return 'Universidade deve ter no mínimo 3 caracteres';
    return null;
  }
}