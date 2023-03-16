import 'dart:async';
import 'package:super_market/colecao_firebase/produto.dart';
import 'package:super_market/colecao_firebase/usuario.dart';
import 'package:super_market/colecao_firebase/carrinho.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    //.then((DocumentReference doc) =>print('DocumentSnapshot added with ID: ${doc.id}'));
  }

  Future<void> editar(String id, Produto p) async {
    //print("id -----> $id");
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
    return (docs.isNotEmpty);
  }

  incluirUsuario(Usuario u) {
    final usuario = <String, dynamic>{
      "email": u.email,
      "senha": u.senha,
    };
    firestore.collection("usuarios").add(usuario);
    //.then((DocumentReference doc) =>print('DocumentSnapshot added with ID: ${doc.id}'));
  }

  Future<void> atualizarProduto(String id, Produto p) async {
    //print("id -----> $id");
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
    //.then((DocumentReference doc) => print('DocumentSnapshot added with ID: ${doc.id}'));
  }

  Future<List> listarCarrinho(String idCliente) async {
    QuerySnapshot querySnapshot;
    List docs = [];
    List produtos = [];
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
    //print("Cheguei no deletar");
    QuerySnapshot querySnapshot;
    try {
      querySnapshot = await firestore
          .collection('carrinhos')
          .where('idCliente', isEqualTo: idCliente)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        //print("query to list");
        //print(querySnapshot.docs.toList());
        for (var doc in querySnapshot.docs.toList()) {
          firestore.collection("carrinhos").doc(doc.id).delete();//.then((value) => print("deletado com sucesso!"));
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
