import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final ValueNotifier<String> message;

  const Loading({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0)
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 20.0),
                ValueListenableBuilder(
                  valueListenable: message,
                  builder: (context, value, child) => Text(value),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

}