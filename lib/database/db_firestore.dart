import 'dart:async';
import 'package:super_market/colecao_firebase/produto.dart';
import 'package:super_market/colecao_firebase/usuario.dart';
import 'package:super_market/colecao_firebase/carrinho.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'globals.dart' as globals;

class Database {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  incluir(Produto p) {
    final produto = <String, dynamic>{
      "categoria": p.categoria,
      "nome": p.nome,
      "preco": p.preco,
      "promocao": p.promocao,
      "quantidade": p.quantidade
    };
    firestore.collection("produtos").add(produto);
  }

  Future<void> editar(String id, Produto p) async {
    final produto = <String, dynamic>{
      "categoria": p.categoria,
      "nome": p.nome,
      "preco": p.preco,
      "promocao": p.promocao,
      "quantidade": p.quantidade
    };
    try {
      await firestore.collection("produtos").doc(id).update(produto);
    } catch (e) {
      //print(e);
    }
  }

  excluir(String id) {
    firestore.collection("produtos").doc(id).delete();
  }

  Future<List> listar() async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot =
          await firestore.collection('produtos').orderBy("nome").get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "categoria": doc['categoria'],
            "nome": doc["nome"],
            "preco": doc["preco"],
            "promocao": doc["promocao"],
            "quantidade": doc["quantidade"]
          };
          docs.add(a);
        }
      }
    } catch (e) {
      //print(e);
    }
    return docs;
  }

  Future<List> listarPadaria() async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot = await firestore
          .collection('produtos')
          .orderBy("nome")
          .where('categoria', isEqualTo: 'padaria')
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "categoria": doc['categoria'],
            "nome": doc["nome"],
            "preco": doc["preco"],
            "promocao": doc["promocao"],
            "quantidade": doc["quantidade"]
          };
          docs.add(a);
        }
      }
    } catch (e) {
      //print(e);
    }
    return docs;
  }

  Future<List> listarPromocao() async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot = await firestore
          .collection('produtos')
          .orderBy("nome")
          .where('promocao', isEqualTo: true)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "categoria": doc['categoria'],
            "nome": doc["nome"],
            "preco": doc["preco"],
            "promocao": doc["promocao"],
            "quantidade": doc["quantidade"]
          };
          docs.add(a);
        }
      }
    } catch (e) {
      //print(e);
    }
    return docs;
  }

  Future<List> listarAcougue() async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot = await firestore
          .collection('produtos')
          .orderBy("nome")
          .where('categoria', isEqualTo: 'acougue')
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "categoria": doc['categoria'],
            "nome": doc["nome"],
            "preco": doc["preco"],
            "promocao": doc["promocao"],
            "quantidade": doc["quantidade"]
          };
          docs.add(a);
        }
      }
    } catch (e) {
      //print(e);
    }
    return docs;
  }

  Future<List> listarDestaques() async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot =
          await firestore.collection('destaques').orderBy('nome').get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "nome": doc['nome'],
            "img": doc['img'],
          };
          docs.add(a);
        }
      }
    } catch (e) {
      //print(e);
    }
    return docs;
  }

  Future<bool> validarUsuario(Usuario u) async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot = await firestore
          .collection('usuarios')
          .where('senha', isEqualTo: u.senha)
          .where('email', isEqualTo: u.email)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "email": doc['email'],
            "senha": doc['senha'],
          };
          docs.add(a);
        }
      }
    } catch (e) {
      //print(e);
    }
    if (docs.isNotEmpty) {
      globals.idCliente = docs[0]["id"];
      globals.isLoggedIn = true;
    }

    return (docs.isNotEmpty);
  }

  incluirUsuario(Usuario u) {
    final usuario = <String, dynamic>{
      "email": u.email,
      "senha": u.senha,
    };
    firestore.collection("usuarios").add(usuario).then(
        (DocumentReference doc) =>
            {globals.idCliente = doc.id, globals.isLoggedIn = true});
  }

  Future<void> atualizarProduto(String id, Produto p) async {
    final produto = <String, dynamic>{
      "categoria": p.categoria,
      "nome": p.nome,
      "preco": p.preco,
      "promocao": p.promocao,
      "quantidade": p.quantidade
    };
    try {
      await firestore.collection("produtos").doc(id).update(produto);
    } catch (e) {
      //print(e);
    }
  }

  colocarProdutoCarrinho(Carrinho c) {
    final carrinho = <String, dynamic>{
      "idCliente": c.idCliente,
      "idProduto": c.idProduto,
    };
    firestore.collection("carrinhos").add(carrinho);
  }

  Future<List> listarCarrinho(String idCliente) async {
    QuerySnapshot querySnapshot;
    List docs = [];
    List produtos = [];
    if (idCliente == '') {
      return produtos;
    }
    try {
      querySnapshot = await firestore
          .collection('carrinhos')
          .where('idCliente', isEqualTo: idCliente)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "idProduto": doc['idProduto'],
          };
          docs.add(a);
        }
        for (var i = 0; i < docs.length; i++) {
          try {
            DocumentSnapshot resultado = await firestore
                .collection('produtos')
                .doc(docs[i]['idProduto'])
                .get();

            Map produto = {
              "id": resultado.id,
              "categoria": resultado['categoria'],
              "nome": resultado["nome"],
              "preco": resultado["preco"],
              "promocao": resultado["promocao"],
              "quantidade": resultado["quantidade"]
            };
            produtos.add(produto);

            //print(produtos);
          } catch (e) {
            //print(e);
          }
        }
      }
    } catch (e) {
      //print(e);
    }
    return produtos;
  }

  Future<bool> deletarTodosCarrinhosByCliente(String idCliente) async {
    QuerySnapshot querySnapshot;
    try {
      querySnapshot = await firestore
          .collection('carrinhos')
          .where('idCliente', isEqualTo: idCliente)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          firestore
              .collection("carrinhos")
              .doc(doc.id)
              .delete();
        }
        return true;
      }
    } catch (e) {
      //print(e);
      return false;
    }
    return false;
  }
}
