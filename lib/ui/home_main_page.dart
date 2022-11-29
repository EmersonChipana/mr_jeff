import 'package:flutter/material.dart';
import 'package:mr_jeff/main.dart';

// create a home page widget with bottom navigation bar
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Side menu'),
      ),
      drawer: NavDrawer(),
      body: Center(
        // brief description of a company
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 70,
              ),
              //Image.network('https://wp.jeff.com/wp-content/uploads/2020/04/logo-jeff-1.png'),
              Image(
                image: NetworkImage(
                    'https://wp.jeff.com/wp-content/uploads/2020/04/logo-jeff-1.png'),
                width: 200,
                height: 200,
              ),
              const SizedBox(
                height: 5,
              ),
              Image(
                image: NetworkImage(
                    'https://lavarmiropa.com/wp-content/uploads/2021/06/Mr-Jeff_Illustrations_-09.png'),
                width: 250,
                height: 250,
              ),
              const Text(
                'Bienvenido a Mr Jeff',
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'La mejor opción para tu lavado',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                '¿Qué deseas hacer?',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
            ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: 'Catálogo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.amber[800],
      ),
    );
  }
}

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Side menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        'https://enmicasa.com/wp-content/uploads/2013/04/La-lavanderi%CC%81a.jpg'))),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Solicitar un pickup'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/prepickupv2');
            },
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Productos'),
            onTap: () => {
              Navigator.of(context).pop(),
              Navigator.pushNamed(context, '/clothings')
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('PreDelivery'),
            onTap: () => {
              Navigator.of(context).pop(),
              Navigator.pushNamed(context, '/preDelivery')
            },
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
              leading: Icon(Icons.border_color),
              title: Text("PICKUP V2"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/prepickupv2');
              }),
          ListTile(
              leading: Icon(Icons.border_color),
              title: Text("Ver courier operations"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/workerDiaryV2');
              })
        ],
      ),
    );
  }
}
