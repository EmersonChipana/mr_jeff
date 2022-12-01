import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_jeff/cubit/app/app_cubit.dart';
import 'package:mr_jeff/cubit/clothings_order/clothings_order_cubit.dart';
import 'package:mr_jeff/cubit/detail_product/detail_product_cubit.dart';
import 'package:mr_jeff/cubit/order/order_cubit.dart';
import 'package:mr_jeff/cubit/pickup/pickup_cubit.dart';
import 'package:mr_jeff/ui/app_screen.dart';
import 'package:mr_jeff/ui/clothings_order_screen.dart';
import 'package:mr_jeff/ui/delivery_screen.dart';
import 'package:mr_jeff/ui/detail_product_screen.dart';
import 'package:mr_jeff/ui/inital_products_screen.dart';
import 'package:mr_jeff/ui/order_screen.dart';
import 'package:mr_jeff/ui/index.dart';
import 'package:mr_jeff/ui/login.dart';
import 'package:mr_jeff/ui/home_main_page.dart';
import 'package:mr_jeff/ui/pickup_v2_page.dart';
import 'package:mr_jeff/ui/pre_delivery_screen.dart';
import 'package:mr_jeff/ui/prepickup_v2_page.dart';
import 'package:mr_jeff/ui/register.dart';
import 'package:mr_jeff/ui/worker_diary.dart';
import 'package:mr_jeff/ui/worker_diary_v2_page.dart';

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
        BlocProvider<AppCubit>(create: ((context) => AppCubit())),
        BlocProvider<OpeCourierCubit>(
          create: (BuildContext context) => OpeCourierCubit(),
        ),
        BlocProvider<PickUpCubit>(
          create: (BuildContext context) => PickUpCubit(),
        ),
        BlocProvider<OrderCubit>(
          create: (BuildContext context) => OrderCubit(),
        ),
        BlocProvider<DetailProductCubit>(
          create: (BuildContext context) => DetailProductCubit(),
        ),
        BlocProvider<ClothingsOrderCubit>(
          create: (BuildContext context) => ClothingsOrderCubit(),
        ),
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
          '/prepickupv2': (context) => const PrePickUpPageV2(),
          '/pickupv2': (context) => const PickUpPageV2(),
          '/workerDiaryV2': (context) => const WorkerDiaryPageV2(),
          '/clothings': (context) => const InitalProductsScreen(),
          '/detail': (context) => const DetailProductScreen(),
          '/preDelivery': (context) => const ClothingsOrderScreen(),
          '/setAddressDelivery':(context) => const PreDeliveryScreen(),
          '/delivery':(context) => const DeliveryScreen(), 
          '/sign': (context) => const RegisterPage(),
        },
      ),
    );
  }
}
