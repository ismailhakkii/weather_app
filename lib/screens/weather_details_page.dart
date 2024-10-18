import 'package:flutter/material.dart';
import 'package:havadurumu/models/weather_model.dart';

class WeatherDetailsPage extends StatelessWidget {
  final WeatherModel weather;

  const WeatherDetailsPage({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${weather.gun} Weather Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              weather.durum,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            Image.network(weather.ikon, width: 100),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Min: ${weather.min}°"),
                    Text("Max: ${weather.max}°"),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Night: ${weather.gece}°"),
                    Text("Humidity: ${weather.nem}%"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Ek detaylar burada eklenebilir
            const Text("More detailed information coming soon..."),
          ],
        ),
      ),
    );
  }
}
