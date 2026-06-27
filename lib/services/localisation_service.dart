import 'package:geolocator/geolocator.dart';
import '../models/ville.dart';

class LocalisationService {
  Future<Position?> getPosition() async {
    bool actif = await Geolocator.isLocationServiceEnabled();
    if (!actif) return null;

    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.deniedForever) return null;

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );
  }

  // Trouver la ville la plus proche dans une liste
  Ville? trouverVilleProche(
    Position position,
    List<Ville> villes,
    Map<String, List<double>> coordonnees,
  ) {
    Ville? plusProche;
    double distanceMin = double.infinity;

    for (final ville in villes) {
      // On cherche la clé dans la map en ignorant les majuscules/minuscules
      final cleMap = coordonnees.keys.firstWhere(
        (k) => k.toLowerCase() == ville.nom.toString().toLowerCase(),
        orElse: () => '',
      );

      if (cleMap.isEmpty)
        continue; // Si la ville n'est pas dans nos coordonnées, on passe

      final coords = coordonnees[cleMap]!;
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        coords[0],
        coords[1],
      );

      if (distance < distanceMin) {
        distanceMin = distance;
        plusProche = ville;
      }
    }
    return plusProche;
  }
}
