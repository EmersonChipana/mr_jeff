import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_jeff/cubit/login/page_status.dart';
import 'package:mr_jeff/cubit/sign/sign_cubit.dart';
import 'package:mr_jeff/cubit/sign/sign_state.dart';
import 'package:mr_jeff/widget/simple_loading_dialog.dart';

class CodeNewUserScreen extends StatefulWidget {
  const CodeNewUserScreen({super.key});

  @override
  State<CodeNewUserScreen> createState() => _CodeNewUserScreenState();
}

class _CodeNewUserScreenState extends State<CodeNewUserScreen> {
  final SignCubit _signCubit = SignCubit();
  final _codeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignCubit, SignState>(listener: (context, state) {
      if (state.status == PageStatus.checking) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return MyLoadingWidget(title: 'Verificando su codigo');
            });
        // _showDialog(context, 'Ingresando', 'Se esta creando la solicitud',
        //       false, () {});
      } else if (state.status == PageStatus.badcheck) {
        Navigator.pop(context);
        _showDialog(context, '', 'Lo sentimos, no pudimos verificar su codigo',
            true, () {});
      } else if (state.status == PageStatus.goodcheck) {
        Navigator.pop(context);

        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog( 
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Registrado exitosamente'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                        child: const Text('Cerrar'),
                        // onPressed: () {
                        //   Navigator.of(context).pop();
                        // },
                        onPressed: () {
                         Navigator.popUntil(context, ModalRoute.withName('/'));
                        },
                      )
              ],
            );
          },
        );
      }
    }, builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Codigo nuevo usuario'),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                      'Por favor introduce el código que se envio al correo electronico que ingresaste'),
                ),
                TextFormField(
                  controller: _codeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Codigo',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_codeController.text.trim().isEmpty) {
                        _showDialog(context, 'Revisar',
                            'Por favor ingrese un codigo', true, () {});
                      } else {
                        BlocProvider.of<SignCubit>(context)
                            .ingresaConToken(_codeController.text.trim());
                        print(state.newUser);
                      }

                      //Navigator.pushNamed(context, "/");
                    },
                    child: const Text('Enviar')),
              ]),
        ),
      );
    });
  }

  Future<void> _showDialog(BuildContext context, String title, String message,
      bool closeable, VoidCallback callback) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
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
                    // onPressed: () {
                    //   Navigator.of(context).pop();
                    // },
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
