import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_jeff/cubit/pickup/prepickup/prepickup_state.dart';
import 'package:mr_jeff/cubit/pickup/prepickup/prepickup_cubit.dart';
import 'package:mr_jeff/cubit/pickup/pickup_page_status.dart';

class PickUpPage extends StatefulWidget {
  const PickUpPage({Key? key}) : super(key: key);

  @override
  State<PickUpPage> createState() => _PickUpPageState();
}

class _PickUpPageState extends State<PickUpPage> {
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finaliza la solicitud'),
      ),
      body: BlocConsumer<PrePickupCubit, PrePickupState>(
        builder: (context, state) {
          return _newAddressForUser(context, state);
        },
        listener: (context, state) {
          if (state.status == PageStatus.verifying2) {
            print(' 1 ----------> pagestatus.verifying2');
            BlocProvider.of<PrePickupCubit>(context)
                .setPageState(PageStatus.success);
            _showDialog(context, 'Ingresando', 'Se esta creando la solicitud',
                false, () {});
          } else if (state.status == PageStatus.incorrectVerified2) {
            print(' 1 ----------> pagestatus.incorrectVerified2');
            _showDialog(context, 'Error', state.errorMessage!, true, () {
              Navigator.of(context).pop();
            });
            BlocProvider.of<PrePickupCubit>(context)
                .setPageState(PageStatus.success);
          } else if (state.status == PageStatus.correctVerified2) {
            print(' 1 ----------> pagestatus.correctVerified');
            _showDialog(
                context, 'THANK YOU', 'SE CREO EL PICK UP EXITOSAMENTE', true,
                () {
              print('pageStatus.correctvVerified');
              Navigator.popUntil(context, ModalRoute.withName('/home'));
              BlocProvider.of<PrePickupCubit>(context)
                  .setPageState(PageStatus.success);
              BlocProvider.of<PrePickupCubit>(context).setInitial();
            });

            //Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
      ),
    );
  }

  Widget _newAddressForUser(BuildContext context, PrePickupState state) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text('Vendremos para recoger tu ropa'),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Fecha"),
              Text(
                  '${state.prePickUpInfo!.finalListTime[state.pointerDate].dia.getNameDayAndDate()}')
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Hora"),
              Text(
                  '${state.prePickUpInfo!.finalListTime[state.pointerDate].horas[state.pointerTime].getStringTimeFormat()} ')
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: BlocBuilder<PrePickupCubit, PrePickupState>(
              builder: (context, state) {
                if (state.pointerAddress == -1) {
                  return Container(
                    child: Column(
                      children: [
                        Text('Parece que estas ingresando una nueva direccion'),
                        SizedBox(
                          height: 20,
                        ),
                        Text('Agrega más informacion informacion'),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: _controller1,
                          decoration: const InputDecoration(
                              hintText: "Nombre que deseas asignar",
                              border: OutlineInputBorder()),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: _controller2,
                          decoration: const InputDecoration(
                              hintText: "Detalles que quieras agregar",
                              border: OutlineInputBorder()),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text('Dirección de entrega'),
                            SizedBox(
                              height: 20,
                            ),
                            Text(state.prePickUpInfo!
                                .finalListAddress[state.pointerAddress].name)
                          ],
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.location_on_rounded),
                                label: Text('location'))
                          ],
                        ),
                      )
                    ],
                  );
                }
              },
            ),
          ),
          Container(
            child: Container(
              color: Colors.pink,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancelar")),
                  ElevatedButton(
                      onPressed: () {
                        print(state.toString());
                        print(_controller2.text);
                        print(_controller1.text);

                        BlocProvider.of<PrePickupCubit>(context)
                            .endPickUpRequest(
                                _controller1.text, _controller2.text);
                      },
                      child: const Text("Continuar")),
                ],
              ),
            ),
          )
        ],
      ),
    );
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
                    onPressed: callback,
                  )
                : Container(),
          ],
        );
      },
    );
  }
}
