import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeatherRow extends StatelessWidget {
  final String day;
  final String weather;
  final String degree;

  const WeatherRow({
    Key? key,
    required this.day,
    required this.weather,
    required this.degree,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0), // Space between rows
      child: Container(
        width: screenWidth * 0.9, // 90% of the screen width
        height: 100,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 61, 98, 108).withOpacity(0.75),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // Uniform padding inside
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out items
            crossAxisAlignment: CrossAxisAlignment.center, // Align vertically in the center
            children: [
              // Day Text
              Text(
                day,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              // Weather Forecast Icon and Text
              Row(
                children: [
                  Icon(
                    CupertinoIcons.cloud,
                    color: Colors.white,
                    size: 40
                  ),
                  const SizedBox(width: 8), // Spacing between icon and text
                  Text(
                    weather,
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              // Temperature Text
              Text(
                degree,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}