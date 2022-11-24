import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_jeff/cubit/app/app_cubit.dart';
import 'package:mr_jeff/ui/app_screen.dart';
import 'package:mr_jeff/ui/order_screen.dart';
import 'package:mr_jeff/ui/index.dart';
import 'package:mr_jeff/ui/login.dart';
import 'package:mr_jeff/ui/home_main_page.dart';
import 'package:mr_jeff/ui/pickup_page.dart';
import 'package:mr_jeff/ui/prepickup_page.dart';
import 'package:mr_jeff/ui/worker_diary.dart';

import 'cubit/operation_workers/opercourier_cubit.dart';
import 'cubit/pickup/prepickup/prepickup_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>(
            create: ((context) => AppCubit())
        ),
        BlocProvider<PrePickupCubit>(
          create: (BuildContext context) => PrePickupCubit(),
        ),
        BlocProvider<OpeCourierCubit>(
          create: (BuildContext context) => OpeCourierCubit(),
        )
      ],

      child: MaterialApp(
        title: 'Mr. Jeff',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: "/",
        routes: {
          "/": (context) => const IndexScreen(),
          "/order": (context) => const OrderScreen(),
          "/login": (context) => const LoginPage(),
          "/home": (context) => HomePage(),
          '/pickup': (context) => const PickUpPage(),
          '/prepickup': (context) => const PrePickUpPage(),
          '/workerDiary': (context) => const WorkerDiaryPage()
          //"/login": ((context) => const LoginScreen())
        },
      ),
    );
  }
}
