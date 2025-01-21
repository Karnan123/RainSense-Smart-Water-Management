import 'package:flutter/material.dart';
import 'weather_row.dart';
import 'handle_weather_data.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isWaiting = false;
  List<Map<String, dynamic>> forecastData = [];

  String _response = '';

  String temp = '';
  int currCond = 0;
  String rainVol = '';
  String currCondDesc = '';

  Icon weatherIcon = Icon(Icons.error);
  AssetImage backgroundImage = AssetImage('assets/sunny.png');

  Future<void> collectWeatherData() async {
    setState(() {
      _isWaiting = true;
    });

    // try {
    //   final response = await http.get(Uri.parse(''));

    //   //log("Received data: $response");

    //   if (response.statusCode == 200) {
    //     setState(() {
    //       _response = json.decode(response.body)['message'];
    //       _isWaiting = false;
    //     });
    //   }

    //   else {
    //     setState(() {
    //       _response = 'Failed to collect weather data';
    //       _isWaiting = false;
    //     });
    //   }
    // } 
    
    // catch (e) {
    //   setState(() {
    //     _response = 'Failed to collect weather data';
    //     _isWaiting = false;
    //   });
    // }

    WeatherPullData weatherData = WeatherPullData();
    await weatherData.getWeatherData();

    setState(() {
      // temp = weatherData.currTemp;
      // currCond = weatherData.currCond;
      // rainVol = weatherData.rainVol;

      forecastData = weatherData.hourlyForecast;

      temp = forecastData[0]['degree'];
      //currCond = int.parse(forecastData[0]['weather'].toString());
      //rainVol = 

      DisplayWeather displayWeather = getDisplayWeather(currCond);
      weatherIcon = displayWeather.weatherIcon;
      backgroundImage = displayWeather.weatherImage;

      _isWaiting = false;
    });

    _isWaiting = false;
  }

  @override
  void initState() {
    super.initState();
    collectWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
        Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: backgroundImage,
              fit: BoxFit.cover,
            ),
          ),


        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height:15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Applies stretch only to this part
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 61, 98, 108).withOpacity(0.75), // Background color
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                    child: const Text(
                      'RainSense Forecast',
                      style: TextStyle(
                        fontSize: 30, 
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height:20),
            Container(
              child: weatherIcon,
            ),
            const SizedBox(height:15),
            Center(
              child: Text(
                '${temp}', //
                style: TextStyle(
                  fontSize: 80, 
                  color: Colors.black,
                  letterSpacing: -5,
                ),
              ),  
            ),
            Center(
              child: Text(
                '$rainVol mm',
                style: TextStyle(
                  fontSize: 40, 
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
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
              child: forecastData.isEmpty
                  ? Center(child: Text("No forecast data available", style: TextStyle(fontSize: 18)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: forecastData.length,
                      itemBuilder: (context, index) {
                        final item = forecastData[index];
                        return WeatherRow(
                          dateTime: item['dateTime'],
                          weather: item['weather'],
                          degree: item['degree'],
                        );
                      },
                    ),
            )
          ],
        ),
      )
    );
  }
}