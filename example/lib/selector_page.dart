import 'package:builders/builders.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'counter.dart';

class SelectorPage extends StatefulWidget {
  SelectorPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SelectorPageState createState() => _SelectorPageState();
}

class _SelectorPageState extends State<SelectorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selector'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Selector<Counter, int>(
                selector: (counter) => counter.value,
                builder: (context, value) {
                  return Text(
                    '$value',
                    style: Theme.of(context).textTheme.headline4,
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: GetIt.I.get<Counter>().increment,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
