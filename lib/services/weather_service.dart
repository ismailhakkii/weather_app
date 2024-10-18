import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:havadurumu/models/weather_model.dart';

class WeatherService {
  
  // Kullanıcının mevcut konumunu alacak fonksiyon
  Future<String> _getLocation() async {
    // Konum servisinin açık olup olmadığını kontrol et
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Konum servisiniz kapalı");
    }

    // Kullanıcıdan konum izni alınıp alınmadığını kontrol et
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Konum izni vermelisiniz");
      }
    }

    // Kullanıcının mevcut pozisyonunu al
    final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Koordinatlara göre yerleşim bilgisini bul
    final List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    // Şehir bilgisini elde et
    final String? city = placemark[0].administrativeArea;

    if (city == null) {
      return Future.error("Bir sorun oluştu");
    }

    return city;
  }

  // Hava durumu verilerini getir
  Future<List<WeatherModel>> getWeatherData({String? city}) async {
    // Eğer şehir adı verilmediyse, kullanıcının mevcut konumunu al
    final String location = city ?? await _getLocation();

    // API çağrısı için URL
    final String url =
        "https://api.collectapi.com/weather/getWeather?data.lang=tr&data.city=$location";
    
    // API için gerekli başlıklar (Authorization)
    const Map<String, dynamic> headers = {
      'authorization': "apikey 3JUEYUMUiqF0gLWws2xJYT:5Y8Cndw23r3jDNbndrYk9v",
      "content-type": "application/json"
    };

    // Dio kütüphanesi ile HTTP isteği gönderiyoruz
    final dio = Dio();

    // API'ye GET isteği yapıyoruz
    final response = await dio.get(url, options: Options(headers: headers));

    // Eğer yanıt başarılı değilse hata döndür
    if (response.statusCode != 200) {
      return Future.error("Bir sorun oluştu");
    }

    // Gelen veri listesi
    final List list = response.data['result'];

    // JSON'dan model objelerine dönüştür
    final List<WeatherModel> weatherList =
        list.map((e) => WeatherModel.fromJson(e)).toList();

    return weatherList; // Hava durumu modellerini döndür
  }
}
