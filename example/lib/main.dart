import 'package:builders/builders.dart';
import 'package:example/bloc_page.dart';
import 'package:example/selector_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'change_notifier_page.dart';
import 'counter.dart';
import 'counter_bloc.dart';

void main() {
  GetIt.I.registerSingleton(Counter());
  GetIt.I.registerSingleton(CounterBloc());
  Builders.systemInjector(GetIt.I.get);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocPage(),
    );
  }
}
