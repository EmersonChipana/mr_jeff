import 'package:flutter/material.dart';

class IndexScreen extends StatelessWidget {
  /// Creates a [IndexScreen].
  const IndexScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 70,
              ),
              //Image.network('https://wp.jeff.com/wp-content/uploads/2020/04/logo-jeff-1.png'),
              const Image(
                image: NetworkImage(
                    'https://wp.jeff.com/wp-content/uploads/2020/04/logo-jeff-1.png'),
                width: 200,
                height: 200,
              ),
              const SizedBox(
                height: 100,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/");
                  },
                  child: const Text('Inicio de Sesión')),
              const SizedBox(
                height: 100,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/");
                },
                child: const Text('Registrarse'),
              ),
            ],
          ),
        ),
      );
}
