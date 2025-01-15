import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'weather_row.dart';
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
    return MaterialApp(
      theme: ThemeData.dark(),
      home: MyHomePage(),
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
        title: const Text('Weather App', style: TextStyle(fontSize: 24, color: Colors.white, )),
      ),
      body: 
        Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/sunny.png'),
              fit: BoxFit.cover,
            ),
          ),


        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height:20),
            Container(
              child: const Icon(
                CupertinoIcons.cloud,
                color: Colors.white,
                size: 100.0
              ),
            ),
            const SizedBox(height:15),
            Center(
              child: Text(
                '12°',
                style: TextStyle(
                  fontSize: 80, 
                  color: Colors.white,
                  letterSpacing: -5,
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  collectWeatherData();
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200, 50),
                  minimumSize: const Size(150, 50), // Minimum width and height
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black.withOpacity(0.75), // Background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                ),
                child: const Text(
                  'Refresh Weather Data'
                ),
              ),
            ),
            if (_isWaiting == true) 
              const CircularProgressIndicator()
            else if (_response.isNotEmpty)
            Text(
              'Response: $_response',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height:20),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0), // Add spacing inside the list
                children: const [
                  WeatherRow(day: "Mon", weather: "Rainy", degree: "+20° / 14 mm"),
                  WeatherRow(day: "Tue", weather: "Rainy", degree: "+22° / 9 mm"),
                  WeatherRow(day: "Wed", weather: "Storm", degree: "+19° / 5 mm"),
                  WeatherRow(day: "Thu", weather: "Snow", degree: "+18° / 6 mm"),
                  // WeatherRow(day: "Fri", weather: "Thunder", degree: "+23° / 16 mm"),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
