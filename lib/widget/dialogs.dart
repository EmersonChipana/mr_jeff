import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class MyLoadingWidget extends StatelessWidget {
  final String title;
  const MyLoadingWidget({Key? key,
  required this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.fastLinearToSlowEaseIn,
      child: Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0,10)
                        )
                      ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      Text(title,
                        textAlign: TextAlign.center,
                        style:const TextStyle(
                            fontSize: 16
                        ),
                      ),
                      const Center(
                        child: SpinKitFadingCircle(
                          color: Colors.indigo,
                          size: 50,
                        ),
                      ),
                    ],

                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
