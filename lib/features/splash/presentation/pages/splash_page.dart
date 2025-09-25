import 'package:flutter/material.dart';
import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import '../controller/splash_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  
  @override
  State<StatefulWidget> createState() {
    return SplashPageState();
  }
}

@reflection
class SplashPageState extends State<SplashPage> with AutoInject {
  @Inject(nameSetter: "setController")
  late final SplashController controller;

  SplashPageState() {
    super.inject();
  }

  @override
  void initState() {
    super.initState();
    controller.init()
      .then((_) => Future.delayed(const Duration(seconds: 2)))
      .then((_) {
        if (!mounted) return;

        Navigator.of(context).pushReplacementNamed(
          "/"
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue.shade700,
        child: Center(
          child: Image.asset("lib/assets/logo.png"),
        ),
      ),
    );
  }

  set setController(SplashController controller) {
    this.controller = controller;
  }
}