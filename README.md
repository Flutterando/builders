# builders

Use Consumer, Select and BlocConsumer in any System Injector

## How Install

Open your project's pubspec.yaml and add flutter_modular as a dependency:

```dart
dependencies:
  builders: any
```
You can also provide the git repository as source instead, to try out the newest features and fixes:

```dart
dependencies:
  flutter_modular:
    git:
      url: https://github.com/Flutterando/builders
```

## Configure your System Injector

You can use any System Injector for example Modular or Get_it.

```dart
main(){
    
    //using Modular
    Builders.systemInjector(Modular.get);
    
    //using Get_it
    Builders.systemInjector(GetIt.I.get);

    runApp(YourAmazingApp());
}
```

## Using in your Flutter App

Here are some Builders known to the community. Here we have Consumer and Selector (Originally from the Provider package) and BlocConsumer, (from the flutter_bloc package)

### Consumer

Consumer is used when you want to listen to a class that extends from ChangeNotifier:
```dart
class MyCounter extends ChangeNotifier {

    int value;

    increment() {
        value++;
        notifyListeners();
    }

}
```
in your View:
```dart
Consumer<MyCounter>(
    builder: (context, myCounter){
        return Text('${myCounter.value}');
    }
);
```

### Selector

Selector works like Consumers, however you can select and listen to only one property of your Object.

```dart
Selector<MyCounter, int>(
    selector: (myCounter) => myCounter.value,
    builder: (context, value){
        return Text('$value');
    }
);
```

### BlocConsumer

Listen to custom streams from the bloc package (Bloc and Cubit).

```dart
class MyCounterBloc extends Cubit<int> {

    MyCounterBloc(): super(0);

    increment() => emit(state + 1);

}
```
in your View:
```dart
BlocConsumer<MyCounterBloc, int>(
    builder: (context, state){
        return Text('$state');
    }
);
```

## Features and bugs

Please send feature requests and bugs at the [issue tracker](https://github.com/Flutterando/builders/issues).

This README was created based on templates made available by Stagehand under a BSD-style [license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).