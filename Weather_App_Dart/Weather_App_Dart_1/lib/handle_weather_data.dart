import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherPullData {

  double currTemp = 0;
  int currCond = 0;
  double rainVol = 0;

  String apiId = '';

  Future<void> getWeatherData() async {
    http.Response resp = await http.get(
      Uri.parse('http://api.openweathermap.org/data/2.5/weather?lat=43.89898760416283&lon=-78.94788446422257&appid=$apiId&units=metric')
    );

    if (resp.statusCode == 200) {
      String data = resp.body;
      var currentWeather = jsonDecode(data);

      try {
        currTemp = currentWeather['main']['temp'];
        currCond = currentWeather['weather'][0]['id'];
        rainVol = currentWeather['rain']['1h'];
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