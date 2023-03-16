import 'package:flutter/material.dart';
import 'package:super_market/database/db_firestore.dart';
import 'package:super_market/colecao_firebase/carrinho.dart';

class PadariaPage extends StatefulWidget {
  const PadariaPage({super.key});

  @override
  State<PadariaPage> createState() => _PadariaPageState();
}

class _PadariaPageState extends State<PadariaPage> {
  late Database db;
  List docs = [];

  initialise() {
    db = Database();
    db.initiliase();
    db.listarPadaria().then((value) => {
          setState(() {
            docs = value;
          })
        });
  }

  @override
  void initState() {
    super.initState();
    initialise();
  }

  void _colocarProdutoCarrinho(c) {
    db.colocarProdutoCarrinho(c);
    initialise();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      child: Center(
        child: Expanded(
          child: SizedBox(
            height: 150,
            child: ListView.builder(
              shrinkWrap: true,
              addAutomaticKeepAlives: false,
              scrollDirection: Axis.horizontal,
              itemCount: docs.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 200,
                  width: 300,
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      onTap: () {
                        Carrinho carrinho =
                            Carrinho('EdU93fDlPVMac06ik8Is', docs[index]['id']);
                        _colocarProdutoCarrinho(carrinho);
                        //print("docs[index]---> $docs[index]['id']");
                        /*Map<String, String> produto() => {
                      "id": docs[index]['id'],
                      "acategoria": docs[index]['categoria'],
                      "nome": docs[index]['nome'],
                      "preco": docs[index]['preco'],
                      "promocao": docs[index]['promocao'],
                      "quantidade": docs[index]['quantidade'],
                    };
                _colocarCarrinho(produto());*/
                      },
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
        ),
      ),
    ));
  }
}
