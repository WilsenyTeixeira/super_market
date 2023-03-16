import 'package:flutter/material.dart';
import 'package:super_market/colecao_firebase/produto.dart';
import 'package:super_market/database/db_firestore.dart';

class CarrinhoPage extends StatefulWidget {
  const CarrinhoPage({super.key});

  @override
  State<CarrinhoPage> createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
  late Database db;
  num valorTotal = 0;
  List docs = [];

  initialise() {
    docs = [];
    valorTotal = 0;
    db = Database();
    db.initiliase();
    /*db.listarPadaria().then((value) => {
          setState(() {
            docs = value;
          })
        });
    */
    db.listarCarrinho('EdU93fDlPVMac06ik8Is').then((value) => {
          setState(() {
            docs = value;
            valorTotal = valorTotalCompra();
            //print("listar carrinho");
            //print(valorTotal.runtimeType);
          })
        });

    /*setState(() {
      valorTotal = valorTotalCompra();
    });*/
  }

  @override
  void initState() {
    super.initState();
    initialise();
  }

  num valorTotalCompra() {
    for (var produto in docs) {
      //print("Olá, entrei no valor toltalcompra");
      //print(produto['preco']);
      //print(produto['preco'].runtimeType);
      valorTotal += num.parse(produto['preco'].toString());
      //print(valorTotal);
    }
    return valorTotal;
  }

  void _comprarProdutos() async{
    if (await db.deletarTodosCarrinhosByCliente('EdU93fDlPVMac06ik8Is')) {
      for (var produto in docs) {
        produto['quantidade'] -= 1;
        //print("contrução");
        //print(produto['quantidade']);
        //print(produto['quantidade'].runtimeType);
        Produto produtoAuxiliar = Produto(
            produto['nome'],
            produto['categoria'],
            num.parse(produto['preco'].toString()),
            produto['promocao'],
            num.parse(produto['quantidade'].toString()));
        db.atualizarProduto(produto['id'], produtoAuxiliar);
      }
    }
    initialise();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: [
          SizedBox(
            height: 500,
            child: ListView.builder(
              shrinkWrap: true,
              addAutomaticKeepAlives: false,
              itemCount: docs.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 100,
                  width: 300,
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      /*onTap: () {
                        //print("docs[index]---> $docs[index]['id']");
                        Map<String, String> produto() => {
                              "id": docs[index]['id'],
                              "acategoria": docs[index]['categoria'],
                              "nome": docs[index]['nome'],
                              "preco": docs[index]['preco'],
                              "promocao": docs[index]['promocao'],
                              "quantidade": docs[index]['quantidade'],
                            };
                        _colocarCarrinho(produto());
                      },*/
                      contentPadding:
                          const EdgeInsets.only(right: 30, left: 36),
                      title: Text(docs[index]['nome']),
                      trailing: Text(docs[index]['preco'].toString()),
                      subtitle: Text(docs[index]['quantidade'].toString()),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: 100,
            height: 40,
            child: Text("Preço ${valorTotal.toString()}"),
          ),
          SizedBox(
            width: 100,
            height: 40,
            child: IconButton(
                onPressed: _comprarProdutos, icon: const Icon(Icons.check)),
          ),
        ]),
      ),
    );
  }
}
