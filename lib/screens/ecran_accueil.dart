import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/ville_viewmodel.dart';
import 'ecran_liste_villes.dart';

class EcranAccueil extends StatelessWidget {
  const EcranAccueil({super.key});

  // Retourne une icone selon la condition meteo
  IconData _iconeMeteo(String condition) {
    switch (condition) {
      case 'Ensoleille':
        return Icons.wb_sunny;
      case 'Nuageux':
        return Icons.cloud;
      case 'Pluvieux':
        return Icons.umbrella;
      // EXERCICE A
      case 'Orageux':
        return Icons.thunderstorm;
      case 'Ventueux':
        return Icons.air;
      // FIN EXERCICE A
      default:
        return Icons.wb_cloudy;
    }
  }

  // RETOURNE UNIQUEMENT LES TROIS COULEURS DEMANDÉES
  Color _couleurFond(String condition) {
    switch (condition) {
      case 'Ensoleille':
        return Colors.orange[100]!; // fond orange clair
      case 'Nuageux':
        return Colors.grey[300]!; // fond gris clair
      case 'Pluvieux':
        return Colors.blue[100]!; // fond bleu clair
      default:
        return Colors
            .white; // blanc par défaut pour le reste (Orageux, Ventueux, etc.)
    }
  }

  @override
  Widget build(BuildContext context) {
    // On lit les donnees depuis le ViewModel
    final vm = context.watch<VilleViewModel>();
    final ville = vm.villeSelectionnee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AppMeteo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ville == null
          ? const Center(child: CircularProgressIndicator())
          : Container(
              width: double.infinity, // Prend tout l'écran
              height: double.infinity, // Prend tout l'écran
              decoration: BoxDecoration(
                color: _couleurFond(
                  ville.condition,
                ), // Application stricte des 3 couleurs
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icone meteo
                    Icon(
                      _iconeMeteo(ville.condition),
                      size: 100,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 16),

                    // Temperature
                    Text(
                      '${ville.temperature.toStringAsFixed(0)} C',
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Nom de la ville
                    Text(
                      ville.nom,
                      style: TextStyle(fontSize: 28, color: Colors.grey[700]),
                    ),

                    const SizedBox(height: 12),

                    // Condition et humidite
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(
                          0.6,
                        ), // Fond blanc transparent pour la lisibilité
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${ville.condition} - Humidité : ${ville.humidite}%',
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Bouton pour voir la liste des villes
                    ElevatedButton.icon(
                      icon: const Icon(Icons.list),
                      label: const Text('Changer de ville'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EcranListeVilles(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
