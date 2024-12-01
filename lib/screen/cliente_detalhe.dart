import 'package:flutter/material.dart';
import '../bd/cliente_model.dart';

class ClienteDetalhePage extends StatelessWidget {
  final Cliente cliente;

  const ClienteDetalhePage({Key? key, required this.cliente}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Cliente'),
        backgroundColor: Colors.blue[600],  // Cor similar à home_page
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cliente.nomeCliente,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[600],  // Cor do texto similar ao AppBar
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Data de Nascimento: ${_formatarData(cliente.dataNascimento)}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Telefone: ${cliente.telefone ?? 'Não informado'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Data de Cadastro: ${_formatarData(cliente.dataCadastro)}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Atendente: ${cliente.atendente}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Observações: ${cliente.observacoes ?? 'Não há observações'}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Coloque a ação desejada para o botão aqui
        },
        child: Icon(Icons.edit),
        backgroundColor: Colors.green[600], // Cor verde para manter o padrão da home_page
      ),
    );
  }

  String _formatarData(DateTime? data) {
    if (data == null) return 'Data não informada';
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }
}
