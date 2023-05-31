import 'package:flutter/material.dart';

class ListNotifier<T> extends ValueNotifier<List<T>> {
  @override
  final List<T> value;

  ListNotifier({required this.value}) : super(value);

  void emit() {
    notifyListeners();
  }
}