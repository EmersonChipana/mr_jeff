import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_jeff/cubit/app/app_cubit.dart';
import 'package:mr_jeff/cubit/app/app_state.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  final screenCubit = AppCubit();

  @override
  void initState() {
    screenCubit.loadInitialData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mr. Jeff")),
      body: BlocConsumer<AppCubit, AppState>(
        bloc: screenCubit,
        listener: (BuildContext context, AppState state) {
          if (state.error != null) {
            // TODO your code here
          }
        },
        builder: (BuildContext context, AppState state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
            
          }

          return buildBody(state);
        },
      ),
    );
  }

  Widget buildBody(AppState state) {
    return ListView(
      children: [
        Center(
          child: MaterialButton(
            onPressed: () {
              Navigator.pushNamed(context, "/order");
            },
            color: Colors.lightBlue,
            child: const Text("Carrito"),
          ),
        ),
      ],
    );
  }
}
