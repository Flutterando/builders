import 'package:builders/builders.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'counter_bloc.dart';

class BlocPage extends StatefulWidget {
  BlocPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BlocPageState createState() => _BlocPageState();
}

class _BlocPageState extends State<BlocPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bloc'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            BlocConsumer<CounterBloc, int>(builder: (context, state) {
              return Text(
                '$state',
                style: Theme.of(context).textTheme.headline4,
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: GetIt.I.get<CounterBloc>().increment,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
