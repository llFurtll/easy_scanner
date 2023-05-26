import 'package:flutter/material.dart';
import 'package:reflect_inject/annotations/inject.dart';
import 'package:reflect_inject/global/instances.dart';
import 'package:reflect_inject/injection/auto_inject.dart';

import '../controller/splash_controller.dart';

@reflection
class SplashPage extends StatefulWidget with AutoInject {
  @Inject(nameSetter: "setController")
  late final SplashController controller;

  SplashPage({super.key}) {
    super.inject();
  }

  set setController(SplashController controller) {
    this.controller = controller;
  }
  
  @override
  State<StatefulWidget> createState() {
    return SplashPageState();
  }
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    widget
      .controller.init()
      .then((_) => Future.delayed(const Duration(seconds: 2)))
      .then((_) {
        Navigator.of(context).pushNamed("/");
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue.shade700,
      ),
    );
  }
}