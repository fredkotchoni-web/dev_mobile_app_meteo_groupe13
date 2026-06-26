class PrevisionJour {
  final String date;
  final double tempMax;
  final double tempMin;
  final int weatherCode;

  PrevisionJour({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.weatherCode,
  });

  String get conditionTexte {
    if (weatherCode == 0) return 'Ensoleille';
    if (weatherCode <= 3) return 'Nuageux';
    if (weatherCode >= 51 && weatherCode <= 67) return 'Pluvieux';
    if (weatherCode >= 80 && weatherCode <= 82) return 'Averses';
    if (weatherCode >= 95) return 'Orageux';
    return 'Variable';
  }

  // EXERCICE A
  String get dateFormatee {
    try {
      final dateTime = DateTime.parse(date);
      final jour = dateTime.day.toString().padLeft(2, '0');
      final mois = dateTime.month.toString().padLeft(2, '0');
      return '$jour/$mois';
    } catch (e) {
      return date;
    }
  }
}
