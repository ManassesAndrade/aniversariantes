import 'package:aniversariantes/screen/cliente_edicao.dart';
import 'package:aniversariantes/screen/cliente_lista.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // Importação para formatar a data
import '../bd/cliente_model.dart';
import '../bd/db_helper.dart';
import 'cliente_cadastro.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBHelper dbHelper = DBHelper();
  late Future<List<Cliente>> aniversariantesHoje;
  late Future<List<Cliente>> aniversariantesAmanha;

  // Formatar a data para exibir no título
  String getDataHoje() {
    return DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  @override
  void initState() {
    super.initState();
    // Carregar os aniversariantes de hoje e amanhã
    _atualizarDados();
  }

  // Método para atualizar os dados
  void _atualizarDados() {
    setState(() {
      aniversariantesHoje = dbHelper.buscarAniversariantes(DateTime.now());
      aniversariantesAmanha = dbHelper.buscarAniversariantes(DateTime.now().add(Duration(days: 1)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aniversarios - ${getDataHoje()}"),
        backgroundColor: Colors.blue[600],
        actions: [
          // Botão de atualizar na AppBar
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _atualizarDados,  // Chama o método para atualizar os dados
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.blue[50],
              padding: EdgeInsets.all(8.0),
              child: FutureBuilder<List<Cliente>>(
                future: aniversariantesHoje,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Erro ao carregar aniversariantes de hoje"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("Nenhum aniversariante hoje."));
                  } else {
                    List<Cliente> aniversariantes = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Aniversariantes de Hoje",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[600],
                          ),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: aniversariantes.length,
                            itemBuilder: (context, index) {
                              Cliente cliente = aniversariantes[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  title: Text(cliente.nomeCliente.toUpperCase()),
                                  subtitle: Text("Idade: ${cliente.idade} anos"),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ClienteDetalhePageEdit(cliente: cliente),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Container(
              color: Colors.green[50],
              padding: EdgeInsets.all(8.0),
              child: FutureBuilder<List<Cliente>>(
                future: aniversariantesAmanha,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Erro ao carregar aniversariantes de amanhã"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("Nenhum aniversariante amanhã."));
                  } else {
                    List<Cliente> aniversariantes = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Aniversariantes de Amanhã",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[600],
                          ),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: aniversariantes.length,
                            itemBuilder: (context, index) {
                              Cliente cliente = aniversariantes[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  title: Text(cliente.nomeCliente.toUpperCase()),
                                  subtitle: Text("${cliente.atendente} -  Idade: ${cliente.idade} anos"),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ClienteDetalhePageEdit(cliente: cliente),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          // Botão de adicionar cliente
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClienteCadastroPage(),
                  ),
                );
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.blue[600],
            ),
          ),
          // Botão de lista de clientes
          Positioned(
            bottom: 70,
            right: 10,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClienteListaPage(),
                  ),
                );
              },
              child: Icon(Icons.list),
              backgroundColor: Colors.green[600],
            ),
          ),
        ],
      ),
    );
  }
}




/*import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // Importação para formatar a data
import '../bd/cliente_model.dart';
import '../bd/db_helper.dart';
import 'cliente_cadastro.dart';  // Importar a tela de cadastro
import 'cliente_detalhe.dart';  // Importar a tela de detalhes do cliente

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Instância de DBHelper para interagir com o banco
  DBHelper dbHelper = DBHelper();
  late Future<List<Cliente>> aniversariantesHoje;
  late Future<List<Cliente>> aniversariantesAmanha;

  // Formatar a data para exibir no título
  String getDataHoje() {
    return DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  @override
  void initState() {
    super.initState();
    // Carregar os aniversariantes de hoje e amanhã
    aniversariantesHoje = dbHelper.buscarAniversariantes(DateTime.now());  // Aniversariantes de hoje
    print('Aniversariantes de Hoje');
    aniversariantesAmanha = dbHelper.buscarAniversariantes(DateTime.now().add(Duration(days: 1)));  // Aniversariantes de amanhã
  }

  // Função para atualizar os aniversariantes
  void _atualizarAniversariantes() {
    setState(() {
      aniversariantesHoje = dbHelper.buscarAniversariantes(DateTime.now());
      aniversariantesAmanha = dbHelper.buscarAniversariantes(DateTime.now().add(Duration(days: 1)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aniversariantes - ${getDataHoje()}"),  // Exibir data de hoje
        backgroundColor: Colors.blue[600], // Cor mais forte para a AppBar
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),  // Ícone de atualização
            onPressed: _atualizarAniversariantes,  // Chama a função de atualização
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          // Parte Superior: Aniversariantes de Hoje
          Expanded(
            child: Container(
              color: Colors.blue[50], // Azul clarinho para a parte superior
              padding: EdgeInsets.all(8.0),
              child: FutureBuilder<List<Cliente>>(
                future: aniversariantesHoje,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Erro ao carregar aniversariantes de hoje"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("Nenhum aniversariante hoje."));
                  } else {
                    List<Cliente> aniversariantes = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Aniversariantes de Hoje", // Exibir data de hoje
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[600],
                          ),
                        ),
                        SizedBox(height: 10),
                        // Lista de aniversariantes de hoje com ListView
                        Expanded(
                          child: ListView.builder(
                            itemCount: aniversariantes.length,
                            itemBuilder: (context, index) {
                              Cliente cliente = aniversariantes[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  title: Text(cliente.nomeCliente.toUpperCase()),  // Nome em maiúsculo
                                  subtitle: Text("Idade: ${cliente.idade} anos"),  // Exibindo a idade
                                  onTap: () {
                                    // Ação ao tocar no nome do cliente
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ClienteDetalhePage(cliente: cliente),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 16), // Espaçamento entre as duas seções
          // Parte Inferior: Aniversariantes de Amanhã
          Expanded(
            child: Container(
              color: Colors.green[50], // Verde clarinho para a parte inferior
              padding: EdgeInsets.all(8.0),
              child: FutureBuilder<List<Cliente>>(
                future: aniversariantesAmanha,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Erro ao carregar aniversariantes de amanhã"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("Nenhum aniversariante amanhã."));
                  } else {
                    List<Cliente> aniversariantes = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Aniversariantes de Amanhã",  // Exibir data de amanhã
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[600],
                          ),
                        ),
                        SizedBox(height: 10),
                        // Lista de aniversariantes de amanhã com ListView
                        Expanded(
                          child: ListView.builder(
                            itemCount: aniversariantes.length,
                            itemBuilder: (context, index) {
                              Cliente cliente = aniversariantes[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  title: Text(cliente.nomeCliente.toUpperCase()),  // Nome em maiúsculo
                                  subtitle: Text("Idade: ${cliente.idade} anos"),  // Exibindo a idade
                                  onTap: () {
                                    // Ação ao tocar no nome do cliente
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ClienteDetalhePage(cliente: cliente),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Certifique-se de que a tela de cadastro está sendo chamada corretamente
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClienteCadastroPage(),  // Chama a tela de cadastro diretamente
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[600],
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nome: ${cliente.nomeCliente.toUpperCase()}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("Data de Nascimento: ${cliente.dataNascimento}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("Telefone: ${cliente.telefone ?? "Não informado"}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("Atendente: ${cliente.atendente.toUpperCase()}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("Observações: ${cliente.observacoes ?? "Nenhuma observação"}", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
*/