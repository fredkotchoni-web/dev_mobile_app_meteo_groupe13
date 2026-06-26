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
      case 'Orageux':
        return Icons.thunderstorm;
      case 'Ventueux':
        return Icons.air;
      default:
        return Icons.wb_cloudy;
    }
  }

  // RETOURNE UNIQUEMENT LES TROIS COULEURS DEMANDÉES
  Color _couleurFond(String condition) {
    switch (condition) {
      case 'Ensoleille':
        return Colors.orange[100]!;
      case 'Nuageux':
        return Colors.grey[300]!;
      case 'Pluvieux':
        return Colors.blue[100]!;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<VilleViewModel>();
    final ville = vm.villeSelectionnee;

    final meteoData = vm.meteoActuelle;

    final conditionActuelle = (meteoData != null && vm.erreur == null)
        ? meteoData.conditionTexte
        : (ville?.condition ?? 'Inconnu');

    return Scaffold(
      appBar: AppBar(
        title: const Text('AppMeteo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ville == null
          ? const Center(child: CircularProgressIndicator())
          : Container(
              width: double.infinity,
              height: double.infinity,

              decoration: BoxDecoration(color: _couleurFond(conditionActuelle)),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),

                      Icon(
                        _iconeMeteo(conditionActuelle),
                        size: 100,
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 16),

                      // Nom de la ville
                      Text(
                        ville.nom,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Affichage dynamique via l'API
                      Consumer<VilleViewModel>(
                        builder: (context, vm, _) {
                          if (vm.chargement) {
                            return const CircularProgressIndicator();
                          }
                          if (vm.erreur != null) {
                            return Column(
                              children: [
                                const Icon(
                                  Icons.wifi_off,
                                  size: 60,
                                  color: Colors.red,
                                ),
                                Text(
                                  vm.erreur!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                                ElevatedButton(
                                  onPressed: () => vm.selectionnerVille(
                                    vm.villeSelectionnee!,
                                  ),
                                  child: const Text('Reessayer'),
                                ),
                              ],
                            );
                          }

                          final meteo = vm.meteoActuelle;
                          if (meteo == null) return const Text('Chargement...');

                          return Column(
                            children: [
                              Text(
                                '${meteo.temperature.toStringAsFixed(1)} °C',
                                style: const TextStyle(
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              // EXERCICE A - TP2
                              Text(
                                meteo.dateFormatee,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),

                              // EXERCICE A
                              Text(
                                '${meteo.conditionTexte} - ${meteo.humidite}% humidité',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[700],
                                ),
                              ),

                              const SizedBox(height: 24),

                              // EXERCICE B - TP2
                              const Text(
                                'Prévisions sur 3 jours',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // EXERCICE B - TP2
                              SizedBox(
                                height: 120,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: meteo.previsions.length,
                                  itemBuilder: (context, index) {
                                    final prev = meteo.previsions[index];
                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      elevation: 2,
                                      child: Container(
                                        width: 100,
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              prev.dateFormatee,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Icon(
                                              _iconeMeteo(prev.conditionTexte),
                                              color: Colors.blue,
                                              size: 28,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${prev.tempMax.toStringAsFixed(0)}° / ${prev.tempMin.toStringAsFixed(0)}°',
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
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
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
