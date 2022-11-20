import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_jeff/cubit/app/app_cubit.dart';
import 'package:mr_jeff/ui/app_screen.dart';
import 'package:mr_jeff/ui/order_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ((context) => AppCubit()),
      child: MaterialApp(
        title: 'Mr. Jeff',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: "/",
        routes: {
          "/": (context) => const AppScreen(),
          "/order": (context) => const OrderScreen(),
        },
      ),
    );
  }
}
