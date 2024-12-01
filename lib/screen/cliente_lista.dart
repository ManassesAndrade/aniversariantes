import 'package:aniversariantes/screen/cliente_edicao.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../bd/cliente_model.dart';
import '../bd/db_helper.dart'; // Certifique-se de importar o modelo Cliente

class ClienteListaPage extends StatefulWidget {
  @override
  _ClienteListaPageState createState() => _ClienteListaPageState();
}

class _ClienteListaPageState extends State<ClienteListaPage> {
  late Future<List<Cliente>> _clientes;

  @override
  void initState() {
    super.initState();
    // Carregar todos os clientes ao iniciar a tela
    _clientes = DBHelper().getTodosClientes();
  }

  // Função para excluir um cliente
  void _excluirCliente(int clienteId) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Excluir Cliente'),
        content: Text('Tem certeza que deseja excluir este cliente?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('Excluir'),
          ),
        ],
      ),
    ) ?? false;

    if (confirmDelete) {
      await DBHelper().excluirCliente(clienteId);
      setState(() {
        _clientes = DBHelper().getTodosClientes();
      });
    }
  }

  // Função para editar um cliente
  void _editarCliente(Cliente cliente) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClienteDetalhePageEdit(cliente: cliente),
      ),
    ).then((_) {
      // Atualiza a lista de clientes após editar
      setState(() {
        _clientes = DBHelper().getTodosClientes();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Clientes'),
        backgroundColor: Colors.blue[600], // Cor da AppBar
      ),
      body: FutureBuilder<List<Cliente>>(
        future: _clientes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar clientes: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum cliente cadastrado.'));
          } else {
            // Exibindo a lista de clientes
            List<Cliente> clientes = snapshot.data!;
            return ListView.builder(
              itemCount: clientes.length,
              itemBuilder: (context, index) {
                Cliente cliente = clientes[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Card(  // Colocando os itens em um Card para melhorar o visual
                    color: Colors.blue[50],  // Cor de fundo do Card, similar ao da HomePage
                    child: ListTile(
                      title: Text(
                        cliente.nomeCliente.toUpperCase(),
                        style: TextStyle(fontSize: 18, color: Colors.blue[600]), // Cor do texto com destaque
                      ),
                      subtitle: Text(
                        'Telefone: ${cliente.telefone}',
                        style: TextStyle(color: Colors.blue[800]), // Cor do subtítulo
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editarCliente(cliente),  // Chama a função de editar
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _excluirCliente(cliente.id!),  // Chama a função de excluir
                          ),
                        ],
                      ),
                      onTap: () {
                        // Ação ao clicar no cliente, por exemplo, abrir os detalhes
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClienteDetalhePage(cliente: cliente),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ClienteDetalhePage extends StatelessWidget {
  final Cliente cliente;

  ClienteDetalhePage({required this.cliente});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cliente.nomeCliente),
        backgroundColor: Colors.blue[600],  // Cor da AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${cliente.nomeCliente}', style: TextStyle(fontSize: 18, color: Colors.blue[800])),
            Text('Data de Nascimento: ${_formatarData(cliente.dataNascimento)}', style: TextStyle(fontSize: 18, color: Colors.blue[800]), ),
            Text('Telefone: ${cliente.telefone}', style: TextStyle(fontSize: 18, color: Colors.blue[800])),
            Text('Atendente: ${cliente.atendente}', style: TextStyle(fontSize: 18, color: Colors.blue[800])),
            Text('Observações: ${cliente.observacoes}', style: TextStyle(fontSize: 18, color: Colors.blue[800])),
          ],
        ),
      ),
    );
  }
  // Função para formatar a data no formato dd/MM/yyyy
  String _formatarData(DateTime? data) {
    if (data == null) return 'Data não informada'; // Se a data for nula, retorna 'Data não informada'
    // Usando o pacote intl para formatar a data no formato dd/MM/yyyy
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    return dateFormat.format(data); // Retorna a data formatada
  }
}




/*import 'package:flutter/material.dart';
import '../bd/cliente_model.dart';
import '../bd/db_helper.dart'; // Certifique-se de importar o modelo Cliente

class ClienteListaPage extends StatefulWidget {
  @override
  _ClienteListaPageState createState() => _ClienteListaPageState();
}

class _ClienteListaPageState extends State<ClienteListaPage> {
  late Future<List<Cliente>> _clientes;

  @override
  void initState() {
    super.initState();
    // Carregar todos os clientes ao iniciar a tela
    _clientes = DBHelper().getTodosClientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Clientes'),
        backgroundColor: Colors.blue[600], // Alterando a cor da AppBar para azul
      ),
      body: FutureBuilder<List<Cliente>>(
        future: _clientes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar clientes: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum cliente cadastrado.'));
          } else {
            // Exibindo a lista de clientes
            List<Cliente> clientes = snapshot.data!;
            return ListView.builder(
              itemCount: clientes.length,
              itemBuilder: (context, index) {
                Cliente cliente = clientes[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Card(  // Colocando os itens em um Card para melhorar o visual
                    color: Colors.blue[50],  // Cor de fundo do Card, similar ao da HomePage
                    child: ListTile(
                      title: Text(
                        cliente.nomeCliente.toUpperCase(),
                        style: TextStyle(fontSize: 18, color: Colors.blue[600]), // Cor do texto com destaque
                      ),
                      subtitle: Text(
                        'Telefone: ${cliente.telefone}',
                        style: TextStyle(color: Colors.blue[800]), // Cor do subtítulo
                      ),
                      onTap: () {
                        // Ação ao clicar no cliente, por exemplo, abrir os detalhes
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClienteDetalhePage(cliente: cliente),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ClienteDetalhePage extends StatelessWidget {
  final Cliente cliente;

  ClienteDetalhePage({required this.cliente});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cliente.nomeCliente),
        backgroundColor: Colors.blue[600],  // Cor da AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${cliente.nomeCliente}', style: TextStyle(fontSize: 18, color: Colors.blue[800])),
            Text('Data de Nascimento: ${_formatarData(cliente.dataNascimento)}', style: TextStyle(fontSize: 18, color: Colors.blue[800])),
            Text('Telefone: ${cliente.telefone}', style: TextStyle(fontSize: 18, color: Colors.blue[800])),
            Text('Atendente: ${cliente.atendente}', style: TextStyle(fontSize: 18, color: Colors.blue[800])),
            Text('Observações: ${cliente.observacoes}', style: TextStyle(fontSize: 18, color: Colors.blue[800])),
          ],
        ),
      ),
    );
  }

  String _formatarData(DateTime? data) {
    if (data == null) return 'Data não informada';
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }
}
*/