import 'package:mr_jeff/cubit/login/login_cubit.dart';
import 'package:mr_jeff/cubit/login/login_state.dart';
import 'package:mr_jeff/cubit/login/page_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widget/dialogs.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext ctx1) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Inicio de Sesión"),
            centerTitle: true,
            backgroundColor: Colors.black,
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context)),
          ),
          body: BlocConsumer<LoginCubit, LoginState>(
            listener: (ctx3, state) {
              if (state.status == PageStatus.loading) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const MyLoadingWidget(
                          title: 'Verificando sus credenciales');
                    });
              } else if (state.status == PageStatus.success &&
                  state.loginSuccess) {
                Navigator.pop(ctx3);
                Navigator.pushNamed(ctx3, '/home');
              } else {
                Navigator.pop(ctx3);
                _showDialog(context, "Error", state.errorMessage!, true);
              }
            },
            builder: (context, state) => Center(child: formLogin(context)),
          )),
    );
  }

  Widget formLogin(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Inicio de sesión", style: TextStyle(fontSize: 30)),
        const SizedBox(height: 50),
        Container(
          margin: const EdgeInsets.all(10),
          child: TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              hintText: "Usuario",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(10),
          child: TextField(
            controller: _passwordController,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: "Contraseña",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
            onPressed: () {
              BlocProvider.of<LoginCubit>(context)
                  .login(_usernameController.text, _passwordController.text);
            },
            child: const Text("Iniciar Sesión")),
      ],
    );
  }

  Future<void> _showDialog(BuildContext context, String title, String message,
      bool closeable) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            closeable
                ? TextButton(
                    child: const Text('Cerrar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                : Container(),
          ],
        );
      },
    );
  }
}
