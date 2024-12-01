import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart'; // Importando o pacote de máscara
import '../bd/cliente_model.dart';
import '../bd/db_helper.dart';

class ClienteDetalhePageEdit extends StatefulWidget {
  final Cliente cliente;

  const ClienteDetalhePageEdit({Key? key, required this.cliente}) : super(key: key);

  @override
  _ClienteDetalhePageEditState createState() => _ClienteDetalhePageEditState();
}

class _ClienteDetalhePageEditState extends State<ClienteDetalhePageEdit> {
  late TextEditingController _nomeController;
  late TextEditingController _telefoneController;
  late TextEditingController _atendenteController;
  late TextEditingController _observacoesController;
  late TextEditingController _dataNascimentoController;
  late DateTime? _dataNascimento;

  final _maskFormatter = MaskTextInputFormatter(mask: '##/##/####', filter: { '#': RegExp(r'[0-9]') });

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.cliente.nomeCliente);
    _telefoneController = TextEditingController(text: widget.cliente.telefone ?? '');
    _atendenteController = TextEditingController(text: widget.cliente.atendente);
    _observacoesController = TextEditingController(text: widget.cliente.observacoes ?? '');
    _dataNascimentoController = TextEditingController(text: widget.cliente.dataNascimento == null
        ? '' : '${widget.cliente.dataNascimento?.day.toString().padLeft(2, '0')}/${widget.cliente.dataNascimento?.month.toString().padLeft(2, '0')}/${widget.cliente.dataNascimento?.year}');
    _dataNascimento = widget.cliente.dataNascimento;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    _atendenteController.dispose();
    _observacoesController.dispose();
    _dataNascimentoController.dispose();
    super.dispose();
  }

  // Função para formatar a observação (primeira letra maiúscula, restante conforme o usuário digitar)
  void _formatarObservacao(String texto) {
    setState(() {
      if (texto.isNotEmpty) {
        _observacoesController.text = texto[0].toUpperCase() + texto.substring(1);
        _observacoesController.selection = TextSelection.fromPosition(TextPosition(offset: _observacoesController.text.length));
      }
    });
  }

  // Função para forçar a transformação do texto em maiúsculas no campo de nome
  void _atualizarNome(String texto) {
    setState(() {
      _nomeController.text = texto.toUpperCase();
      _nomeController.selection = TextSelection.fromPosition(TextPosition(offset: _nomeController.text.length));
    });
  }

  // Função para forçar a transformação do texto em maiúsculas no campo de atendente
  void _atualizarAtendente(String texto) {
    setState(() {
      _atendenteController.text = texto.toUpperCase();
      _atendenteController.selection = TextSelection.fromPosition(TextPosition(offset: _atendenteController.text.length));
    });
  }

  void _salvarAlteracoes() async {
    if (_nomeController.text.isEmpty || _telefoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Por favor, preencha todos os campos obrigatórios!')));
      return;
    }

    Cliente clienteEditado = Cliente(
      id: widget.cliente.id,
      nomeCliente: _nomeController.text,
      telefone: _telefoneController.text,
      atendente: _atendenteController.text,
      observacoes: _observacoesController.text,
      dataNascimento: _dataNascimento,
      dataCadastro: widget.cliente.dataCadastro,
    );

    // Atualizar no banco de dados
    await DBHelper().atualizarCliente(clienteEditado);

    // Exibir a mensagem de sucesso
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cadastro Alterado com Sucesso')));

    // Esperar 2 segundos e depois fechar a tela
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context, true);
    });
  }

  void _atualizarDataNascimento(String valor) {
    if (valor.length == 10) {
      int dia = int.parse(valor.substring(0, 2));
      int mes = int.parse(valor.substring(3, 5));
      int ano = int.parse(valor.substring(6, 10));
      setState(() {
        _dataNascimento = DateTime(ano, mes, dia);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Editar Cliente'),
        backgroundColor: Colors.blue[600],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nome com letras maiúsculas
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome', border: OutlineInputBorder()),
              onChanged: _atualizarNome, // Garante que o nome seja sempre em maiúsculas
            ),
            SizedBox(height: 10),

            // Data de Nascimento
            TextField(
              controller: _dataNascimentoController,
              decoration: InputDecoration(
                labelText: 'Data de Nascimento',
                border: OutlineInputBorder(),
              ),
              inputFormatters: [_maskFormatter],
              keyboardType: TextInputType.number,
              onChanged: _atualizarDataNascimento,
            ),
            SizedBox(height: 10),

            // Telefone
            TextField(
              controller: _telefoneController,
              decoration: InputDecoration(labelText: 'Telefone', border: OutlineInputBorder()),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 10),

            // Atendente com letras maiúsculas
            TextField(
              controller: _atendenteController,
              decoration: InputDecoration(labelText: 'Atendente', border: OutlineInputBorder()),
              onChanged: _atualizarAtendente, // Garante que o atendente seja sempre em maiúsculas
            ),
            SizedBox(height: 10),

            // Observações com a primeira letra maiúscula, o restante conforme o usuário digitar
            TextField(
              controller: _observacoesController,
              decoration: InputDecoration(labelText: 'Observações', border: OutlineInputBorder()),
              maxLines: 3,
              onChanged: _formatarObservacao, // Formatar a observação conforme o usuário digita
            ),
            SizedBox(height: 20),

            // Row para adicionar os botões Salvar e Voltar, na mesma linha
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Espaço entre os botões
              children: [
                // Botão Salvar
                ElevatedButton(
                  onPressed: _salvarAlteracoes,
                  child: Text('Salvar', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600], // Cor do fundo do botão
                  ),
                ),

                // Botão Voltar (Cancelar)
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Fechar a tela atual
                  },
                  child: Text('Cancelar', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600], // Cor do botão igual ao "Salvar"
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
