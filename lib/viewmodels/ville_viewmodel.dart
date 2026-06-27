import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

  // --- VARIABLES EXERCICE B ---
  List<double>? _gpsCoordsActuelles;
  List<double>? get gpsCoordsActuelles => _gpsCoordsActuelles;
  // -----------------------------

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
    ];

    // Initialisation de la première ville avec ses coordonnées GPS
    if (_villes.isNotEmpty) {
      _villeSelectionnee = _villes.first;
      _mettreAJourGpsCoords(_villes.first.nom);
    }
    notifyListeners(); // prevenir les widgets
  }

  void ajouterVille(Ville ville) {
    _villes.add(ville);
    notifyListeners();
  }

  // Mettre a jour la photo de la ville selectionnee
  void mettreAJourPhoto(String cheminPhoto) {
    if (_villeSelectionnee == null) return;

    // Trouver l’index de la ville dans la liste
    final index = _villes.indexWhere((v) => v.nom == _villeSelectionnee!.nom);
    if (index == -1) return;

    // Creer une copie avec la nouvelle photo
    _villes[index] = _villes[index].copierAvecPhoto(cheminPhoto);
    _villeSelectionnee = _villes[index];

    notifyListeners(); // prevenir les widgets
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

  // EXERCICE B : Méthode interne de mise à jour des coordonnées GPS
  void _mettreAJourGpsCoords(String nomVille) {
    final nomVilleMinuscule = nomVille.toLowerCase();

    final cleMap = MeteoService.coords.keys.firstWhere(
      (k) => k.toLowerCase() == nomVilleMinuscule,
      orElse: () => '',
    );

    if (cleMap.isNotEmpty) {
      _gpsCoordsActuelles = MeteoService.coords[cleMap];
    } else {
      _gpsCoordsActuelles = null;
    }
  }

  // EXERCICE C MODIFIÉ ET SÉCURISÉ
  Future<void> selectionnerVille(Ville ville) async {
    _villeSelectionnee = ville;
    _erreur = null;

    // EXERCICE B : Récupération des coordonnées GPS
    _mettreAJourGpsCoords(ville.nom);

    // EXERCICE C : Gestion du cache local
    final cacheExistant = _cacheMeteo[ville.nom];

    if (cacheExistant != null && !cacheExistant.estExpire) {
      _meteoActuelle = cacheExistant.meteo;
      _chargement = false;
      notifyListeners();
      return;
    }

    _chargement = true;
    notifyListeners();

    try {
      // Appel réseau qui peut potentiellement échouer (connexion, timeout, format de réponse)
      final meteo = await _meteoService.getMeteo(ville.nom);

      if (meteo != null) {
        _meteoActuelle = meteo;

        // Mettre en cache local
        _cacheMeteo[ville.nom] = ElementCache(
          meteo: meteo,
          timestamp: DateTime.now(),
        );

        // Appels des notifications
        await _verifierAlerteChaleur();
        await _planifierNotificationMeteoQuotidienne();
      } else {
        _erreur = 'Impossible de charger la météo de ${ville.nom}';
      }
    } catch (e) {
      // Capture l'erreur si le service plante ou si le réseau est coupé
      _erreur = 'Erreur réseau ou serveur : $e';
    } finally {
      // BLOC CRITIQUE : Quoi qu'il arrive (succès ou échec), on arrête le chargement
      _chargement = false;
      notifyListeners();
    }
  }

  // Dans le ViewModel, apres avoir charge la meteo :
  Future<void> _verifierAlerteChaleur() async {
    if (_meteoActuelle == null) return;
    if (_meteoActuelle!.temperature > 33) {
      final plugin = FlutterLocalNotificationsPlugin();
      const AndroidNotificationDetails details = AndroidNotificationDetails(
        'canal_alerte',
        'Alertes Meteo',
        importance: Importance.high,
        priority: Priority.high,
      );
      await plugin.show(
        1,
        'Alerte chaleur !',
        'Il fait ${_meteoActuelle!.temperature.toStringAsFixed(0)}C a ${_villeSelectionnee!.nom}',
        NotificationDetails(android: details),
      );
    }
  }

  // --- EXERCICE C : NOTIFICATION PROGRAMMÉE (RAPPEL QUOTINIEN) ---
  Future<void> _planifierNotificationMeteoQuotidienne() async {
    if (_meteoActuelle == null || _villeSelectionnee == null) return;

    final plugin = FlutterLocalNotificationsPlugin();

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'canal_quotidien_meteo',
          'Météo Matinale',
          channelDescription: 'Rappel quotidien de la météo à 7h00',
          importance: Importance.high,
          priority: Priority.high,
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await plugin.periodicallyShow(
      2,
      'Votre météo du jour ☀️',
      'Il est prévu ${_meteoActuelle!.temperature.toStringAsFixed(0)}°C (${_meteoActuelle!.conditionTexte}) à ${_villeSelectionnee!.nom}.',
      RepeatInterval.daily,
      platformDetails,
      androidAllowWhileIdle: true,
    );
  }
}
