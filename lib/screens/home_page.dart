import 'package:flutter/material.dart';
import 'package:havadurumu/models/weather_model.dart';
import 'package:havadurumu/screens/weather_details_page.dart';
import 'package:havadurumu/services/weather_service.dart';

class HomePage extends StatefulWidget {
  final Function toggleTheme; // Tema değiştirme fonksiyonu
  final bool isDarkMode; // Tema durumu

  const HomePage({Key? key, required this.toggleTheme, required this.isDarkMode}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<WeatherModel> _weathers = [];
  final TextEditingController _cityController = TextEditingController(); // Şehir adı girişi için controller

  void _getWeatherData([String? city]) async {
    _weathers = await WeatherService().getWeatherData(city: city);
    setState(() {});
  }

  @override
  void initState() {
    _getWeatherData(); // Uygulama başlarken kendi konumunu kullanarak veri çeker
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.dark_mode : Icons.light_mode), // Dark/Light mode butonu
            onPressed: () {
              widget.toggleTheme(); // Tema değiştirme fonksiyonunu çağır
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _cityController, // Şehir adı girilecek
              decoration: const InputDecoration(
                hintText: "Enter city name", // Girdi alanı için placeholder
                suffixIcon: Icon(Icons.search), // Arama ikonu
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _getWeatherData(value); // Şehir adı girildiyse o şehrin hava durumu verisi çekilir
                }
              },
            ),
          ),
          Expanded(
            child: _weathers.isEmpty
                ? const Center(child: CircularProgressIndicator()) // Eğer veri yoksa yüklenme animasyonu
                : ListView.builder(
                    itemCount: _weathers.length,
                    itemBuilder: (context, index) {
                      final WeatherModel weather = _weathers[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    WeatherDetailsPage(weather: weather)), // Detay sayfasına yönlendirme
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AnimatedIcon(weather.ikon), // Animasyonlu ikon
                                Text(
                                  weather.gun,
                                  style: const TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "${weather.durum.toUpperCase()} ${weather.derece}°",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text("Min: ${weather.min}°"),
                                        Text("Max: ${weather.max}°"),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text("Night: ${weather.gece}°"),
                                        Text("Humidity: ${weather.nem}%"),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// Hava durumu ikonu için animasyonlu widget
Widget AnimatedIcon(String iconUrl) {
  return TweenAnimationBuilder(
    tween: Tween<double>(begin: 0, end: 1),
    duration: const Duration(seconds: 2),
    builder: (BuildContext context, double opacity, Widget? child) {
      return Opacity(
        opacity: opacity,
        child: Image.network(iconUrl, width: 80), // Hava durumu ikonu
      );
    },
  );
}
