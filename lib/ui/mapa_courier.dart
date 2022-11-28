 import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mr_jeff/cubit/operation_workers/opecourier_state.dart';
import 'package:mr_jeff/cubit/operation_workers/opercourier_cubit.dart';
import 'package:mr_jeff/cubit/pickup/al_pagestatus.dart';
import 'package:mr_jeff/utils/google_maps_api.dart';
import 'package:mr_jeff/widget/dialogs.dart';

class MapWorkerPage extends StatefulWidget {
  const MapWorkerPage({Key? key}) : super(key: key);

  @override
  State<MapWorkerPage> createState() => _MapWorkerPageState();
}

class _MapWorkerPageState extends State<MapWorkerPage> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>();
  int _polylineIdCounter = 1;

  late GoogleMapController googleMapController;

  @override
  void initState() {
    print('============= iniciando ==============');

    double lat  =0;
    double lng = 0;
    lat = context.read<OpeCourierCubit>().state.latCurrent;
    lng =  context.read<OpeCourierCubit>().state.lngCurrent;

     

    _setMarker(LatLng(lat, lng), 'Destino');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Titulo de mapa :<) "),
      ),
      body: BlocConsumer<OpeCourierCubit ,OpeCourierState>(
        listener: (context, state){
          if(state.status == PageStatus.verifying2){

            print('Leggo aqui aaaa');
            showDialog(
                context: context,
                builder: (BuildContext context){
                  context = context;
                  return MyLoadingWidget(title: 'Verificando');
                }
            );


            //_showLoadingDialog(context, "Verificando", "Verificando la disponibilidad", false);
          }else if(state.status == PageStatus.correctVerified2){
            Navigator.pop(context);

            _showDialog(context,
                'Buen trabajo'
                ,'Ya tienes habilitada esa tarea'
                , true,
                () {
                    BlocProvider.of<OpeCourierCubit>(context).
                        setPageState(PageStatus.loading);
                    Navigator.popUntil(context, ModalRoute.withName('/workerDiaryV2'));
                    },
              'Cerrar'
            );

          }

        },
        builder:  (context, state){
          if(state.status == PageStatus.loading){
            print('====3==== status ${state.status}');
            return const Center(
              child: CircularProgressIndicator(),
            );
          }else if(state.status == PageStatus.failure){
            print('====3==== status ${state.status}');
            return Center(
              child: Text('Fallo algo ${state.errorMessage} '),
            );
          }else{
            print('====3==== status ${state.status}');
            print(state.lessData());
            if(state.pointerOperation == 1){
              return _showMapAndButtons(state, context);
            }else if(state.pointerOperation == 2){

              return _showMapNoButtons(state, context);
            } else{
              return _showMapNoButtons(state, context);
            }

          }
        },
      )
    );
  }

  Widget _showMapAndButtons(OpeCourierState state, BuildContext context){

    return Column(
      children: [
        _map(context, state),

        Container(
          height: MediaQuery.of(context).size.height*0.07 ,
          color: Colors.pink,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: Text("Cancelar")),
              ElevatedButton(onPressed: (){
                print(state.toString());

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("AlertDialog"),
                      content: Text("Would you like to continue learning how to use Flutter alerts?"),
                      actions: [
                        TextButton(onPressed: (){
                          Navigator.pop(context);
                        }, child: Text('Cancelar')),
                        TextButton(onPressed: (){
                            print(state.pointerAvailable);
                            Navigator.pop(context);
                            BlocProvider.of<OpeCourierCubit>(context).sendOperation();
                        } , child: Text('Continuar'),)
                      ],
                    );
                  },
                );

                // BlocProvider.of<OpeCourierCubit>(context)
                //     .acceptRequest();


              }, child: const Text("Aceptar Solicitud")),
            ],
          ),
        )
      ],
    );
  }

  Widget _showMapNoButtons(OpeCourierState state, BuildContext context){

    return Column(
      children: [
        _map(context, state),


      ],
    );
  }

  Widget _map(BuildContext context, OpeCourierState state ){
    return Expanded(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                  //target: punto,
                  target: LatLng(
                      state.latCurrent,
                      state.lngCurrent
                  ),
                  zoom: 16
              ),
              markers: _markers,
              polylines: _polylines,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller){
                _controller.complete(controller);
              },
              onTap: (point){

              },
            ),

            Positioned(
              bottom: 10,
              right: 10,
              child: FloatingActionButton(
                heroTag: 'btn1',
                child: Icon(Icons.location_on),
                onPressed: () async {


                  Position position = await _determinePostion();


                  var directions = await GoogleMapsApi.
                  getDirections('${position.latitude},${position.longitude}',
                      '${state.latCurrent},'
                          '${state.lngCurrent}');

                  _goToPlace(
                      directions['start_location']['lat'],
                      directions['start_location']['lng'],
                      directions['bounds_ne'],
                      directions['bounds_sw']
                  );


                  _setPolyline(directions['polyline_decoded']);


                  setState(() {

                    _markers.add(Marker(
                        markerId: MarkerId('adada21351'),
                      position: LatLng(position.latitude, position.longitude),
                      infoWindow: InfoWindow(title: 'Estas aqui',snippet: 'direccion'),
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
                    ));
                  });


                },
              ),
            ),

          ],
        )
    );
  }

  Future<Position> _determinePostion() async{
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      return Future.error("Los servicios de ubicacion estan deshabilitados");
    }
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        return Future.error("Permisos de ubicacion denegados");
      }
    }

    if(permission == LocationPermission.deniedForever){
      return Future.error("Los permisos de ubicacion estan denegados permanentemente");
    }

    Position position = await Geolocator.getCurrentPosition();
    return position;

  }

  Future<void> _goToPlace(
      double lat,
      double lng,
      Map<String, dynamic> boundsNe,
      Map<String, dynamic> boundsSw
      ) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12)
    ));

    controller.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(boundsSw['lat'], boundsSw['lng']) ,
            northeast: LatLng(boundsNe['lat'], boundsNe['lng'])
        ), 25)
    );


  }

  void _setMarker(LatLng point, String s){

      _markers.add(
          Marker(
              markerId: MarkerId('marker'),
              position: point,
              infoWindow: InfoWindow(title: s)
          )
      );



  }
  void _setPolyline(List<PointLatLng>points){
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;
    _polylines.add(
        Polyline(
          polylineId: PolylineId(polylineIdVal),
          width: 2,
          color: Colors.blue,
          points: points
              .map(
                  (point) => LatLng(point.latitude, point.longitude)
          ).toList(),
        )
    );
  }

  Future<void> _showLoadingDialog(BuildContext context, String title, String message,
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
                const SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator()),

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
  Future<void> _showDialog(BuildContext context,
      String title, String message,
      bool closeable,
      VoidCallback callback,
      String btnName) async {
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
              child: Text(btnName),
              onPressed:  callback,
            )
                : Container(),
          ],
        );
      },
    );
  }









}
