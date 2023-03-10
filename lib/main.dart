import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'dart:math' as math show Random;

void main() {
  runApp(const MyApp());
}

const names = [
  'foo',
  'baz',
  'bar'
];

extension RandomElement<T> on Iterable<T>{
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class NamesCubit extends Cubit<String?>{
  //What we are saying here is that for now we don't initially have a value/state
  NamesCubit() : super(null);

  void pickRandomName() => emit(names.getRandomElement());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // This widget is the root of your application.
  late final NamesCubit cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit =  NamesCubit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: StreamBuilder<String?>(
        stream: cubit.stream,
        builder: (context, snapshot){
          final button = TextButton(
            onPressed: ()=> cubit.pickRandomName(),
            child: const Text('Pick a random number'),
          );
          switch(snapshot.connectionState){

            case ConnectionState.none:
              return button;
            case ConnectionState.waiting:
              return button;
            case ConnectionState.active:
              return Column(
                children: [
                  Text(snapshot.data ?? ''),
                  button,
                ],
              );
            case ConnectionState.done:
              return const SizedBox();
          }
        },
      ),
    );
  }
}

