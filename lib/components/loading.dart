import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading {
  const Loading({required this.context});
  final BuildContext context;


  Widget buildLoading(){
    return Expanded(
      child: SpinKitChasingDots(
        itemBuilder: (context, int index) {
          return DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: index.isEven
                  ? const Color(0xffff1b7d)
                  : const Color(0xff54e8f3),
            ),
          );
        },
      ),
    );
  }

  void showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return buildLoading();
      },
    );
  }

  void dismissLoading() {
    Navigator.of(context).pop();
  }
}
