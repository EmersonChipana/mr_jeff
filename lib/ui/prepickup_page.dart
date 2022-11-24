 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mr_jeff/cubit/pickup/al_pagestatus.dart';
import 'package:mr_jeff/cubit/pickup/prepickup/prepickup_cubit.dart';
import 'package:mr_jeff/cubit/pickup/prepickup/prepickup_state.dart';


class PrePickUpPage extends StatefulWidget {
  const PrePickUpPage({Key? key}) : super(key: key);

  @override
  State<PrePickUpPage> createState() => _PrePickUpPageState();
}

class _PrePickUpPageState extends State<PrePickUpPage> {

  final ScrollController _scrollController = ScrollController();
  late GoogleMapController googleMapController;


  @override
  void initState() {
    print('============= iniciando ==============');
    context.read<PrePickupCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context1) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Solicita una recogida ;)"),
      ),
      body: BlocConsumer<PrePickupCubit,PrePickupState>(
        listener: (ctx3, state)  {
          if(state.status == PageStatus.verifying){


            _showDialog(context, "Sucursales",
                "Verificando si el servicio esta disponible en la ubicacion seleccionada", false);
          }else if(state.status == PageStatus.correctVerified){

              Navigator.pop(ctx3);

              BlocProvider.of<PrePickupCubit>(context)
                  .setPageState(PageStatus.success);
              Navigator.pushNamed(ctx3, '/pickup');
          }else if(state.status == PageStatus.incorrectVerified){

            Navigator.pop(ctx3);

            BlocProvider.of<PrePickupCubit>(context)
                .setPageState(PageStatus.success);
            _showDialog(context, "Lo sentimos",
                 state.errorMessage!, true);


          }
        },
        builder: (context, state) {
          if(state.status == PageStatus.loading){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }else if(state.status == PageStatus.failure){
            return Center(
              child: Text('Fallo algo ${state.errorMessage} '),
            );
          }else{
            return _showMapAndTimes(state, context);
          }

        },
      ),
    );
  }

  Widget _showMapAndTimes(PrePickupState state, BuildContext context){
    return Column(

      children: [
        _map(state, context),
        _schedules(state, context),
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
                BlocProvider.of<PrePickupCubit>(context)
                  .passToOtherPage();


              }, child: const Text("Continuar")),
            ],
          ),
        )
      ],
    );
  }


  Widget _map(PrePickupState state, BuildContext context){
    return Expanded(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(-16.503314700752497, -68.13009178852836), zoom: 10),
              markers: state.showMarker ? {
                Marker(markerId: MarkerId('current'),
                    position: LatLng(state.coordinates['lat']!, state.coordinates['lng']!)
                )
              } : {},
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller){
                googleMapController = controller;
              },
              onTap: (point){
                BlocProvider.of<PrePickupCubit>(context).setNewMarker({ 'lat':point.latitude, 'lng':point.longitude} );
                BlocProvider.of<PrePickupCubit>(
                    context)
                    .setPointerAddress(-1);



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
                  print("String: $position");


                  googleMapController
                      .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 14)));



                  BlocProvider.of<PrePickupCubit>(
                      context)
                      .setNewMarker({'lat':position.latitude, 'lng':position.longitude});
                  BlocProvider.of<PrePickupCubit>(
                      context)
                      .setPointerAddress(-1);


                },
              ),
            ),
            Positioned(
                bottom: 10,
                left: 10,
                child: FloatingActionButton.extended(
                  heroTag: 'btn2',
                  onPressed: ()=> showModalBottomSheet(
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20)
                        )
                    ),
                    context: context,
                    builder: (_) => buildSheet(state,context),
                  ),
                  label: const Text('Mis ubicaciones'),
                  icon: const Icon(Icons.location_history),
                )
            ),
          ],
        )
    );
  }

  Widget _schedules(PrePickupState state, BuildContext context){
    return Container(
      height:  MediaQuery.of(context).size.height*0.3,
      color: Colors.green,
      child: Row(
        children: [

          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: state.prePickUpInfo!.finalListTime.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: (){
                      BlocProvider.of<PrePickupCubit>(
                          context)
                          .setNewDatePointer(index);

                      if(index != state.pointerDate){
                        _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                        BlocProvider.of<PrePickupCubit>(
                            context)
                            .setNewTimePointer(0);
                      }


                    },
                    child: Container(
                      height: 40,
                      child: Center(
                          child: Text(
                              ' ${state.prePickUpInfo!.finalListTime[index].dia.getNameDayAndDate()} ' )
                          ),
                      color: state.pointerDate == index ? Colors.green : Colors.white,
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
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: state.prePickUpInfo!.finalListTime[state.pointerDate].horas.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: (){
                      BlocProvider.of<PrePickupCubit>(
                          context)
                          .setNewTimePointer(index);

                    },
                    child: Container(
                      height: 40,
                      child: Center(
                          child: Text (
                            '${state.prePickUpInfo!.finalListTime[state.pointerDate].horas[index].getStringTimeFormat()}'
                          )
                      ),
                      color: index == state.pointerTime ? Colors.blue : Colors.white,
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

  Widget buildSheet(PrePickupState state, BuildContext context) => SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        children: [
          Center(child: Text("Tus Mapas"),),
          Expanded(

            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                itemCount: state.prePickUpInfo?.finalListAddress.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xff764abc),
                      child: Text(index.toString()),
                    ),
                    title: Text(state
                        .prePickUpInfo!
                        .finalListAddress[index]
                        .name),
                    subtitle: Text(state
                        .prePickUpInfo!
                        .finalListAddress[index]
                        .detail),
                    trailing: IconButton(
                      icon: Icon(Icons.map),
                      onPressed: () {
                        String followLink = state
                            .prePickUpInfo!
                            .finalListAddress[index]
                            .addressLink;
                      },
                    ),
                    onTap: () {

                      googleMapController
                          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(state.prePickUpInfo!.finalListAddress[index].latitude, state.prePickUpInfo!.finalListAddress[index].longitude), zoom: 14)));


                      BlocProvider.of<PrePickupCubit>(context).setNewMarker({ 'lat':state.prePickUpInfo!.finalListAddress[index].latitude, 'lng':state.prePickUpInfo!.finalListAddress[index].longitude} );

                      BlocProvider.of<PrePickupCubit>(
                          context)
                          .setPointerAddress(index);


                      Navigator.of(context).pop();
                    },
                    selected:
                      state.pointerAddress == index,
                  );
                },
              ),
            ),
          ),
        ],
      )
  );

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
                const CircularProgressIndicator(),

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
