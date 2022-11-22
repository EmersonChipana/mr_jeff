import 'package:flutter/material.dart';
import 'package:mr_jeff/main.dart';

// create a home page widget with bottom navigation bar
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
