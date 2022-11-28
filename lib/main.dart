import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_jeff/cubit/app/app_cubit.dart';
import 'package:mr_jeff/cubit/pickup/pickup_cubit.dart';
import 'package:mr_jeff/ui/app_screen.dart';
import 'package:mr_jeff/ui/order_screen.dart';
import 'package:mr_jeff/ui/index.dart';
import 'package:mr_jeff/ui/login.dart';
import 'package:mr_jeff/ui/home_main_page.dart';
import 'package:mr_jeff/ui/pickup_v2_page.dart';
import 'package:mr_jeff/ui/prepickup_v2_page.dart';
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
        BlocProvider<OpeCourierCubit>(
          create: (BuildContext context) => OpeCourierCubit(),
        ),
        BlocProvider<PickUpCubit>(
          create: (BuildContext context) => PickUpCubit(),
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
          '/workerDiary': (context) => const WorkerDiaryPage(),
          '/prepickupv2':(context) => const PrePickUpPageV2(),
          '/pickupv2': (context) =>const PickUpPageV2()
          //"/login": ((context) => const LoginScreen())
        },
      ),
    );
  }
}
