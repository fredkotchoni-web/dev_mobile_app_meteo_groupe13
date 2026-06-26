import 'package:flutter/foundation.dart';
import '../models/ville.dart';
import '../services/meteo_service.dart';
import '../models/meteo_data.dart';

// EXERCICE C CACHE LOCAL
class ElementCache {
  final MeteoData meteo;
  final DateTime timestamp;

  ElementCache({required this.meteo, required this.timestamp});

  // EXERCICE C
  bool get estExpire {
    final difference = DateTime.now().difference(timestamp);
    return difference.inMinutes >= 30;
  }
}

class VilleViewModel extends ChangeNotifier {
  // La liste des villes disponibles
  List<Ville> _villes = [];

  // La ville actuellement selectionnee
  Ville? _villeSelectionnee;

  List<Ville> get villes => _villes;
  Ville? get villeSelectionnee => _villeSelectionnee;

  // Constructeur : charger des donnees au demarrage
  VilleViewModel() {
    _initialiser();
  }

  void _initialiser() {
    _villes = [
      Ville(
        nom: 'Cotonou',
        pays: 'Benin',
        temperature: 29,
        condition: 'Ensoleille',
        humidite: 75,
      ),
      Ville(
        nom: 'Parakou',
        pays: 'Benin',
        temperature: 32,
        condition: 'Ensoleille',
        humidite: 60,
      ),
      Ville(
        nom: 'Lagos',
        pays: 'Nigeria',
        temperature: 31,
        condition: 'Nuageux',
        humidite: 80,
      ),
      Ville(
        nom: 'Abidjan',
        pays: 'CI',
        temperature: 27,
        condition: 'Pluvieux',
        humidite: 85,
      ),
      // EXERCICE A
      Ville(
        nom: 'Ouèssè',
        pays: 'Benin',
        temperature: 32,
        condition: 'Orageux',
        humidite: 82,
      ),
      Ville(
        nom: 'KARA',
        pays: 'Togo',
        temperature: 31,
        condition: 'Ventueux',
        humidite: 68,
      ),
      Ville(
        nom: 'Tokyo',
        pays: 'JAPON',
        temperature: 50,
        condition: 'Orageux',
        humidite: 54,
      ),
      // FIN EXERCICE B
    ];
    _villeSelectionnee = _villes.first;
    notifyListeners(); // prevenir les widgets
  }

  void ajouterVille(Ville ville) {
    _villes.add(ville);
    notifyListeners();
  }

  final MeteoService _meteoService = MeteoService();
  MeteoData? _meteoActuelle;
  bool _chargement = false;
  String? _erreur;

  // EXERCICE C
  final Map<String, ElementCache> _cacheMeteo = {};

  MeteoData? get meteoActuelle => _meteoActuelle;
  bool get chargement => _chargement;
  String? get erreur => _erreur;

  // EXERCICE C
  Future<void> selectionnerVille(Ville ville) async {
    _villeSelectionnee = ville;
    _erreur = null;

    // EXERCICE C
    final cacheExistant = _cacheMeteo[ville.nom];

    if (cacheExistant != null && !cacheExistant.estExpire) {
      // EXERCICE C
      _meteoActuelle = cacheExistant.meteo;
      _chargement = false;
      notifyListeners();
      return;
    }

    _chargement = true;
    notifyListeners();

    final meteo = await _meteoService.getMeteo(ville.nom);

    if (meteo != null) {
      _meteoActuelle = meteo;

      // EXERCICE C CACHE LOCAL
      _cacheMeteo[ville.nom] = ElementCache(
        meteo: meteo,
        timestamp: DateTime.now(),
      );
    } else {
      _erreur = 'Impossible de charger la meteo';
    }
    _chargement = false;
    notifyListeners();
  }
}
