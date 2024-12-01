class Cliente {
  final int? id;  // ID é gerado automaticamente pelo banco
  final String nomeCliente;
  final DateTime? dataNascimento;
  final String? telefone;
  final DateTime dataCadastro;
  final String atendente;
  final String? observacoes;

  Cliente({
    this.id,
    required this.nomeCliente,
    required this.dataNascimento,
    this.telefone,
    required this.dataCadastro,
    required this.atendente,
    this.observacoes,
  });

  // Convertendo um Cliente para Map (para inserção no banco)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomeCliente': nomeCliente,
      'dataNascimento': dataNascimento?.toIso8601String(),
      'telefone': telefone,
      'dataCadastro': dataCadastro.toIso8601String(),
      'atendente': atendente,
      'observacoes': observacoes,
    };
  }

  // Criando um Cliente a partir de um Map (para recuperação do banco)
  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'],
      nomeCliente: map['nomeCliente'],
      dataNascimento: DateTime.tryParse(map['dataNascimento']),
      telefone: map['telefone'],
      dataCadastro: DateTime.tryParse(map['dataCadastro'])!,
      atendente: map['atendente'],
      observacoes: map['observacoes'],
    );
  }

  // Função para calcular a idade do cliente
  int get idade {
    if (dataNascimento == null) {
      return 0;
    }
    DateTime today = DateTime.now();
    int age = today.year - dataNascimento!.year;
    if (today.month < dataNascimento!.month ||
        (today.month == dataNascimento!.month && today.day < dataNascimento!.day)) {
      age--;
    }
    return age;
  }
}
