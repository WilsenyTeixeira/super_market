import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:super_market/database/db_firestore.dart';
import 'package:super_market/colecao_firebase/carrinho.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TelaPrincipal> createState() => _TelaPrincipal();
}

class _TelaPrincipal extends State<TelaPrincipal> {
  late Database db;
  List docs = [];
  List docsDestaques = [];
  initialise() {
    db = Database();
    db.initiliase();
    db.listarPromocao().then((value) => {
          setState(() {
            docs = value;
          })
        });
    db.listarDestaques().then((value) => {
          setState(() {
            docsDestaques = value;
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
      body: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 1,
          child: Column(
            children: [
              Expanded(
                  child: FractionallySizedBox(
                widthFactor: 1,
                heightFactor: 1,
                child: Container(
                    alignment: Alignment.topCenter,
                    child: CarouselSlider.builder(
                      itemCount: docsDestaques.length,
                      options: CarouselOptions(
                        height: 300,
                        autoPlay: true,
                      ),
                      itemBuilder: (context, index, realIndex) {
                        return FractionallySizedBox(
                          widthFactor: 1,
                          heightFactor: 1,
                          child: Card(
                            child: Text(docsDestaques[1]['nome']),
                          ),
                        );
                      },
                    )),
              )),
              const SizedBox(
                  height: 30,
                  width: 1000,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("PRODUTOS EM PROMOÇÃO"),
                  )),
              Expanded(
                child: SizedBox(
                    height: 150,
                    child: SafeArea(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
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
                                  Carrinho carrinho = Carrinho(
                                      'EdU93fDlPVMac06ik8Is',
                                      docs[index]['id']);
                                  /*
                                  Map<String, String> produto() => {
                                        "id": docs[index]['id'],
                                        "categoria": docs[index]['categoria'],
                                        "nome": docs[index]['nome'],
                                        "preco": docs[index]['preco'].toString(),
                                        "promocao": docs[index]['promocao'].toString(),
                                        "quantidade": docs[index]['quantidade'].toString(),*/
                                  /*"quantidade":
                                            (docs[index]['quantidade'] - 1).toString(),
                                      };*/
                                  _colocarProdutoCarrinho(carrinho);
                                },
                                contentPadding:
                                    const EdgeInsets.only(right: 30, left: 36),
                                title: Text(docs[index]['nome']),
                                trailing:
                                    Text("Preço: ${docs[index]['preco']}"),
                                subtitle: Text(
                                    "Quantidade: ${docs[index]['quantidade']}"),
                              ),
                            ),
                          );
                        },
                      ),
                    )),
              ),
            ],
          )),
    );
  }
}
