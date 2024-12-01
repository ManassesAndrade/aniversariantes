import 'package:postgres/postgres.dart'; // Para usar PostgreSQL
import 'cliente_model.dart'; // O modelo Cliente

class DBHelper {
  // Função para criar uma nova conexão com o banco de dados
  Future<PostgreSQLConnection> _openConnection() async {
    final connection = PostgreSQLConnection(
      '179.184.6.193', // Host do banco de dados
      5434, // Porta do banco de dados
      'aniversariantes', // Nome do banco de dados
      username: 'postgres', // Seu usuário PostgreSQL
      password: '190681Le', // Sua senha PostgreSQL
    );

    try {
      await connection.open();
      return connection;
    } catch (e) {
      print("Erro ao abrir a conexão: $e");
      rethrow;
    }
  }
  
  

  // Função para fechar a conexão com o banco de dados
  Future<void> _closeConnection(PostgreSQLConnection conn) async {
    try {
      await conn.close();
    } catch (e) {
      print("Erro ao fechar a conexão: $e");
    }
  }

  // Função para inserir um novo cliente no banco de dados
  Future<void> inserirCliente(Cliente cliente) async {
    final conn = await _openConnection();
    try {
      // Inserir os dados do cliente na tabela 'clientes'
      await conn.query(
        'INSERT INTO clientes (nomeCliente, dataNascimento, telefone, dataCadastro, atendente, observacoes) '
        'VALUES (@nomeCliente, @dataNascimento, @telefone, @dataCadastro, @atendente, @observacoes)',
        substitutionValues: {
          'nomeCliente': cliente.nomeCliente,
          'dataNascimento': cliente.dataNascimento?.toIso8601String(),
          'telefone': cliente.telefone,
          'dataCadastro': cliente.dataCadastro.toIso8601String(),
          'atendente': cliente.atendente,
          'observacoes': cliente.observacoes,
        },
      );
    } catch (e) {
      print("Erro ao inserir cliente: $e");
      rethrow;
    } finally {
      await _closeConnection(conn);
    }
  }

  // Função para buscar aniversariantes (hoje ou amanhã)
  Future<List<Cliente>> buscarAniversariantes(DateTime data) async {
    final conn = await _openConnection();
    try {
      // Extraímos o dia e mês da data fornecida
      int dia = data.day;
      int mes = data.month;

      // Consulta SQL para buscar aniversariantes (compara mês e dia)
      List<List<dynamic>> results = await conn.query(
        'SELECT id, nomeCliente, dataNascimento, telefone, dataCadastro, atendente, observacoes '
        'FROM clientes WHERE EXTRACT(MONTH FROM dataNascimento) = @mes '
        'AND EXTRACT(DAY FROM dataNascimento) = @dia',
        substitutionValues: {
          'mes': mes,
          'dia': dia,
        },
      );

      // Verificando se o campo 'dataNascimento' precisa ser convertido corretamente
      List<Cliente> aniversariantes = results.map((row) {
        return Cliente(
          id: row[0],
          nomeCliente: row[1],
          // Convertendo a data de nascimento para o formato DateTime
          dataNascimento:
              DateTime.parse(row[2].toString()), // Convertendo para DateTime
          telefone: row[3],
          dataCadastro:
              DateTime.parse(row[4].toString()), // Convertendo para DateTime
          atendente: row[5],
          observacoes: row[6],
        );
      }).toList();

      return aniversariantes;
    } catch (e) {
      print("Erro ao buscar aniversariantes: $e");
      rethrow;
    } finally {
      await _closeConnection(conn);
    }
  }

  // Função para buscar todos os clientes
  Future<List<Cliente>> getTodosClientes() async {
    final conn = await _openConnection();
    try {
      // Consulta SQL para buscar todos os clientes
      List<List<dynamic>> results = await conn.query(
        'SELECT id, nomeCliente, dataNascimento, telefone, dataCadastro, atendente, observacoes '
        'FROM clientes order by nomeCliente',
      );

      // Mapeando o resultado para a lista de clientes
      List<Cliente> clientes = results.map((row) {
        return Cliente(
          id: row[0],
          nomeCliente: row[1],
          dataNascimento:
              DateTime.parse(row[2].toString()), // Convertendo para DateTime
          telefone: row[3],
          dataCadastro:
              DateTime.parse(row[4].toString()), // Convertendo para DateTime
          atendente: row[5],
          observacoes: row[6],
        );
      }).toList();

      return clientes;
    } catch (e) {
      print("Erro ao buscar todos os clientes: $e");
      rethrow;
    } finally {
      await _closeConnection(conn);
    }
  }

  // Função para buscar um cliente pelo ID
  Future<Cliente?> buscarClientePorId(int id) async {
    final conn = await _openConnection();
    try {
      // Consultar o banco de dados pelo ID do cliente
      List<List<dynamic>> results = await conn.query(
        'SELECT id, nomeCliente, dataNascimento, telefone, dataCadastro, atendente, observacoes '
        'FROM clientes WHERE id = @id',
        substitutionValues: {
          'id': id,
        },
      );

      // Verificar se o cliente foi encontrado
      if (results.isNotEmpty) {
        var row = results.first;
        return Cliente(
          id: row[0],
          nomeCliente: row[1],
          dataNascimento:
              DateTime.parse(row[2].toString()), // Convertendo para DateTime
          telefone: row[3],
          dataCadastro:
              DateTime.parse(row[4].toString()), // Convertendo para DateTime
          atendente: row[5],
          observacoes: row[6],
        );
      }

      return null; // Retorna null se não encontrar o cliente
    } catch (e) {
      print("Erro ao buscar cliente: $e");
      rethrow;
    } finally {
      await _closeConnection(conn);
    }
  }

  // Função para atualizar os dados de um cliente
  Future<void> atualizarCliente(Cliente cliente) async {
    final conn = await _openConnection();
    try {
      // Atualizar os dados do cliente na tabela 'clientes'
      await conn.query(
        'UPDATE clientes SET nomeCliente = @nomeCliente, dataNascimento = @dataNascimento, telefone = @telefone, '
        'dataCadastro = @dataCadastro, atendente = @atendente, observacoes = @observacoes '
        'WHERE id = @id',
        substitutionValues: {
          'nomeCliente': cliente.nomeCliente,
          'dataNascimento': cliente.dataNascimento?.toIso8601String(),
          'telefone': cliente.telefone,
          'dataCadastro': cliente.dataCadastro.toIso8601String(),
          'atendente': cliente.atendente,
          'observacoes': cliente.observacoes,
          'id': cliente.id,
        },
      );
    } catch (e) {
      print("Erro ao atualizar cliente: $e");
      rethrow;
    } finally {
      await _closeConnection(conn);
    }
  }

  // Função para excluir um cliente pelo ID
  Future<void> excluirCliente(int id) async {
    final conn = await _openConnection();
    try {
      // Excluir o cliente com o ID especificado
      await conn.query(
        'DELETE FROM clientes WHERE id = @id',
        substitutionValues: {
          'id': id,
        },
      );
    } catch (e) {
      print("Erro ao excluir cliente: $e");
      rethrow;
    } finally {
      await _closeConnection(conn);
    }
  }

  // Método para buscar todos os clientes
  Future<List<Cliente>> buscarTodosClientes() async {
    final db =
        await _openConnection(); // Assume que você já tem uma instância do seu banco de dados
    var resultado = await db.query(
        'clientes'); // Assumindo que você tem uma tabela chamada 'clientes'
    List<Cliente> listaClientes = [];
    for (var item in resultado) {
      listaClientes.add(Cliente.fromMap(
          item as Map<String, dynamic>)); // Converte os dados do banco em objetos Cliente
    }
    return listaClientes;
  }
}

/*import 'package:postgres/postgres.dart';  // Para usar PostgreSQL
import 'cliente_model.dart';  // O modelo Cliente

class DBHelper {
  // Função para criar uma nova conexão com o banco de dados
  Future<PostgreSQLConnection> _openConnection() async {
    final connection = PostgreSQLConnection(
      '179.184.6.193', // Host do banco de dados
      5434,        // Porta do banco de dados
      'aniversariantes', // Nome do banco de dados
      username: 'postgres', // Seu usuário PostgreSQL
      password: '190681Le',   // Sua senha PostgreSQL
    );

    try {
      await connection.open();
      return connection;
    } catch (e) {
      print("Erro ao abrir a conexão: $e");
      rethrow;
    }
  }

  // Função para fechar a conexão com o banco de dados
  Future<void> _closeConnection(PostgreSQLConnection conn) async {
    try {
      await conn.close();
    } catch (e) {
      print("Erro ao fechar a conexão: $e");
    }
  }

  // Função para inserir um novo cliente no banco de dados
  Future<void> inserirCliente(Cliente cliente) async {
    final conn = await _openConnection();
    try {
      // Inserir os dados do cliente na tabela 'clientes'
      await conn.query(
        'INSERT INTO clientes (nomeCliente, dataNascimento, telefone, dataCadastro, atendente, observacoes) '
            'VALUES (@nomeCliente, @dataNascimento, @telefone, @dataCadastro, @atendente, @observacoes)',
        substitutionValues: {
          'nomeCliente': cliente.nomeCliente,
          'dataNascimento': cliente.dataNascimento?.toIso8601String(),
          'telefone': cliente.telefone,
          'dataCadastro': cliente.dataCadastro.toIso8601String(),
          'atendente': cliente.atendente,
          'observacoes': cliente.observacoes,
        },
      );
    } catch (e) {
      print("Erro ao inserir cliente: $e");
      rethrow;
    } finally {
      await _closeConnection(conn);
    }
  }

  // Função para buscar aniversariantes (hoje ou amanhã)
  Future<List<Cliente>> buscarAniversariantes(DateTime data) async {
    final conn = await _openConnection();
    try {
      // Extraímos o dia e mês da data fornecida
      int dia = data.day;
      int mes = data.month;

      // Consulta SQL para buscar aniversariantes (compara mês e dia)
      List<List<dynamic>> results = await conn.query(
        'SELECT id, nomeCliente, dataNascimento, telefone, dataCadastro, atendente, observacoes '
            'FROM clientes WHERE EXTRACT(MONTH FROM dataNascimento) = @mes '
            'AND EXTRACT(DAY FROM dataNascimento) = @dia',
        substitutionValues: {
          'mes': mes,
          'dia': dia,
        },
      );

      // Verificando se o campo 'dataNascimento' precisa ser convertido corretamente
      List<Cliente> aniversariantes = results.map((row) {
        return Cliente(
          id: row[0],
          nomeCliente: row[1],
          // Convertendo a data de nascimento para o formato DateTime
          dataNascimento: DateTime.parse(row[2].toString()),  // Convertendo para DateTime
          telefone: row[3],
          dataCadastro: DateTime.parse(row[4].toString()),  // Convertendo para DateTime
          atendente: row[5],
          observacoes: row[6],
        );
      }).toList();

      return aniversariantes;
    } catch (e) {
      print("Erro ao buscar aniversariantes: $e");
      rethrow;
    } finally {
      await _closeConnection(conn);
    }
  }

  // Função para buscar todos os clientes
  Future<List<Cliente>> getTodosClientes() async {
    final conn = await _openConnection();
    try {
      // Consulta SQL para buscar todos os clientes
      List<List<dynamic>> results = await conn.query(
        'SELECT id, nomeCliente, dataNascimento, telefone, dataCadastro, atendente, observacoes '
            'FROM clientes',
      );

      // Mapeando o resultado para a lista de clientes
      List<Cliente> clientes = results.map((row) {
        return Cliente(
          id: row[0],
          nomeCliente: row[1],
          dataNascimento: DateTime.parse(row[2].toString()),  // Convertendo para DateTime
          telefone: row[3],
          dataCadastro: DateTime.parse(row[4].toString()),  // Convertendo para DateTime
          atendente: row[5],
          observacoes: row[6],
        );
      }).toList();

      return clientes;
    } catch (e) {
      print("Erro ao buscar todos os clientes: $e");
      rethrow;
    } finally {
      await _closeConnection(conn);
    }
  }

  // Função para buscar um cliente pelo ID
  Future<Cliente?> buscarClientePorId(int id) async {
    final conn = await _openConnection();
    try {
      // Consultar o banco de dados pelo ID do cliente
      List<List<dynamic>> results = await conn.query(
        'SELECT id, nomeCliente, dataNascimento, telefone, dataCadastro, atendente, observacoes '
            'FROM clientes WHERE id = @id',
        substitutionValues: {
          'id': id,
        },
      );

      // Verificar se o cliente foi encontrado
      if (results.isNotEmpty) {
        var row = results.first;
        return Cliente(
          id: row[0],
          nomeCliente: row[1],
          dataNascimento: DateTime.parse(row[2].toString()),  // Convertendo para DateTime
          telefone: row[3],
          dataCadastro: DateTime.parse(row[4].toString()),  // Convertendo para DateTime
          atendente: row[5],
          observacoes: row[6],
        );
      }

      return null;  // Retorna null se não encontrar o cliente
    } catch (e) {
      print("Erro ao buscar cliente: $e");
      rethrow;
    } finally {
      await _closeConnection(conn);
    }
  }

  // Função para atualizar os dados de um cliente
  Future<void> atualizarCliente(Cliente cliente) async {
    final conn = await _openConnection();
    try {
      // Atualizar os dados do cliente na tabela 'clientes'
      await conn.query(
        'UPDATE clientes SET nomeCliente = @nomeCliente, dataNascimento = @dataNascimento, telefone = @telefone, '
            'dataCadastro = @dataCadastro, atendente = @atendente, observacoes = @observacoes '
            'WHERE id = @id',
        substitutionValues: {
          'nomeCliente': cliente.nomeCliente,
          'dataNascimento': cliente.dataNascimento?.toIso8601String(),
          'telefone': cliente.telefone,
          'dataCadastro': cliente.dataCadastro.toIso8601String(),
          'atendente': cliente.atendente,
          'observacoes': cliente.observacoes,
          'id': cliente.id,
        },
      );
    } catch (e) {
      print("Erro ao atualizar cliente: $e");
      rethrow;
    } finally {
      await _closeConnection(conn);
    }
  }

  // Função para excluir um cliente pelo ID
  Future<void> excluirCliente(int id) async {
    final conn = await _openConnection();
    try {
      // Excluir o cliente com o ID especificado
      await conn.query(
        'DELETE FROM clientes WHERE id = @id',
        substitutionValues: {
          'id': id,
        },
      );
    } catch (e) {
      print("Erro ao excluir cliente: $e");
      rethrow;
    } finally {
      await _closeConnection(conn);
    }
  }
}
*/
