import 'package:flutter/material.dart';

void main() {
  runApp(EstoqueApp());
}

class EstoqueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle de Estoque',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class Produto {
  String nome;
  int quantidade;

  Produto({required this.nome, required this.quantidade});
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Produto> produtos = [];
  final nomeController = TextEditingController();
  final qtdController = TextEditingController();

  void adicionarProduto() {
    String nome = nomeController.text.trim();
    int qtd = int.tryParse(qtdController.text.trim()) ?? 0;

    if (nome.isNotEmpty && qtd > 0) {
      setState(() {
        produtos.add(Produto(nome: nome, quantidade: qtd));
      });
      nomeController.clear();
      qtdController.clear();
    }
  }

  void removerProduto(int index) {
    setState(() {
      produtos.removeAt(index);
    });
  }

  Widget produtoItem(Produto produto, int index) {
    bool estoqueBaixo = produto.quantidade < 5;
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          estoqueBaixo ? Icons.warning_amber_rounded : Icons.inventory_2,
          color: estoqueBaixo ? Colors.redAccent : Colors.deepPurple,
          size: 30,
        ),
        title: Text(produto.nome, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          'Quantidade: ${produto.quantidade}',
          style: TextStyle(color: estoqueBaixo ? Colors.red : Colors.grey[700]),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.grey[700]),
          onPressed: () => removerProduto(index),
        ),
      ),
    );
  }

  Widget campoInput(String label, TextEditingController controller,
      {TextInputType? tipo}) {
    return TextField(
      controller: controller,
      keyboardType: tipo,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Controle de Estoque'),
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            campoInput('Nome do Produto', nomeController),
            SizedBox(height: 10),
            campoInput('Quantidade', qtdController, tipo: TextInputType.number),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text('Adicionar Produto'),
                onPressed: adicionarProduto,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: produtos.isEmpty
                  ? Center(child: Text('Nenhum produto adicionado.',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600])))
                  : ListView.builder(
                      itemCount: produtos.length,
                      itemBuilder: (context, index) => produtoItem(produtos[index], index),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
