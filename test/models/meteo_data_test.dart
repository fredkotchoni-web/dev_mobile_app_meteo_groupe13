import 'package:flutter_test/flutter_test.dart';
import 'package:app_meteo/models/meteo_data.dart';

void main() {
  // =========================================================================
  // EXERCICE A : Tests des codes WMO
  // =========================================================================
  group('MeteoData - Tests des codes WMO (Exercice A)', () {
    // --- TEST 1 : Nuageux (Codes 1 à 3) ---
    test('Doit retourner "Nuageux" pour les codes WMO 1, 2 et 3', () {
      // 1. Arrange (Préparer)
      final dataCode1 = MeteoData(
        weatherCode: 1,
        temperature: 25.0,
        humidite: 70,
        time: '2026-06-29T12:00',
        previsions: [],
      );
      final dataCode3 = MeteoData(
        weatherCode: 3,
        temperature: 25.0,
        humidite: 70,
        time: '2026-06-29T12:00',
        previsions: [],
      );

      // 2. Act (Agir)
      final resultat1 = dataCode1.conditionTexte;
      final resultat3 = dataCode3.conditionTexte;

      // 3. Assert (Vérifier)
      expect(resultat1, equals('Nuageux'));
      expect(resultat3, equals('Nuageux'));
    });

    // --- TEST 2 : Averses (Codes 80 à 82) ---
    test('Doit retourner "Averses" pour les codes WMO 80, 81 et 82', () {
      // 1. Arrange (Préparer)
      final dataCode80 = MeteoData(
        weatherCode: 80,
        temperature: 22.0,
        humidite: 85,
        time: '2026-06-29T12:00',
        previsions: [],
      );
      final dataCode82 = MeteoData(
        weatherCode: 82,
        temperature: 22.0,
        humidite: 85,
        time: '2026-06-29T12:00',
        previsions: [],
      );

      // 2. Act (Agir)
      final resultat80 = dataCode80.conditionTexte;
      final resultat82 = dataCode82.conditionTexte;

      // 3. Assert (Vérifier)
      expect(resultat80, equals('Averses'));
      expect(resultat82, equals('Averses'));
    });

    // --- TEST 3 : Orageux (Codes 95+) ---
    test(
      'Doit retourner "Orageux" pour les codes WMO supérieurs ou égaux à 95',
      () {
        // 1. Arrange (Préparer)
        final dataCode95 = MeteoData(
          weatherCode: 95,
          temperature: 20.0,
          humidite: 90,
          time: '2026-06-29T12:00',
          previsions: [],
        );
        final dataCode99 = MeteoData(
          weatherCode: 99,
          temperature: 20.0,
          humidite: 90,
          time: '2026-06-29T12:00',
          previsions: [],
        );

        // 2. Act (Agir)
        final resultat95 = dataCode95.conditionTexte;
        final resultat99 = dataCode99.conditionTexte;

        // 3. Assert (Vérifier)
        expect(resultat95, equals('Orageux'));
        expect(resultat99, equals('Orageux'));
      },
    );

    // --- TEST 4 : Code inconnu (Variable) ---
    test(
      'Doit retourner "Variable" pour un code WMO non répertorié (ex: 45)',
      () {
        // 1. Arrange (Préparer)
        final dataCodeInconnu = MeteoData(
          weatherCode: 45,
          temperature: 25.0,
          humidite: 60,
          time: '2026-06-29T12:00',
          previsions: [],
        );

        // 2. Act (Agir)
        final resultatInconnu = dataCodeInconnu.conditionTexte;

        // 3. Assert (Vérifier)
        expect(resultatInconnu, equals('Variable'));
      },
    );
  });

  // =========================================================================
  // EXERCICE B : Tests de la méthode estDangereux()
  // =========================================================================
  group('MeteoData - Tests de estDangereux() (Exercice B)', () {
    // --- TEST 1 : Chaud + Orage ---
    test(
      'Doit retourner true si la température > 40°C ET weatherCode >= 95',
      () {
        // 1. Arrange (Préparer)
        final meteoDangereuse = MeteoData(
          temperature: 42.5, // Chaud (>40)
          weatherCode: 96, // Orage (>=95)
          humidite: 50,
          time: '2026-06-29T12:00',
          previsions: [],
        );

        // 2. Act (Agir)
        final resultat = meteoDangereuse.estDangereux();

        // 3. Assert (Vérifier)
        expect(resultat, isTrue);
      },
    );

    // --- TEST 2 : Chaud seul ---
    test('Doit retourner true si la température > 40°C mais météo calme', () {
      // 1. Arrange (Préparer)
      final caniculeSeule = MeteoData(
        temperature: 41.0, // Chaud (>40)
        weatherCode: 0, // Ensoleillé
        humidite: 30,
        time: '2026-06-29T12:00',
        previsions: [],
      );

      // 2. Act (Agir)
      final resultat = caniculeSeule.estDangereux();

      // 3. Assert (Vérifier)
      expect(resultat, isTrue);
    });

    // --- TEST 3 : Orage seul ---
    test(
      'Doit retourner true si temps orageux malgré une température douce',
      () {
        // 1. Arrange (Préparer)
        final orageSeul = MeteoData(
          temperature: 24.0, // Normal
          weatherCode: 95, // Orage (>=95)
          humidite: 90,
          time: '2026-06-29T12:00',
          previsions: [],
        );

        // 2. Act (Agir)
        final resultat = orageSeul.estDangereux();

        // 3. Assert (Vérifier)
        expect(resultat, isTrue);
      },
    );

    // --- TEST 4 : Conditions normales ---
    test('Doit retourner false si la température et le temps sont normaux', () {
      // 1. Arrange (Préparer)
      final meteoNormale = MeteoData(
        temperature: 28.0, // Normal
        weatherCode: 1, // Nuageux
        humidite: 65,
        time: '2026-06-29T12:00',
        previsions: [],
      );

      // 2. Act (Agir)
      final resultat = meteoNormale.estDangereux();

      // 3. Assert (Vérifier)
      expect(resultat, isFalse);
    });
  });
}
