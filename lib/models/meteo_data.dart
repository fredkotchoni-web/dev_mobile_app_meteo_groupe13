import 'prevision_jour.dart';

class MeteoData {
  final double temperature;
  final int humidite;
  final int weatherCode;
  final String time;
  final List<PrevisionJour> previsions;

  MeteoData({
    required this.temperature,
    required this.humidite,
    required this.weatherCode,
    required this.time,
    required this.previsions,
  });

  factory MeteoData.fromJson(Map json) {
    final currentJson = json['current'];

    final dailyJson = json['daily'];
    List<PrevisionJour> listePrevisions = [];

    if (dailyJson != null) {
      final dates = dailyJson['time'] as List;
      final maxs = dailyJson['temperature_2m_max'] as List;
      final mins = dailyJson['temperature_2m_min'] as List;
      final codes = dailyJson['weathercode'] as List;

      for (int i = 0; i < 3 && i < dates.length; i++) {
        listePrevisions.add(
          PrevisionJour(
            date: dates[i] as String,
            tempMax: (maxs[i] as num).toDouble(),
            tempMin: (mins[i] as num).toDouble(),
            weatherCode: (codes[i] as num).toInt(),
          ),
        );
      }
    }

    return MeteoData(
      temperature: (currentJson['temperature_2m'] as num).toDouble(),
      humidite: (currentJson['relative_humidity_2m'] as num).toInt(),
      weatherCode: (currentJson['weathercode'] as num).toInt(),
      time: currentJson['time'] as String,
      previsions: listePrevisions,
    );
  }

  String get conditionTexte {
    if (weatherCode == 0) return 'Ensoleille';
    if (weatherCode <= 3) return 'Nuageux';
    if (weatherCode >= 51 && weatherCode <= 67) return 'Pluvieux';
    if (weatherCode >= 80 && weatherCode <= 82) return 'Averses';
    if (weatherCode >= 95) return 'Orageux';
    return 'Variable';
  }

  String get dateFormatee {
    try {
      final dateTime = DateTime.parse(time);
      final jour = dateTime.day.toString().padLeft(2, '0');
      final mois = dateTime.month.toString().padLeft(2, '0');
      final annee = dateTime.year;
      final heure = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');
      return 'Mesure du $jour/$mois/$annee ${heure}h$minute';
    } catch (e) {
      return 'Date inconnue';
    }
  }
}
