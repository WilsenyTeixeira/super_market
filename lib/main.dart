import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/page_principal.dart';
import 'componets/drawer_header.dart';
import 'pages/page_acougue.dart';
import 'pages/page_padaria.dart';
import 'pages/page_login.dart';
import 'pages/page_carrinho.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SuperMarket());
}

class SuperMarket extends StatelessWidget {
  const SuperMarket({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SuperMarket',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(
        isLogin: true,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.isLogin}) : super(key: key);
  final bool isLogin;
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  var currentPage = DrawerSections.home;

  @override
  Widget build(BuildContext context) {
    dynamic container;
    if (currentPage == DrawerSections.home) {
      container = const TelaPrincipal(
        title: "Tela Principal",
      );
    } else if (currentPage == DrawerSections.padaria) {
      container = const PadariaPage();
    } else if (currentPage == DrawerSections.acougue) {
      container = const AcouguePage();
    } else if (currentPage == DrawerSections.carrinho) {
      container = const CarrinhoPage();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text("Super Market"),
        actions: <Widget>[
          widget.isLogin
              ? IconButton(
                  icon: const Icon(Icons.login),
                  tooltip: 'Login',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Indo Para a Página de Login')));
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'Logout',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Logout Feito com Sucesso')));
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                ),
          /*IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logout Feito com Sucesso')));
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LoginPage(isLogout: true,),
                ),
              );
            },
          ),*/
          /*
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            tooltip: 'Carrinho de Compras',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CarrinhoPage(),
                ),
              );*/
          /*Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Carrinho de Compras'),
                    ),
                    body: const Center(
                      child: Text(
                        'Carrinho de Compras',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                },
              ));
            },
          ),*/
        ],
      ),
      body: container,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const MyHeaderDrawer(),
              myDrawerList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget myDrawerList() {
    return Container(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        // shows the list of menu drawer
        children: [
          menuItem(1, "Home", Icons.dashboard_outlined,
              currentPage == DrawerSections.home ? true : false),
          menuItem(2, "Padaria", Icons.people_alt_outlined,
              currentPage == DrawerSections.padaria ? true : false),
          menuItem(3, "Açougue", Icons.event,
              currentPage == DrawerSections.acougue ? true : false),
          menuItem(4, "Carrinho", Icons.shopping_cart,
              currentPage == DrawerSections.carrinho ? true : false),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.home;
            } else if (id == 2) {
              currentPage = DrawerSections.padaria;
            } else if (id == 3) {
              currentPage = DrawerSections.acougue;
            } else if (id == 4) {
              currentPage = DrawerSections.carrinho;
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum DrawerSections {
  home,
  padaria,
  acougue,
  carrinho,
}
