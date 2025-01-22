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

  Icon weatherListIcon = Icon(Icons.error);

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

          //DisplayWeather displayWeather = getDisplayListIcon(currCond);
          //weatherListIcon = displayWeather.weatherIcon;

          hourlyForecast.add({
            'dateTime': formattedTime,
            'weather': currCondDesc,
            'degree': '${currTemp.toStringAsFixed(0)}° ',
            'weatherNum': currCond.toStringAsFixed(1),
            'weatherListIcon': getDisplayListIcon(currCond).weatherIcon,
            'rain': rainVol.toStringAsFixed(0)
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

Color getWeatherColor() {
  var currTime = new DateTime.now();
  if (currTime.hour >= 17 && currTime.hour < 7) {
    return Colors.white;
  }
  else {
    return Colors.black;
  }
}

DisplayWeather getDisplayWeather(int currCond) {

    var currTime = new DateTime.now();

    if (currCond < 600) {
      return DisplayWeather(
        weatherIcon: Icon(
          CupertinoIcons.cloud_rain,
          color: getWeatherColor(),
          size: 100
        ),
        weatherImage: const AssetImage('assets/cloudy.png'),
      );
    }
    else if (currCond >= 600 && currCond < 700) {
      return DisplayWeather(
        weatherIcon: Icon(
          CupertinoIcons.cloud_snow,
          color: getWeatherColor(),
          size: 100
        ),
        weatherImage: const AssetImage('assets/cloudy.png'),
      );
    } 
    else if (currCond >= 700 && currCond < 800) {
      return DisplayWeather(
        weatherIcon: Icon(
          CupertinoIcons.cloud_fog,
          color: getWeatherColor(),
          size: 100
        ),
        weatherImage: const AssetImage('assets/cloudy.png'),
      );
    }
    else if (currCond == 800) {
      if (currTime.hour >= 17 && currTime.hour < 7) {
        return DisplayWeather(
          weatherIcon: Icon(
            CupertinoIcons.moon,
            color: getWeatherColor(),
            size: 100
          ),
          weatherImage: const AssetImage('assets/night.png'),
        );
      }
      else {
        return DisplayWeather(
          weatherIcon: Icon(
            CupertinoIcons.sun_max,
            color: getWeatherColor(),
            size: 100
          ),
          weatherImage: const AssetImage('assets/sunny.png'),
        );
      }
    }
    else {
      return DisplayWeather(
        weatherIcon: Icon(
          CupertinoIcons.cloud,
          color: getWeatherColor(),
          size: 100
        ),
        weatherImage: const AssetImage('assets/cloudy.png'),
      );
    }
}

DisplayWeather getDisplayListIcon(int currCond) {

    var currTime = new DateTime.now();

    if (currCond < 600) {
      return DisplayWeather(
        weatherIcon: const Icon(
          CupertinoIcons.cloud_rain,
          color: Colors.white,
          size: 30
        ),
        weatherImage: const AssetImage('assets/cloudy.png'),
      );
    }
    else if (currCond >= 600 && currCond < 700) {
      return DisplayWeather(
        weatherIcon: const Icon(
          CupertinoIcons.cloud_snow,
          color: Colors.white,
          size: 30
        ),
        weatherImage: const AssetImage('assets/cloudy.png'),
      );
    } 
    else if (currCond >= 700 && currCond < 800) {
      return DisplayWeather(
        weatherIcon: const Icon(
          CupertinoIcons.cloud_fog,
          color: Colors.white,
          size: 30
        ),
        weatherImage: const AssetImage('assets/cloudy.png'),
      );
    }
    else if (currCond == 800) {
      if (currTime.hour >= 17 && currTime.hour < 7) {
        return DisplayWeather(
          weatherIcon: const Icon(
            CupertinoIcons.moon,
            color: Colors.white,
            size: 30
          ),
          weatherImage: const AssetImage('assets/night.png'),
        );
      }
      else {
        return DisplayWeather(
          weatherIcon: const Icon(
            CupertinoIcons.sun_max,
            color: Colors.white,
            size: 30
          ),
          weatherImage: const AssetImage('assets/sunny.png'),
        );
      }
    }
    else {
      return DisplayWeather(
        weatherIcon: const Icon(
          CupertinoIcons.cloud,
          color: Colors.white,
          size: 30
        ),
        weatherImage: const AssetImage('assets/cloudy.png'),
      );
    }
}