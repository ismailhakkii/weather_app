import 'package:flutter/material.dart';
import 'package:havadurumu/screens/home_page.dart';

void main() {
  runApp(const Home());
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Debug banner'ı kaldırır
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue, // Light mode için AppBar rengi
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black, // Dark mode için AppBar rengi
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light, // Tema modunu güncelle
      home: HomePage(
        toggleTheme: _toggleTheme, // Tema değiştirme fonksiyonunu aktar
        isDarkMode: _isDarkMode, // Dark mode durumunu aktar
      ),
    );
  }
}
