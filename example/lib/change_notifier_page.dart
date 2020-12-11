import 'package:builders/builders.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'counter.dart';

class ChangeNotifierPage extends StatefulWidget {
  ChangeNotifierPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _ChangeNotifierPageState createState() => _ChangeNotifierPageState();
}

class _ChangeNotifierPageState extends State<ChangeNotifierPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChangeNotifier'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Consumer<Counter>(
              builder: (context, counter) {
                return Text(
                  '${counter?.value}',
                  style: Theme.of(context).textTheme.headline4,
                );
              },
            ),
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
