// Copyright 2019 the Dart project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

import 'dart:html';
import 'package:dartpad_picker/dartpad_picker.dart';

void main() {
  if (isMobile()) {
    querySelector('#dartpad-landing-page').style.display = 'none';
    return;
  }

  var dartPadHost = querySelector('#dartpad-host');
  var select = querySelector('#dartpad-select');

  var snippets = [
    Snippet('Spinning Flutter', spinning_logo),
    Snippet('Fibonacci', fibonacci),
    Snippet('Counter', counter),
  ];

  DartPadPicker(dartPadHost, select, snippets);
}

// Mobile browser detection

final RegExp _mobileRegex =
    RegExp(r'Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini');
bool isMobile() {
  return _mobileRegex.hasMatch(window.navigator.userAgent);
}

// Snippets

var counter = r'''
import 'package:flutter_web/material.dart';
import 'package:flutter_web_test/flutter_web_test.dart';
import 'package:flutter_web_ui/ui.dart' as ui;

class Counter extends StatefulWidget {
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  double val;

  void initState() {
    super.initState();
    val = 0;
  }

  void change() {
    setState(() {
      val += 1;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text('$val'))),
            MaterialButton(
              color: Theme.of(context).primaryColor,
              child: Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => change(),
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Center(
        child: Container(
          child: Counter(),
        ),
      ),
    );
  }
}

Future<void> main() async {
  await ui.webOnlyInitializePlatform();
  runApp(MyApp());
}

'''
    .trim();
var spinning_logo = r'''
import 'dart:math';
import 'package:flutter_web/material.dart';
import 'package:flutter_web_ui/ui.dart' as ui;

void main() async {
  await ui.webOnlyInitializePlatform();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    animation = Tween(begin: 0.0, end: 4 * pi)
      .animate(CurvedAnimation(
        curve: Curves.easeInOutCubic,
        parent: controller,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        controller
          ..reset()
          ..forward();
      }),
      child: SizedBox.expand(
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Transform.rotate(
              angle: animation.value,
              child: child,
            );
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: FlutterLogo(),
              ),
              Center(
                child: Text(
                  'Click me!',
                  style: TextStyle(
                    fontSize: 60.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
'''
    .trim();

var fibonacci = r'''
import 'package:flutter_web/material.dart';
import 'package:flutter_web_ui/ui.dart' as ui;

void main() async {
  await ui.webOnlyInitializePlatform();
  final numbers = FibonacciNumbers();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fibonacci List'),
        ),
        body: FibonacciListView(numbers),
      ),
    ),
  );
}

class FibonacciNumbers {
  final cache = {0: BigInt.from(1), 1: BigInt.from(1)};

  BigInt get(int i) {
    if (!cache.containsKey(i)) {
      cache[i] = get(i - 1) + get(i - 2);
    }
    return cache[i];
  }
}

class FibonacciListView extends StatelessWidget {
  final FibonacciNumbers numbers;

  FibonacciListView(this.numbers);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, i) {
        return ListTile(
          title: Text('${numbers.get(i)}'),
          onTap: () {
            final snack = SnackBar(
              content: Text('${numbers.get(i)} is '
                  '#$i in the Fibonacci sequence!'),
            );
            Scaffold.of(context).showSnackBar(snack);
          },
        );
      },
    );
  }
}

'''
    .trim();
