import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class WeatherPullData {

  int timeStamp = 0;
  double currTemp = 0;
  int currCond = 0;
  double rainVol = 0;
  String currCondDesc = '';

  List<Map<String, dynamic>> hourlyForecast = [];

  String apiId = '8bad9ee0580bfd7f63cd45c54a2050bf';

  Future<void> getWeatherData() async {
    http.Response resp = await http.get(
      Uri.parse('http://api.openweathermap.org/data/2.5/forecast?lat=43.89898760416283&lon=-78.94788446422257&appid=$apiId&units=metric')
    );

    if (resp.statusCode == 200) {
      String data = resp.body;
      var currentWeather = jsonDecode(data);

      try {
        List<dynamic> hourlyWeather = currentWeather['list'];

        hourlyForecast.clear();

        for (int i = 0; i < 12; i++) {
          var weatherItem = hourlyWeather[i];

          timeStamp = weatherItem['dt'];
          currTemp = weatherItem['main']['temp'];
          currCond = weatherItem['weather'][0]['id'];
          rainVol = weatherItem.containsKey('rain') && weatherItem['rain'] != null
            ? weatherItem['rain']['3h'] ?? 0.0
            : 0.0;
          currCondDesc = weatherItem['weather'][0]['description'];

          DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
          String formattedTime = DateFormat('h a').format(dateTime).toLowerCase();

          // currTemp = currentWeather['main']['temp'];
          // currCond = currentWeather['weather'][0]['id'];
          // rainVol = currentWeather['rain']['1h'];

          hourlyForecast.add({
            'dateTime': formattedTime,
            'weather': currCondDesc,
            'degree': '${currTemp.toStringAsFixed(0)}° ',
            'weatherNum': currCond.toStringAsFixed(1),
            'rain': rainVol.toStringAsFixed(1)
          });
          // / ${rainVol.toStringAsFixed(1)} mm
        }
      } 
      
      catch (e) {
        print(e);
      }
    }

    else {
      print('Error data was not pulled');
    }
  }
}

class DisplayWeather {
  Icon weatherIcon;
  AssetImage weatherImage;

  DisplayWeather({required this.weatherIcon, required this.weatherImage});
}

DisplayWeather getDisplayWeather(int currCond) {

    var currTime = new DateTime.now();

    if (currCond < 600) {
      return DisplayWeather(
        weatherIcon: const Icon(
          CupertinoIcons.cloud_rain,
          color: Colors.black,
          size: 100.0
        ),
        weatherImage: const AssetImage('assets/cloudy.png'),
      );
    } 
    else if (currTime.hour >= 17) {
      return DisplayWeather(
        weatherIcon: const Icon(
          CupertinoIcons.moon,
          color: Colors.black,
          size: 100.0
        ),
        weatherImage: const AssetImage('assets/night.png'),
      );
    }
    else {
      return DisplayWeather(
        weatherIcon: const Icon(
          CupertinoIcons.sun_max,
          color: Colors.black,
          size: 100.0
        ),
        weatherImage: const AssetImage('assets/sunny.png'),
      );
    }
}