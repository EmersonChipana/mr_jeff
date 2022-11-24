
 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_jeff/cubit/operation_workers/opecourier_state.dart';
import 'package:mr_jeff/cubit/operation_workers/opercourier_cubit.dart';
import 'package:mr_jeff/cubit/pickup/al_pagestatus.dart';
import 'package:mr_jeff/model/operation_model/ope_courier_info.dart';
import 'package:mr_jeff/ui/mapa_courier.dart';
import 'package:mr_jeff/widget/dialogs.dart';

class WorkerDiaryPage extends StatefulWidget {
  const WorkerDiaryPage({Key? key}) : super(key: key);

  @override
  State<WorkerDiaryPage> createState() => _WorkerDiaryPageState();
}

class _WorkerDiaryPageState extends State<WorkerDiaryPage> {

  @override
  void initState(){
    print('=========---------------- init worker diary----------');
    context.read<OpeCourierCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agenda del courier ;) "),
      ),
      body: SafeArea(
        child: BlocConsumer<OpeCourierCubit,OpeCourierState>(
          listener: (context, state){
            if(state.status == PageStatus.verifying){
              _showDialog(context, "", "Cargando Mapa", false);
            }else if(state.status == PageStatus.correctVerified){
              Navigator.pop(context);
              BlocProvider.of<OpeCourierCubit>(context)
                  .setPageState(PageStatus.success);
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => MapWorkerPage())
              );

            } else if(state.status == PageStatus.incorrectVerified){
              Navigator.pop(context);

              BlocProvider.of<OpeCourierCubit>(context)
                  .setPageState(PageStatus.success);
              _showDialog(context, "Lo sentimos",
                  state.errorMessage!, true);
            } else if(state.status == PageStatus.loading){
              print('=========---------------- loading worker diary----------');
              BlocProvider.of<OpeCourierCubit>(context).init();
            } else if(state.status == PageStatus.failure){
              Navigator.pop(context);
              BlocProvider.of<OpeCourierCubit>(context)
                  .setPageState(PageStatus.success);
              _showDialog(context, "Lo sentimos, algo fallo",
                  state.errorMessage!, true);
            }
          },
          builder: (context,state) {
            if(state.status == PageStatus.loading){
              return MyLoadingWidget(title: 'Cargando los datos');
              // return Center(
              //   child: CircularProgressIndicator(),
              // );
            } else if(state.status == PageStatus.failure){
              return Center(
                child: Text('Fallo algo ${state.errorMessage} '),
              );
            } else{
              //return _showCardsAboutOperations(context, state, state.availableOperations, 1);
              return SingleChildScrollView(
                child: Column(

                  children: [
                    Text('Operaciones Disponibles'),
                    _showCardsAboutOperations(context, state, state.availableOperations, 1),
                     Text('Operacion en las que participa'),
                    _showCardsAboutOperations(context, state, state.currentOperations, 2)

           ],
             ),
              );
            }
          }
        ),
      )
    );
  }
  //
  // Widget _showCardsAboutOperations(BuildContext context, OpeCourierState state){
  //     return Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.stretch,
  //         children: [
  //           Text('MY DATa',
  //             style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 26,
  //                 color: Colors.white
  //             ),
  //           ),
  //           Expanded(
  //             child: ListView.builder(
  //                 itemCount: state.availableOperations.length,
  //                 itemBuilder: (context, index){
  //                   return Center(
  //                       child: CardItem(
  //                         color: Colors.primaries[index % Colors.primaries.length] ,
  //                         mainText: state.availableOperations[index].message,
  //                         nombreCliente: state.availableOperations[index].nameClient,
  //                         strDate: state.availableOperations[index].date,
  //                         strHora: '${state.availableOperations[index].timeStart} - '
  //                             '${state.availableOperations[index].timeEnd}',
  //                         index: index,
  //                         operationList: 1
  //                       ));
  //                 }
  //             ),
  //           )
  //         ],
  //       ),
  //     );
  // }


  Widget _showCardsAboutOperations(BuildContext context, OpeCourierState state, List<OpeCourierInfo> lista, int operationList){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20.0),
      child: SingleChildScrollView(
        child: Column(

          children: [
            // Text('MY DATa',
            //   style: TextStyle(
            //       fontWeight: FontWeight.bold,
            //       fontSize: 26,
            //       color: Colors.black26
            //   ),
            // ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
                itemCount: lista.length,
                itemBuilder: (context, index){
                  return Center(
                      child: CardItem(
                          color: Colors.primaries[index % Colors.primaries.length] ,
                          mainText: lista[index].message,
                          nombreCliente: lista[index].nameClient,
                          strDate: lista[index].date,
                          strHora: '${lista[index].timeStart} - '
                              '${lista[index].timeEnd}',
                          index: index,
                          operationList: operationList
                      ));
                }
            )
          ],
        ),
      ),
    );
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


class CardItem extends StatelessWidget{
  final Color color;
  final String mainText;
  final String nombreCliente;
  final String strHora;
  final String strDate;
  final int index;
  final int operationList;

  CardItem({Key? key,
    required this.color,
    required this.mainText,
    required this.nombreCliente,
    required this.strHora,
    required this.strDate,
    required this.index,
    required this.operationList,
  }) : super (key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

        print('(worker-diary) ====== 1 ====== (card)');

        BlocProvider.of<OpeCourierCubit>(context)
            .openAvailableMap(index, operationList);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        child: Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: color,
                    blurRadius: 5,
                    spreadRadius: 1

                ), //BoxShadow

              ]
          ),

          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  child: Text(nombreCliente,
                    style: TextStyle(
                      fontSize: 15,

                    ),) ,),
                Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(mainText,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,

                        ),
                      ),
                    )
                ),
                Positioned(
                    bottom: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(strHora,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),)
                      ],
                    )
                ),

                Positioned(
                    right: 3,
                    bottom: 0,
                    child: Text(strDate,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,

                      ),)
                )

              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<void> _showDialogCallback(BuildContext context,
      String title, String message,
      bool closeable,
      VoidCallback callback) async {
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
              onPressed:  callback,
            )
                : Container(),
          ],
        );
      },
    );
  }




}
