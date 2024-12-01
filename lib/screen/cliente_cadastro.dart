import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart'; // Para mascarar o telefone
import '../bd/cliente_model.dart';
import '../bd/db_helper.dart';
import 'package:intl/intl.dart';  // Para formatar a data

class ClienteCadastroPage extends StatefulWidget {
  @override
  _ClienteCadastroPageState createState() => _ClienteCadastroPageState();
}

class _ClienteCadastroPageState extends State<ClienteCadastroPage> {
  final _formKey = GlobalKey<FormState>();  // Controlador do formulário

  // Controladores dos campos
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();
  TextEditingController _atendenteController = TextEditingController();
  TextEditingController _observacoesController = TextEditingController();
  TextEditingController _dataNascimentoController = TextEditingController();

  DateTime _dataCadastro = DateTime.now();  // Data do cadastro (data atual)

  // Mascara para o telefone
  var _telefoneMask = MaskTextInputFormatter(mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

  // Mascara para a data de nascimento (formato dd/MM/yyyy)
  var _dataNascimentoMask = MaskTextInputFormatter(mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

  final DBHelper _dbHelper = DBHelper();  // Instanciando o helper de banco de dados

  // Função para salvar o cliente no banco de dados
  Future<void> _salvarCliente() async {
    // Verifica se o formulário é válido
    if (_formKey.currentState!.validate()) {
      // Salva os dados do formulário
      _formKey.currentState!.save();

      // Cria um objeto Cliente com os dados fornecidos
      Cliente cliente = Cliente(
        nomeCliente: _nomeController.text.toUpperCase(),  // Nome do cliente em maiúsculas
        dataNascimento: _parseDate(_dataNascimentoController.text), // Convertendo a data corretamente
        telefone: _telefoneController.text.isEmpty ? null : _telefoneController.text,
        dataCadastro: _dataCadastro,
        atendente: _atendenteController.text.toUpperCase(),  // Nome do atendente em maiúsculas
        observacoes: _observacoesController.text.isEmpty ? null : _observacoesController.text,
      );

      // Chama o método inserirCliente para salvar o cliente no banco de dados
      await _dbHelper.inserirCliente(cliente);

      // Exibe uma mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cliente Cadastrado com Sucesso!')),
      );

      // Limpa os campos após o cadastro
      _nomeController.clear();
      _telefoneController.clear();
      _atendenteController.clear();
      _observacoesController.clear();
      _dataNascimentoController.clear();
      setState(() {
        _dataCadastro = DateTime.now();
      });
    }
  }

  // Função para fazer o parse da data de nascimento
  DateTime _parseDate(String dateStr) {
    try {
      // Usando o pacote intl para verificar e formatar a data
      final format = DateFormat('dd/MM/yyyy');
      return format.parseStrict(dateStr);
    } catch (e) {
      // Retorna null se a data for inválida
      return DateTime(1900); // Retorna uma data padrão caso seja inválida
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF005C99),  // Cor da AppBar ajustada
        title: Text('Cadastrar Cliente'),
      ),
      resizeToAvoidBottomInset: true, // Isso vai permitir que a tela seja ajustada quando o teclado aparecer
      body: SingleChildScrollView(  // Envolvendo tudo com o SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                // Nome do Cliente (campo obrigatório)
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: 'Nome do Cliente',
                    hintText: 'Digite o nome completo',
                    labelStyle: TextStyle(color: Color(0xFF005C99)), // Cor do label
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Color(0xFF005C99)), // Cor da borda
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome do cliente';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _nomeController.value = TextEditingValue(
                      text: value.toUpperCase(),
                      selection: TextSelection.collapsed(offset: value.length),
                    );
                  },
                ),
                SizedBox(height: 16),

                // Data de Nascimento (campo de digitação)
                TextFormField(
                  controller: _dataNascimentoController,
                  decoration: InputDecoration(
                    labelText: 'Data de Nascimento',
                    hintText: 'DD/MM/AAAA',
                    labelStyle: TextStyle(color: Color(0xFF005C99)), // Cor do label
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Color(0xFF005C99)), // Cor da borda
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    _dataNascimentoMask, // Aplica a máscara para a data
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a data de nascimento';
                    }
                    if (!_validarDataNascimento(value)) {
                      return 'Data inválida! Formato esperado: DD/MM/AAAA';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Telefone (opcional)
                TextFormField(
                  controller: _telefoneController,
                  decoration: InputDecoration(
                    labelText: 'Telefone',
                    hintText: 'Digite o telefone',
                    labelStyle: TextStyle(color: Color(0xFF005C99)), // Cor do label
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Color(0xFF005C99)), // Cor da borda
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [_telefoneMask],
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(height: 16),

                // Nome do Atendente (campo obrigatório)
                TextFormField(
                  controller: _atendenteController,
                  decoration: InputDecoration(
                    labelText: 'Atendente',
                    hintText: 'Nome do atendente',
                    labelStyle: TextStyle(color: Color(0xFF005C99)), // Cor do label
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Color(0xFF005C99)), // Cor da borda
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome do atendente';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _atendenteController.value = TextEditingValue(
                      text: value.toUpperCase(),
                      selection: TextSelection.collapsed(offset: value.length),
                    );
                  },
                ),
                SizedBox(height: 16),

                // Observações (campo opcional)
                TextFormField(
                  controller: _observacoesController,
                  decoration: InputDecoration(
                    labelText: 'Observações',
                    hintText: 'Sem Obs.',
                    labelStyle: TextStyle(color: Color(0xFF005C99)), // Cor do label
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Color(0xFF005C99)), // Cor da borda
                    ),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 24),

                // Botão para salvar o cliente
                ElevatedButton(
                  onPressed: _salvarCliente,
                  child: Text('Salvar Cliente'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Color(0xFF005C99), // Cor do texto no botão
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Função para validar a data de nascimento
  bool _validarDataNascimento(String data) {
    final partes = data.split('/');
    if (partes.length == 3) {
      final dia = int.tryParse(partes[0]);
      final mes = int.tryParse(partes[1]);
      final ano = int.tryParse(partes[2]);
      if (dia != null && mes != null && ano != null) {
        try {
          final dataFormatada = DateTime(ano, mes, dia);
          if (dataFormatada.year == ano && dataFormatada.month == mes && dataFormatada.day == dia) {
            return true;
          }
        } catch (e) {
          return false;
        }
      }
    }
    return false;
  }
}





/*import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart'; // Para mascarar o telefone
import '../bd/cliente_model.dart';
import '../bd/db_helper.dart';
import 'package:intl/intl.dart';  // Para formatar a data

class ClienteCadastroPage extends StatefulWidget {
  @override
  _ClienteCadastroPageState createState() => _ClienteCadastroPageState();
}

class _ClienteCadastroPageState extends State<ClienteCadastroPage> {
  final _formKey = GlobalKey<FormState>();  // Controlador do formulário

  // Controladores dos campos
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();
  TextEditingController _atendenteController = TextEditingController();
  TextEditingController _observacoesController = TextEditingController();
  TextEditingController _dataNascimentoController = TextEditingController();

  DateTime _dataCadastro = DateTime.now();  // Data do cadastro (data atual)

  // Mascara para o telefone
  var _telefoneMask = MaskTextInputFormatter(mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

  // Mascara para a data de nascimento (formato dd/MM/yyyy)
  var _dataNascimentoMask = MaskTextInputFormatter(mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

  final DBHelper _dbHelper = DBHelper();  // Instanciando o helper de banco de dados

  // Função para salvar o cliente no banco de dados
  Future<void> _salvarCliente() async {
    // Verifica se o formulário é válido
    if (_formKey.currentState!.validate()) {
      // Salva os dados do formulário
      _formKey.currentState!.save();

      // Cria um objeto Cliente com os dados fornecidos
      Cliente cliente = Cliente(
        nomeCliente: _nomeController.text.toUpperCase(),  // Nome do cliente em maiúsculas
        dataNascimento: _parseDate(_dataNascimentoController.text), // Convertendo a data corretamente
        telefone: _telefoneController.text.isEmpty ? null : _telefoneController.text,
        dataCadastro: _dataCadastro,
        atendente: _atendenteController.text.toUpperCase(),  // Nome do atendente em maiúsculas
        observacoes: _observacoesController.text.isEmpty ? null : _observacoesController.text,
      );

      // Chama o método inserirCliente para salvar o cliente no banco de dados
      await _dbHelper.inserirCliente(cliente);

      // Exibe uma mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cliente Cadastrado com Sucesso!')),
      );

      // Limpa os campos após o cadastro
      _nomeController.clear();
      _telefoneController.clear();
      _atendenteController.clear();
      _observacoesController.clear();
      _dataNascimentoController.clear();
      setState(() {
        _dataCadastro = DateTime.now();
      });
    }
  }

  // Função para fazer o parse da data de nascimento
  DateTime _parseDate(String dateStr) {
    try {
      // Usando o pacote intl para verificar e formatar a data
      final format = DateFormat('dd/MM/yyyy');
      return format.parseStrict(dateStr);
    } catch (e) {
      // Retorna null se a data for inválida
      return DateTime(1900); // Retorna uma data padrão caso seja inválida
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Nome do Cliente (campo obrigatório)
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome do Cliente',
                  hintText: 'Digite o nome completo',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do cliente';
                  }
                  return null;
                },
                onChanged: (value) {
                  _nomeController.value = TextEditingValue(
                    text: value.toUpperCase(),
                    selection: TextSelection.collapsed(offset: value.length),
                  );
                },
              ),
              SizedBox(height: 16),

              // Data de Nascimento (campo de digitação)
              TextFormField(
                controller: _dataNascimentoController,
                decoration: InputDecoration(
                  labelText: 'Data de Nascimento',
                  hintText: 'DD/MM/AAAA',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  _dataNascimentoMask, // Aplica a máscara para a data
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a data de nascimento';
                  }
                  if (!_validarDataNascimento(value)) {
                    return 'Data inválida! Formato esperado: DD/MM/AAAA';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Telefone (opcional)
              TextFormField(
                controller: _telefoneController,
                decoration: InputDecoration(
                  labelText: 'Telefone',
                  hintText: 'Digite o telefone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [_telefoneMask],
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: 16),

              // Nome do Atendente (campo obrigatório)
              TextFormField(
                controller: _atendenteController,
                decoration: InputDecoration(
                  labelText: 'Atendente',
                  hintText: 'Nome do atendente',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do atendente';
                  }
                  return null;
                },
                onChanged: (value) {
                  _atendenteController.value = TextEditingValue(
                    text: value.toUpperCase(),
                    selection: TextSelection.collapsed(offset: value.length),
                  );
                },
              ),
              SizedBox(height: 16),

              // Observações (campo opcional)
              TextFormField(
                controller: _observacoesController,
                decoration: InputDecoration(
                  labelText: 'Observações',
                  hintText: 'Digite observações (opcional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 24),

              // Botão para salvar o cliente
              ElevatedButton(
                onPressed: _salvarCliente,
                child: Text('Salvar Cliente'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função para validar a data de nascimento
  bool _validarDataNascimento(String data) {
    final partes = data.split('/');
    if (partes.length == 3) {
      final dia = int.tryParse(partes[0]);
      final mes = int.tryParse(partes[1]);
      final ano = int.tryParse(partes[2]);
      if (dia != null && mes != null && ano != null) {
        try {
          final dataFormatada = DateTime(ano, mes, dia);
          if (dataFormatada.year == ano && dataFormatada.month == mes && dataFormatada.day == dia) {
            return true;
          }
        } catch (e) {
          return false;
        }
      }
    }
    return false;
  }
}
*/