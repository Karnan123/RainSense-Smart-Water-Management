import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class AppBarExample extends StatelessWidget {
  const AppBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App', style: TextStyle(fontSize: 24, color: Colors.black, )),
      ),
      );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  //final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isWaiting = false;
  String _response = '';

  Future<void> collectWeatherData() async {
    setState(() {
      _isWaiting = true;
    });

    try {
      final response = await http.get(Uri.parse(''));

      //log("Received data: $response");

      if (response.statusCode == 200) {
        setState(() {
          _response = json.decode(response.body)['message'];
          _isWaiting = false;
        });
      }

      else {
        setState(() {
          _response = 'Failed to collect weather data';
          _isWaiting = false;
        });
      }
    } 
    
    catch (e) {
      setState(() {
        _response = 'Failed to collect weather data';
        _isWaiting = false;
      });
    }

    _isWaiting = false;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App', style: TextStyle(fontSize: 24, color: Colors.black, )),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                collectWeatherData();
              }, 
              child: const Text('Pull API Data'),
            ),
            // const Text(
            //   'You have pushed the button this many times:',
            // ),
            const SizedBox(height: 20),
            if (_isWaiting == true) 
              const CircularProgressIndicator()
            else if (_response.isNotEmpty)
              Text(
                'Response: $_response',
                style: const TextStyle(fontSize: 20),
              ),
          ],
        ),
      ),
    );
  }
}
