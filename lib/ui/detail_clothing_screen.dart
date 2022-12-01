import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_jeff/cubit/detail_product/detail_product_cubit.dart';
import 'package:mr_jeff/cubit/detail_product/detail_product_state.dart';
import 'package:mr_jeff/cubit/order/order_cubit.dart';

class DetailClothingScreen extends StatelessWidget {
  const DetailClothingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = BlocProvider.of<DetailProductCubit>(context);
    final order = BlocProvider.of<OrderCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mr. Jeff"),
      ),
      body: BlocConsumer<DetailProductCubit, DetailProductState>(
        bloc: screen,
        listener: (BuildContext contex, DetailProductState state) {
          if (state.error != null) {
            print("Error");
          }
        },
        builder: (BuildContext ctx3, DetailProductState state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return buildBody(state, context);
        },
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, "/prepickupv2");
          },
          child: const Text("Solicitar servicio!"),
        ),
      ),
    );
  }

  Widget buildBody(DetailProductState state, BuildContext context) {
    final order = BlocProvider.of<OrderCubit>(context);
    return ListView(
      children: [
        SizedBox(
          height: 300,
          child: PageView.builder(
            itemCount: state.clothing?.images.length,
            pageSnapping: true,
            itemBuilder: (context, index) {
              return Container(
                  margin: const EdgeInsets.all(10),
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image:
                              NetworkImage(state.clothing!.images[index].image),
                        )),
                  ));
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "${state.clothing?.price} bs.",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            state.clothing?.title ?? "",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            state.clothing?.description ?? "",
            style: const TextStyle(fontSize: 15),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: const Text("Servicios", style: TextStyle(fontSize: 20)),
        ),
        const SizedBox(height: 20),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.clothing?.services.length ?? 0,
          itemBuilder: (context, index) {
            return ListTile(
              title: state.clothing?.services[index].principalService == 1
                  ? Text(state.clothing?.services[index].detTitle ?? "")
                  : Text(
                      "${state.clothing?.services[index].detTitle} + ${state.clothing?.services[index].price} bs."),
              iconColor: Colors.blue,
              leading: state.clothing?.services[index].principalService == 1
                  ? const Icon(Icons.check_circle)
                  : const Icon(Icons.do_not_disturb_on_outlined),
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
