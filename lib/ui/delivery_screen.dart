import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mr_jeff/cubit/pickup/al_pagestatus.dart';
import 'package:mr_jeff/cubit/pickup/pickup_cubit.dart';
import 'package:mr_jeff/cubit/pickup/pickup_state.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController comment = TextEditingController();
  late GoogleMapController googleMapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finaliza la solicitud'),
      ),
      body: BlocConsumer<PickUpCubit, PickUpState>(
        builder: (context, state) {
          return _newAddressForUser(context, state);
        },
        listener: (context, state) {
          if (state.status == PageStatus.verifying2) {
            BlocProvider.of<PickUpCubit>(context)
                .setPageState(PageStatus.success);
            _showDialog(context, 'Ingresando', 'Se esta creando la solicitud',
                false, () {});
          } else if (state.status == PageStatus.incorrectVerified2) {
            _showDialog(context, 'Error', state.errorMessage!, true, () {
              Navigator.of(context).pop();
            });
            BlocProvider.of<PickUpCubit>(context)
                .setPageState(PageStatus.success);
          } else if (state.status == PageStatus.correctVerified2) {
            _showDialog(
                context, 'THANK YOU', 'SE COMPLETO LA ORDEN EXITOSAMENTE', true,
                () {
              Navigator.popUntil(context, ModalRoute.withName('/home'));
              BlocProvider.of<PickUpCubit>(context)
                  .setPageState(PageStatus.success);
              BlocProvider.of<PickUpCubit>(context).setInitial();
            });
          } else if (state.status == PageStatus.failure) {
            Navigator.of(context).pop();
            _showDialog(context, 'No se pudo completar la solicitud',
                state.errorMessage!, true, () {
              Navigator.popUntil(context, ModalRoute.withName('/home'));
              BlocProvider.of<PickUpCubit>(context)
                  .setPageState(PageStatus.success);
              BlocProvider.of<PickUpCubit>(context).setInitial();
            });
          }
        },
      ),
    );
  }

  Widget _newAddressForUser(BuildContext context, PickUpState state) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text('Vendremos a dejar tu ropa'),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Fecha"),
              Text(
                  '${state.prePickUpInfoV2?.schedule[state.pointerDate].beautyDay}')
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Hora"),
              Text(
                  '${state.prePickUpInfoV2?.schedule[state.pointerDate].hours[state.pointerTime]} ')
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 230,
            child: BlocBuilder<PickUpCubit, PickUpState>(
              builder: (context, state) {
                if (state.pointerAddress == -1) {
                  return Container(
                    child: Column(
                      children: [
                        const Text(
                            'Parece que estas ingresando una nueva direccion'),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text('Agrega más informacion informacion'),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: _controller1,
                          decoration: const InputDecoration(
                              hintText: "Nombre que deseas asignar",
                              border: OutlineInputBorder()),
                        ),
                        const SizedBox(
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Dirección de entrega'),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                                '${state.prePickUpInfoV2?.address[state.pointerAddress].name}')
                          ],
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
                                icon: const Icon(Icons.location_on_rounded),
                                label: const Text('location'))
                          ],
                        ),
                      )
                    ],
                  );
                }
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            maxLength: 511,
            controller: comment,
            decoration: const InputDecoration(
                hintText: "Comentarios adicionales",
                border: OutlineInputBorder()),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    )
                  ]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 170,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: LatLng(state.coordinates['lat']!,
                            state.coordinates['lng']!),
                        zoom: 15),
                    markers: {
                      Marker(
                        markerId: const MarkerId('Marker'),
                        position: LatLng(state.coordinates['lat']!,
                            state.coordinates['lng']!),
                      )
                    },
                    zoomControlsEnabled: false,
                    mapType: MapType.normal,
                    onMapCreated: (GoogleMapController controller) {
                      googleMapController = controller;
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancelar")),
                ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<PickUpCubit>(context).endDeliveryRequest(
                          _controller1.text, _controller2.text, comment.text);
                    },
                    child: const Text("Continuar")),
              ],
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
