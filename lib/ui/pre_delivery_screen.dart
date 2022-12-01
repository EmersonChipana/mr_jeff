import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mr_jeff/cubit/pickup/al_pagestatus.dart';
import 'package:mr_jeff/cubit/pickup/pickup_cubit.dart';
import 'package:mr_jeff/cubit/pickup/pickup_state.dart';
import 'package:mr_jeff/widget/dialogs.dart';

class PreDeliveryScreen extends StatefulWidget {
  const PreDeliveryScreen({super.key});

  @override
  State<PreDeliveryScreen> createState() => _PreDeliveryScreenState();
}

class _PreDeliveryScreenState extends State<PreDeliveryScreen> {
  final Set<Marker> _markers = <Marker>{};
  final ScrollController _scrollController = ScrollController();
  late GoogleMapController googleMapController;

  @override
  void initState() {
    context.read<PickUpCubit>().setPointerAddress(-1);
    context.read<PickUpCubit>().init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planifica tu entrega'),
      ),
      body: BlocConsumer<PickUpCubit, PickUpState>(
        listener: (BuildContext ctx3, PickUpState state) {
          if (state.status == PageStatus.verifying) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const MyLoadingWidget(
                      title:
                          'Verificando si el servicio esta disponible en la ubicación seleccionada');
                });
          } else if (state.status == PageStatus.correctVerified) {
            Navigator.pop(ctx3);
            BlocProvider.of<PickUpCubit>(context)
                .setPageState(PageStatus.success);
            Navigator.pushNamed(ctx3, '/delivery');
          } else if (state.status == PageStatus.incorrectVerified) {
            Navigator.pop(ctx3);

            _showDialog(context, "Lo sentimos", state.errorMessage!, true);
            BlocProvider.of<PickUpCubit>(context)
                .setPageState(PageStatus.success);
          }
        },
        builder: (BuildContext context, PickUpState state) {
          if (state.status == PageStatus.loading) {
            return const MyLoadingWidget(title: 'Recopilando tu información');
          } else if (state.status == PageStatus.failure) {
            return Center(
              child: Text('Fallo algo ${state.errorMessage} '),
            );
          } else {
            return _showMapAndTimes(state, context);
          }
        },
      ),
    );
  }

  Widget _showMapAndTimes(PickUpState state, BuildContext context) {
    return Column(
      children: [
        _map(state, context),
        _schedules(state, context),
        Container(
          height: MediaQuery.of(context).size.height * 0.07,
          color: Colors.transparent,
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
                    print("Estado pre: ${state.status}");
                    BlocProvider.of<PickUpCubit>(context).passToOtherPage();
                  },
                  child: const Text("Continuar")),
            ],
          ),
        )
      ],
    );
  }

  Widget _schedules(PickUpState state, BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      color: Color.fromRGBO(147, 147, 147, 1),
      child: Row(
        children: [
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                padding: const EdgeInsets.all(5),
                shrinkWrap: true,
                itemCount: state.prePickUpInfoV2!.schedule.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      BlocProvider.of<PickUpCubit>(context)
                          .setNewDatePointer(index);

                      if (index != state.pointerDate) {
                        _scrollController
                            .jumpTo(_scrollController.position.minScrollExtent);
                        BlocProvider.of<PickUpCubit>(context)
                            .setNewTimePointer(0);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 0.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: state.pointerDate == index
                            ? const Color.fromRGBO(164, 243, 129, 1)
                            : Colors.white,
                      ),
                      height: 40,
                      child: Center(
                          child: Text(
                              '${state.prePickUpInfoV2?.schedule[index].beautyDay}')),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                padding: const EdgeInsets.all(5),
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: state
                    .prePickUpInfoV2!.schedule[state.pointerDate].hours.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      BlocProvider.of<PickUpCubit>(context)
                          .setNewTimePointer(index);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 0.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: state.pointerTime == index
                            ? const Color.fromRGBO(129, 227, 243, 1)
                            : Colors.white,
                      ),
                      height: 40,
                      child: Center(
                          child: Text(
                              '${state.prePickUpInfoV2?.schedule[state.pointerDate].hours[index]}')),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _map(PickUpState state, BuildContext context) {
    return Expanded(
        child: Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
              target: LatLng(-16.503314700752497, -68.13009178852836),
              zoom: 10),
          markers: _markers,
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            googleMapController = controller;
          },
          onTap: (point) {
            BlocProvider.of<PickUpCubit>(context).setPointerAddress(-1);
            BlocProvider.of<PickUpCubit>(context).setCoordinates(
                {'lat': point.latitude, 'lng': point.longitude});
            setState(() {
              _markers.clear();
              _markers.add(Marker(markerId: MarkerId('SAME'), position: point));
            });
          },
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: FloatingActionButton(
            heroTag: 'btn1',
            child: Icon(Icons.location_on),
            onPressed: () async {
              Position position = await _determinePosition();

              googleMapController.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(position.latitude, position.longitude),
                      zoom: 14)));

              setState(() {
                _markers.clear();
                _markers.add(Marker(
                    markerId: MarkerId('SAME'),
                    position: LatLng(position.latitude, position.longitude)));
              });
              BlocProvider.of<PickUpCubit>(context).setCoordinates(
                  {'lat': position.latitude, 'lng': position.longitude});
              BlocProvider.of<PickUpCubit>(context).setPointerAddress(-1);
            },
          ),
        ),
        Positioned(
            bottom: 10,
            left: 10,
            child: FloatingActionButton.extended(
              heroTag: 'btn2',
              onPressed: () => showModalBottomSheet(
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20))),
                context: context,
                builder: (_) => buildSheet(state, context),
              ),
              label: const Text('Mis ubicaciones'),
              icon: const Icon(Icons.location_history),
            )),
      ],
    ));
  }

  Widget buildSheet(PickUpState state, BuildContext context) => SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        children: [
          Center(
            child: Text("Tus ubicaciones guardadas"),
          ),
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                itemCount: state.prePickUpInfoV2?.address.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xff764abc),
                      //child: Text(index.toString()),
                      child: Icon(Icons.location_history),
                    ),
                    title: Text(state.prePickUpInfoV2!.address[index].name),
                    subtitle:
                        Text(state.prePickUpInfoV2!.address[index].detail),
                    trailing: IconButton(
                      icon: Icon(Icons.map),
                      onPressed: () {
                        String followLink =
                            state.prePickUpInfoV2!.address[index].addressLink;
                      },
                    ),
                    onTap: () {
                      googleMapController.animateCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(
                              target: LatLng(
                                  state
                                      .prePickUpInfoV2!.address[index].latitude,
                                  state.prePickUpInfoV2!.address[index]
                                      .longitude),
                              zoom: 14)));

                      BlocProvider.of<PickUpCubit>(context).setCoordinates({
                        'lat': state.prePickUpInfoV2!.address[index].latitude,
                        'lng': state.prePickUpInfoV2!.address[index].longitude
                      });

                      BlocProvider.of<PickUpCubit>(context)
                          .setPointerAddress(index);
                      setState(() {
                        _markers.clear();
                        _markers.add(Marker(
                            markerId: MarkerId('SAME'),
                            position: LatLng(
                                state.prePickUpInfoV2!.address[index].latitude,
                                state.prePickUpInfoV2!.address[index]
                                    .longitude)));
                      });

                      Navigator.of(context).pop();
                    },
                    selected: state.pointerAddress == index,
                  );
                },
              ),
            ),
          ),
        ],
      ));

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Los servicios de ubicacion estan deshabilitados");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Permisos de ubicacion denegados");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          "Los permisos de ubicacion estan denegados permanentemente");
    }

    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  Future<void> _showDialog(BuildContext context, String title, String message,
      bool closeable) async {
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
